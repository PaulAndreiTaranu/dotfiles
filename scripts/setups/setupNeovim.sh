#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

function setup_neovim() {
    print_green '### SETTING UP NEOVIM'

    # PNPM_HOME="$HOME/.local/share/pnpm"
    # if [[ ! -d "$PNPM_HOME" ]]; then
    #     print_red '### PNPM NOT INSTALLED'
    #     exit 1
    # fi

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
    as_normal_user "cd $HOME/dotfiles/configs && stow --target="$HOME" nvim"

    print_green '### HEADLESS LAZY INSTALL'
    as_normal_user 'nvim --headless "+Lazy! sync" +q'
    # as_normal_user 'nvim --headless "+TSInstallSync" +q'
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_neovim
fi
