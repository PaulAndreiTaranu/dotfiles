#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

function setup_neovim() {
    print_green '### SETTING UP NEOVIM'

    PNPM_HOME="$HOME/.local/share/pnpm"
    if [[ ! -d "$HOME/.nvm" ]]; then
        print_red '### NODE NOT INSTALLED'
        exit 1
    elif [[ ! -d "$HOME/.local/share/pnpm" ]]; then
        print_red '### PNPM NOT INSTALLED'
        exit 1
    fi

    if [ -e "/usr/bin/vim" ]; then
        print_green '### REMOVING VIM'
        if is_ubuntu; then
            sudo apt purge -y --auto-remove vim
            sudo rm -rf "/usr/bin/vim"
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

    sudo rm -rf "/usr/bin/vi"
    if_snap 'sudo snap alias nvim vi'

    nvim_config_array=(
        $HOME/.config/nvim
        $HOME/.local/share/nvim
        $HOME/.local/state/nvim
        $HOME/.cache/nvim
    )
    remove_with_array "${nvim_config_array[@]}"
    as_normal_user "mkdir $HOME/.config/nvim && cd $HOME/dotfiles && stow nvim"

    print_green '### HEADLESS LAZY INSTALL'
    # as_normal_user 'nvim --headless "+Lazy! sync" +q'
    as_normal_user 'nvim --headless "+TSInstallSync" +q'
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_neovim
fi
