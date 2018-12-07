# Python Virtual Environments (defaulting to python3)
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON="$(command \which python3)"

if [ -f "/etc/redhat-release" ];
then
        export VIRTUALENVWRAPPER_VIRTUALENV="virtualenv-3.5"
fi

# Move vagrant home outside of /home
VAGRANT_HOME=/data/vagrant
