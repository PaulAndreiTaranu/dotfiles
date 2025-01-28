#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

function reset_neovim() {
    print_green '### RESETTING NEOVIM'

    if [ -e "/usr/bin/vim" ]; then
        print_green '### REMOVING VIM'
        if is_ubuntu; then
            sudo apt purge -y --auto-remove vim
            sudo rm -rf "/usr/bin/vim"
            sudo rm -rf "/usr/bin/vi"
        else
            print_red '### DISTRO NOT SUPPORTED'
            exit 1
        fi
    fi

    if [ ! -e "/snap/bin/nvim" ]; then
        print_green '### INSTALLING NEOVIM FROM SNAP'
        if_snap 'sudo snap install nvim --classic'
    else
        print_red '### NEOVIM ALREADY INSTALLED'
    fi

    sudo rm -rf "/usr/bin/vi"
    if_snap 'sudo snap alias nvim vi'

    nvim_config_array=(
        $HOME/.config/nvim
        $HOME/.local/share/nvim
        $HOME/.local/state/nvim
        $HOME/.cache/nvim
    )
    remove_with_array "${nvim_config_array[@]}"
    as_normal_user "mkdir -p $HOME/.config/nvim"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    reset_neovim
fi

