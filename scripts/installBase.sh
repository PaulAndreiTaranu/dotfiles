#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
. $SCRIPTS/setupNeovim.sh
. $SCRIPTS/setupZsh.sh
. $SCRIPTS/setupTmux.sh
check_sudo

print_green '### UPDATING SYSTEM'
sudo apt update && sudo apt upgrade -y

print_green '### INSTALLING SOFTWARE'
if is_ubuntu; then
    sudo apt -y install gcc curl wget git stow btop kitty
    sudo apt -y install gnome-tweaks gnome-shell-extension-manager
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
    $HOME/.config/git
    $HOME/.gitconfig
)
remove_with_array "${files_to_remove[@]}"
as_normal_user "mkdir $HOME/.config/kitty $HOME/.config/git"
as_normal_user "cd $HOME/dotfiles && stow git kitty"

print_green '### CLEANARDO BB'
as_normal_user "find $HOME/dotfiles/scripts -type f -exec chmod +x {} \;"

# Create links of scripts/bin to local bin
as_normal_user "mkdir $HOME/.local/bin"
for file in "$HOME/dotfiles/scripts/bin/*"; do
    as_normal_user "ln -s $file $HOME/.local/bin"
done

if is_ubuntu; then
    sudo apt autoremove -y && sudo apt clean -y
else
    print_red '### DISTRO NOT SUPPORTED'
    exit 1
fi
