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
    array_to_remove=(
        $CODE_CONFIG
    )
    remove_with_array "${array_to_remove[@]}"
    as_normal_user "mkdir $CODE_CONFIG && cd $HOME/dotfiles && stow code"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_code
fi
