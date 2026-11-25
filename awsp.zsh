# awsp: pick the active AWS profile for this shell (a function, not a script,
# because it has to export into the calling shell). Loaded by antidote as part of
# this repo (allmightyroot/zshdotfiles), so it applies on Linux and the Mac alike.
#
#   awsp list         list the profiles you can switch to (* marks the active one)
#   awsp <profile>    switch to it
#
# SSO profiles (sso_session / sso_start_url in ~/.aws/config) get an
# `aws sso login`, but only when the cached session has expired. Static-key
# profiles (keys under [name] in ~/.aws/credentials) skip the login and just
# have their identity checked. Either way, stale AWS_* credential variables are
# cleared first so they can't override the profile.
#
# Over SSH, or on a Linux box with no display, the login uses the device-code
# flow: it prints a URL and a code to open on any device with a browser, instead
# of trying to open a browser locally. Force it anywhere with AWSP_DEVICE_CODE=1.
_awsp_is_sso() {
  [ -n "$(aws configure get sso_session --profile "$1" 2>/dev/null)" ] ||
  [ -n "$(aws configure get sso_start_url --profile "$1" 2>/dev/null)" ]
}

awsp() {
  if [ -z "$1" ] || [ "$1" = "list" ]; then
    local p kind
    [ -z "$1" ] && echo "Usage: awsp <profile> | awsp list" >&2
    echo "Profiles:" >&2
    for p in $(aws configure list-profiles); do
      if _awsp_is_sso "$p"; then kind="sso"; else kind="static keys"; fi
      printf '  %s %s (%s)\n' "$([ "$p" = "$AWS_PROFILE" ] && echo '*' || echo ' ')" "$p" "$kind" >&2
    done
    [ -z "$1" ] && return 1
    return 0
  fi

  local profile="$1"
  if ! aws configure list-profiles | grep -qxF -- "$profile"; then
    echo "awsp: no profile '$profile' (run: awsp list)" >&2
    return 1
  fi

  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  export AWS_PROFILE="$profile"
  export AWS_REGION="$(aws configure get region --profile "$profile")"
  export AWS_DEFAULT_REGION="$AWS_REGION"

  if _awsp_is_sso "$profile" && ! aws sts get-caller-identity >/dev/null 2>&1; then
    local flags=()
    if [ -n "$AWSP_DEVICE_CODE" ] || [ -n "$SSH_CONNECTION" ] ||
       { [[ $OSTYPE == linux* ]] && [ -z "$DISPLAY$WAYLAND_DISPLAY" ]; }; then
      flags=(--use-device-code --no-browser)
    fi
    aws sso login --profile "$profile" "${flags[@]}" || return 1
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
