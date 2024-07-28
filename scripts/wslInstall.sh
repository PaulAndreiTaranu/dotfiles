#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
. $SCRIPTS/setups/setupZsh.sh
check_sudo

print_green '### UPDATING SYSTEM'
sudo apt update && sudo apt upgrade -y

print_green '### INSTALLING SOFTWARE'
if is_ubuntu; then
    sudo apt -y install build-essential curl wget ripgrep fd-find git stow btop
else
    print_red '### DISTRO NOT SUPPORTED'
    exit 1
fi

if [ ! -e "/snap/bin/zellij" ]; then
    print_green '### INSTALLING ZELLIJ FROM SNAP'
    if_snap 'sudo snap install --classic zellij'
fi

if [ ! -e "/usr/bin/lsd" ]; then
    print_green '### INSTALLING LSD'
    sudo wget https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
    sudo dpkg -i lsd_0.23.1_amd64.deb
    sudo rm lsd_0.23.1_amd64.deb
fi

print_green '### REMOVING USELESS FILES'
files_to_remove=(
    $HOME/.config/kitty
    $HOME/.config/zellij
    $HOME/.config/git
    $HOME/.local/bin
    $HOME/.gitconfig
    $HOME/.bashrc $HOME/.bash_history $HOME/.bash_logout $HOME/.bash_profile
    $HOME/.profile
    $HOME/.viminfo
    $HOME/.sudo_as_admin_successful
    $HOME/Pictures
    $HOME/Music
    $HOME/Videos
    $HOME/Desktop
    $HOME/Templates
)
remove_with_array "${files_to_remove[@]}"
as_normal_user "mkdir -p $HOME/.config/git $HOME/.local/bin $HOME/.config/zellij"
as_normal_user "cd $HOME/dotfiles/configs && stow --target="$HOME" git zellij"

# Setting up imported configs
setup_fish

print_green '### CLEANARDO BB'
as_normal_user "find $HOME/dotfiles/scripts -type f -exec chmod +x {} \;"

# Create link of fdfind to fd
if [ -e "/usr/bin/fdfind" ]; then
    as_normal_user "ln -s $(which fdfind) $HOME/.local/bin/fd"
fi

sudo apt autoremove -y && sudo apt clean -y
