#!/usr/bin/env bash

UTILS_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
.  $UTILS_DIR/utils.sh
.  $UTILS_DIR/setupNeovim.sh
.  $UTILS_DIR/setupZsh.sh
.  $UTILS_DIR/setupTmux.sh
check_sudo

print_green '### UPDATING SYSTEM'
sudo apt update && sudo apt upgrade -y

print_green '### INSTALLING SOFTWARE'
if is_ubuntu; then
    sudo apt -y install gcc curl wget git stow btop kitty
else
    print_red '### DISTRO NOT SUPPORTED'
    exit 1
fi

sudo wget https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
sudo dpkg -i lsd_0.23.1_amd64.deb
sudo rm lsd_0.23.1_amd64.deb

# Setting up imported configs
setup_neovim
setup_tmux
setup_zsh

print_green '### REMOVING USELESS DOTFILES && SETTING UP REMAINING DOTFILES'
files_to_remove=(
    $HOME/.config/kitty
    $HOME/.bashrc $HOME/.bash_history $HOME/.bash_logout $HOME/.bash_profile
    $HOME/.profile
    $HOME/.viminfo
    $HOME/.gitconfig
)
remove_with_array "${files_to_remove[@]}"
as_normal_user "mkdir $HOME/.config && cd $HOME/dotfiles && stow git kitty"

print_green '### CLEANARDO BB'
as_normal_user "find $HOME/dotfiles/scripts -type f -iname "*.sh" -exec chmod +x {} \;"
if is_ubuntu; then
    sudo apt autoremove -y && sudo apt clean -y
else
    print_red '### DISTRO NOT SUPPORTED'
    exit 1 
fi