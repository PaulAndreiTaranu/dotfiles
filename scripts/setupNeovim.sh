#!/usr/bin/env bash

UTILS_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
.  $UTILS_DIR/utils.sh
check_sudo

function setup_neovim() {
    print_green '### SETTING UP NEOVIM'

    if [ -e "/usr/bin/vim" ]; then
        print_green '### REMOVING VIM'
        if is_ubuntu; then
            sudo apt purge -y --auto-remove vim
        else
            print_red '### DISTRO NOT SUPPORTED'
            exit 1
        fi
    fi

    if [ ! -e "/snap/bin/nvim" ]; then
        print_green '### INSTALLING NEOVIM FROM SNAP'
        if_snap 'sudo snap install --edge nvim --classic'
    else 
        print_red '### NEOVIM ALREADY INSTALLED'
    fi

    # sudo rm -rf "/bin/vi" && sudo ln "/snap/bin/nvim" "/snap/bin/vi"

    if_snap 'sudo snap alias nvim vi'

    nvim_config_array=(
        $HOME/.config/nvim 
        $HOME/.local/share/nvim
        $HOME/.local/state/nvim
        $HOME/.cache/nvim
    )
    remove_with_array "${nvim_config_array[@]}"
    as_normal_user "mkdir $HOME/.config/nvim && cd $HOME/dotfiles && stow nvim"

    # Headless lazy.nvim install
    as_normal_user 'nvim --headless "+Lazy! sync" +qa'
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_neovim
fi