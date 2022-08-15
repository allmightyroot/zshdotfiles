

# Beason's ZSH Aliases
alias ssh="ssh -q"
alias ls="ls -h --color=auto"
alias docker="sudo docker"
alias tf="terraform"

# Luks stuff
alias secbkopen="sudo cryptsetup luksOpen backups.lk securebackup"
alias secbkclose="sudo cryptsetup luksClose securebackup"
alias secbkmount="sudo mount /data/securebackup"
alias secbkumount="sudo umount /data/securebackup"

# SSHFS stuff
alias nfshomemount="sshfs mapls090:/home/g035006 /data/nashome"
alias nfshomeumount="fusermount -u /data/nashome"

# Misc
alias geturl='wget -r --no-clobber --page-requisites --html-extension --convert-links'
alias wx='curl wttr.in/MSP'

