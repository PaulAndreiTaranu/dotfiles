#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || { echo "XXX FAILED TO LOAD UTILS.SH"; exit 1; }

OHMYZSH_LINK="curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

function setup_zsh() {
    ensure_root
    print_green '### SETTING UP ZSH'

    # Check if zsh is installed
    if [ ! -e "/usr/bin/zsh" ]; then
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
        run_as_user "$($OHMYZSH_LINK) '' --unattended"
    else
        print_red '### OH-MY-ZSH ALREADY INSTALLED'
    fi

    # Check if powerlevel10k theme is installed
    # Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc.
    # `p10k configure` if config wizard doesn't start
    p10k_DIR="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    if [[ ! -d "$p10k_DIR" && -d "$HOME/.oh-my-zsh" ]]; then
        print_green '### INSTALLING POWERLEVEL10K THEME'
        run_as_user "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${p10k_DIR}"
    else
        print_red '### POWERLEVEL10K ALREADY INSTALLED'
    fi

    # Install zsh-vi-mode
    ZSH_VI_MODE_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode"
    if [[ ! -d "$ZSH_VI_MODE_DIR" ]]; then
        print_green '### INSTALLING ZSH-VI-MODE PLUGIN'
        run_as_user "git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_VI_MODE_DIR"
    else
        print_red '### ZSH-VI-MODE ALREADY INSTALLED'
    fi

    # Change default shell to zsh
    print_red '### CHANGE DEFAULT SHELL TO ZSH AND STOW CONFIG'
    sudo usermod --shell $(which zsh) $USER

	files_to_remove=($HOME/.zshrc $HOME/.zshrc.backup)
	remove_with_array "${files_to_remove[@]}"
	run_as_user "cd $HOME/dotfiles/configs && stow --target="$HOME" zsh"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_zsh
fi

