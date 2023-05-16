#!/usr/bin/env bash

UTILS_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
.  $UTILS_DIR/utils.sh
.  $UTILS_DIR/setupNeovim.sh
check_sudo

print_green '### UPDATING SYSTEM'
sudo apt update && sudo apt upgrade -y

print_green '### INSTALLING SOFTWARE'
if is_ubuntu; then
    sudo apt -y install curl wget git zsh stow btop kitty
else
    print_red '### DISTRO NOT SUPPORTED'
    exit 1
fi
sudo wget https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
sudo dpkg -i lsd_0.23.1_amd64.deb
sudo rm lsd_0.23.1_amd64.deb

print_green '### REMOVING USELESS DONTFILES && SETTING UP DOTFILES'
files_to_remove=(
    $HOME/.config/kitty
    $HOME/.zshrc $HOME/.zshrc.backup
    $HOME/.bashrc $HOME/.bash_history $HOME/.bash_logout $HOME/.bash_profile
    $HOME/.profile
    $HOME/.viminfo
    $HOME/.gitconfig
)
remove_with_array "${files_to_remove[@]}"
as_normal_user "mkdir $HOME/.config && cd $HOME/dotfiles && stow git zsh kitty"

print_green '### CLEANARDO BB'
as_normal_user "find $HOME/dotfiles/scripts -type f -iname "*.sh" -exec chmod +x {} \;"
if is_ubuntu; then
    sudo apt autoremove -y
else
    print_red '### DISTRO NOT SUPPORTED'
    exit 1 
fi