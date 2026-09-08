

# Beason's ZSH Aliases
alias ssh="ssh -q"
alias ls="ls -h --color=auto"
alias docker="sudo docker"

# Luks stuff
alias secbkopen="sudo cryptsetup luksOpen backups.lk securebackup"
alias secbkclose="sudo cryptsetup luksClose securebackup"
alias secbkmount="sudo mount /data/securebackup"
alias secbkumount="sudo umount /data/securebackup"

# Misc
# Download a page with assets, or mirror an entire site with -r
geturl() {
  if [ "$1" = "-r" ]; then
    shift
    wget -r --no-clobber --page-requisites --html-extension --convert-links "$@"
  else
    wget --no-clobber --page-requisites --html-extension --convert-links --no-host-directories "$@"
  fi
}
alias wx='curl wttr.in/MSP'

# Git
# Check whether origin's push URLs match the GitLab/GitHub/Bitbucket 3-mirror pattern
checkmirrors() {
  local count
  count=$(git remote get-url --all --push origin 2>/dev/null | wc -l)
  if [ "$count" -eq 0 ]; then
    echo "No origin remote configured." >&2
    return 1
  fi
  echo "origin has $count push URL(s):"
  git remote get-url --all --push origin
  [ "$count" -ge 3 ] || echo "Missing mirror(s) - expected 3 (GitLab/GitHub/Bitbucket)." >&2
}

# Python
# Create and activate a project venv with uv
mkvenv() {
  uv venv && source .venv/bin/activate
}

# AWS
# Switch AWS profile, clear stale static creds, and SSO login
awsp() {
  if [ -z "$1" ]; then
    echo "Usage: awsp <profile>" >&2
    return 1
  fi
  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  export AWS_PROFILE="$1"
  export AWS_REGION="$(aws configure get region --profile "$1")"
  aws sso login --profile "$1" || return 1
  aws sts get-caller-identity
}
