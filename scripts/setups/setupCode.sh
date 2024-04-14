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

    # Install extensions
    as_normal_user "code --install-extension miguelsolorio.fluent-icons"
    as_normal_user "code --install-extension emmanuelbeziat.vscode-great-icons"
    as_normal_user "code --install-extension vscodevim.vim"
    as_normal_user "code --install-extension foxundermoon.shell-format"
    as_normal_user "code --install-extension esbenp.prettier-vscode"
    as_normal_user "code --install-extension GitHub.github-vscode-theme"

    CODE_CONFIG="$HOME/.config/Code/User/"
    as_normal_user "rm -rf $CODE_CONFIG"
    as_normal_user "mkdir -p $CODE_CONFIG"
    as_normal_user "cd $HOME/dotfiles/configs && stow --target="$HOME" code"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_code
fi
