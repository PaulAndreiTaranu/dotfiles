#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

function setup_lazygit() {
    print_green '### SETTING UP LAZYGIT'

    if [ ! -e "/usr/bin/lazygit" ]; then
        print_green '### INSTALLING LAZYGIT'
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/bin
        sudo rm -rf lazygit.tar.gz lazygit
    else
        print_green '### LAZYGIT ALREADY INSTALLED'
    fi

    print_green '### ADDING DOTFILES'
    as_normal_user "rm -rf $HOME/.config/lazygit && mkdir -p $HOME/.config/lazygit"
    as_normal_user "cd $HOME/dotfiles/configs && stow --target="$HOME" lazygit"

}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_lazygit
fi
