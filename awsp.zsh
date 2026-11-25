# awsp: pick the active AWS profile for this shell (a function, not a script,
# because it has to export into the calling shell). Loaded by antidote as part of
# this repo (allmightyroot/zshdotfiles), so it applies on Linux and the Mac alike.
#
#   awsp              list the profiles in ~/.aws/config and ~/.aws/credentials
#   awsp <profile>    switch to it
#
# SSO profiles (sso_session / sso_start_url in ~/.aws/config) get an
# `aws sso login`, but only when the cached session has expired. Static-key
# profiles (keys under [name] in ~/.aws/credentials) skip the login and just
# have their identity checked. Either way, stale AWS_* credential variables are
# cleared first so they can't override the profile.
awsp() {
  if [ -z "$1" ]; then
    echo "Usage: awsp <profile>" >&2
    echo "Profiles:" >&2
    aws configure list-profiles | sed 's/^/  /' >&2
    return 1
  fi

  local profile="$1"
  if ! aws configure list-profiles | grep -qxF -- "$profile"; then
    echo "awsp: no profile '$profile' (run awsp with no args to list them)" >&2
    return 1
  fi

  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  export AWS_PROFILE="$profile"
  export AWS_REGION="$(aws configure get region --profile "$profile")"
  export AWS_DEFAULT_REGION="$AWS_REGION"

  # Skip the browser login when the cached SSO session is still good.
  if [ -n "$(aws configure get sso_session --profile "$profile" 2>/dev/null)" ] ||
     [ -n "$(aws configure get sso_start_url --profile "$profile" 2>/dev/null)" ]; then
    aws sts get-caller-identity >/dev/null 2>&1 || aws sso login --profile "$profile" || return 1
  fi
  aws sts get-caller-identity
}

# Default every new shell to the SDG sandbox profile. This only sets variables
# (no login, no network, no aws call), so shell startup stays fast; the profile
# supplies the region itself; if the SSO session has
# expired, aws commands fail until you run `awsp sdgsandbox`. Skipped on hosts
# without that profile, and when AWS_PROFILE is already set (e.g. inherited
# from a parent shell, or set in an MCP server's env).
if [[ -z $AWS_PROFILE ]] && grep -qsF '[profile sdgsandbox]' ~/.aws/config; then
  export AWS_PROFILE=sdgsandbox
fi
