

# Beason's ZSH Aliases
alias ssh="ssh -q"
alias ls="ls -h --color=auto"

# OS-specific aliases
if [[ $OSTYPE == darwin* ]]; then
  # The real binary is buried inside the app bundle
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
else
  alias docker="sudo docker"

  # Luks stuff
  alias secbkopen="sudo cryptsetup luksOpen backups.lk securebackup"
  alias secbkclose="sudo cryptsetup luksClose securebackup"
  alias secbkmount="sudo mount /data/securebackup"
  alias secbkumount="sudo umount /data/securebackup"
fi

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
alias wx='curl "wttr.in/MSP?u"'  # ?u = US customary (English) units

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
