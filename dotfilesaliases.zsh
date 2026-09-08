# Stuff from dotfiles (https://github.com/denysdovhan/dotfiles.git)
alias rm='rm -I'

# Commands Shortcuts
alias -- +x='chmod +x'
alias x+='chmod +x'

# Add an "alert" alias for long running commands.
# Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# My IP
alias myip="curl -s https://4.ifcfg.me/"

# Show $PATH in readable view
alias path='echo -e ${PATH//:/\\n}'

# Git root
# Change directory to root of git repository
alias gr='git rev-parse 2>/dev/null && cd "./$(git rev-parse --show-cdup)"'

# Download file with original filename
alias get="curl -O -L"
