# Python Virtual Environments (defaulting to python3)
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON="$(command \which python3)"
OS=$(lsb_release -si)

if [ -f "/etc/redhat-release" ];
then
        export VIRTUALENVWRAPPER_VIRTUALENV="virtualenv-3.5"
fi

if [ "$OS" = "Ubuntu" ]; 
then
        export VIRTUALENV_PYTHON="/usr/bin/python3"
fi
      

# Move vagrant home outside of /home
export VAGRANT_HOME=/data/vagrant
