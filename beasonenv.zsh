# My GPG Key ID
export KEYID=0x2f580f2d4315f522

# Python Virtual Environments (defaulting to python3)
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON="$(command \which python3)"
OS=$(lsb_release -si)

if [ "$OS" = "Fedora" ];
then
        VIRTUALENV_PYTHON="/usr/bin/python3"
        GPG_TTY="$(tty)"
        SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)VIRTUALENV_PYTHON
        export VIRTUALENV_PYTHON GPG_TTY SSH_AUTH_SOCK
        gpgconf --launch gpg-agent
fi

if [ "$OS" = "Ubuntu" ]; 
then
        VIRTUALENV_PYTHON="/usr/bin/python3"
        GPG_TTY="$(tty)"
        SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        export VIRTUALENV_PYTHON GPG_TTY SSH_AUTH_SOCK
        gpgconf --launch gpg-agent
fi
      

# Move vagrant home outside of /home
export VAGRANT_HOME=/data/vagrant
