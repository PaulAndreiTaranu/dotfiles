#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

function setup_code() {
    print_green '### SETTING UP VSCODE'

    if [ ! -e "/snap/bin/code" ]; then
        print_green '### INSTALLING VSCODE FROM SNAP'
        if_snap 'sudo snap install --classic code'
    else
        print_red '### VSCODE ALREADY INSTALLED'
    fi

    CODE_CONFIG="$HOME/.config/Code/User/"
    as_normal_user "rm -rf $CODE_CONFIG"
    as_normal_user "mkdir -p $CODE_CONFIG"
    as_normal_user "cd $HOME/dotfiles/configs && stow --target="$HOME" code"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_code
fi
