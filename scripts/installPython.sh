#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

PYTHON_VERSION='3.12'

function installPythonVersion() {
    print_green "### INSTALLING PYTHON$PYTHON_VERSION"
    if is_ubuntu; then
        sudo apt install -y software-properties-common
        sudo add-apt-repository -y ppa:deadsnakes/ppa
        sudo apt update -y
        sudo apt install -y "python$PYTHON_VERSION"

        sudo rm -rf /bin/py
        sudo "ln /bin/python$PYTHON_VERSION /bin/py"

        sudo apt autoremove -y
    else
        print_red '### DISTRO NOT SUPPORTED'
        exit 1
    fi

}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    installPythonVersion
fi
