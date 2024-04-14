#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

function setup_fish() {
    print_green '### SETTING UP FISH'

    # Removing old config
    as_normal_user "rm -rf $HOME/.config/fish $HOME/.config/starship.toml"
    as_normal_user "mkdir -p $HOME/.config/fish"

    # Check if fish is installed
    if [ ! -e "/usr/bin/fish" ]; then
        if is_ubuntu; then
            print_green '### INSTALLING ZSH'
            sudo apt -y install fish
        else
            print_red '### DISTRO NOT SUPPORTED'
            exit 1
        fi
    else
        print_red '### FISH ALREADY INSTALLED'
    fi

    print_green '### INSTALLING STARSHIP PROMPT'
    sudo "curl -sS https://starship.rs/install.sh | sh"

    # Change default shell to fish
    print_red '### CHANGE DEFAULT SHELL TO FISH AND STOW CONFIG'
    sudo usermod --shell $(which fish) $USER

    # Installing plugin manager
    FISHER_LINK="https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish"
    as_fish_user "curl -sL $FISHER_LINK | source && fisher install jorgebucaran/fisher"

    # Installing plugins
    as_fish_user "fisher install IlanCosman/tide@v6"
    as_fish_user "fisher install jethrokuan/z"
    as_normal_user "cd $HOME/dotfiles/configs && stow --target="$HOME" fish starship"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_fish
fi
