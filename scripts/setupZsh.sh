#!/usr/bin/env bash

UTILS_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
.  $UTILS_DIR/utils.sh
check_sudo

OHMYZSH_LINK="curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

function setup_zsh(){
    print_green '### SETTING UP ZSH'

    # Check if zsh is installed
    if [ ! -e "/bin/zsh" ]; then
        if is_ubuntu; then
            print_green '### INSTALLING ZSH'
            sudo apt -y install zsh
        else
            print_red '### DISTRO NOT SUPPORTED'
            exit 1
        fi
    else
        print_red '### ZSH ALREADY INSTALLED'
    fi

    # Check if oh-my-zsh is installed
    if [[ ! -d "$HOME/.oh-my-zsh" && -e "/bin/zsh" ]]; then
        print_green '### INSTALLING OH-MY-ZSH'
        as_normal_user "$($OHMYZSH_LINK) '' --unattended"
    else
        print_red '### OH-MY-ZSH ALREADY INSTALLED'
    fi

    # Check if powerlevel10k theme is installed
    p10k_DIR="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    if [[ ! -d "$p10k_DIR" && -d "$HOME/.oh-my-zsh" ]]; then
        print_green '### INSTALLING POWERLEVEL10K THEME'
        as_normal_user  "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${p10k_DIR}"
    else
        print_red '### POWERLEVEL10K ALREADY INSTALLED'
    fi

    # Change default shell to zsh
    sudo usermod --shell $(which zsh) $USER
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_zsh
fi
