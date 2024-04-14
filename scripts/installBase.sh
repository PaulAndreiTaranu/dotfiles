#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
. $SCRIPTS/setups/setupZsh.sh
. $SCRIPTS/setups/setupFont.sh
. $SCRIPTS/setups/setupCode.sh
check_sudo

print_green '### UPDATING SYSTEM'
sudo apt update && sudo apt upgrade -y

print_green '### INSTALLING SOFTWARE'
if is_ubuntu; then
    sudo apt -y install build-essential curl wget ripgrep fd-find git stow btop kitty
    sudo apt -y install gnome-tweaks gnome-shell-extension-manager wl-clipboard
    sudo apt -y install ubuntu-wallpapers-lunar
else
    print_red '### DISTRO NOT SUPPORTED'
    exit 1
fi

if [ ! -e "/snap/bin/brave" ]; then
    print_green '### INSTALLING BRAVE BROWSER FROM SNAP'
    if_snap 'sudo snap install --classic brave'
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

if [ ! -e "/usr/bin/lazygit" ]; then
    print_green '### INSTALLING LAZYGIT'
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/bin
    sudo rm -rf lazygit.tar.gz lazygit
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
as_normal_user "mkdir -p $HOME/.config/kitty $HOME/.config/git $HOME/.local/bin $HOME/.config/zellij"
as_normal_user "cd $HOME/dotfiles/configs && stow --target="$HOME" git kitty zellij"

# Setting up imported configs
setup_fish
setup_font
setup_code

print_green '### CLEANARDO BB'
as_normal_user "find $HOME/dotfiles/scripts -type f -exec chmod +x {} \;"

# Create link of fdfind to fd
if [ -e "/usr/bin/fdfind" ]; then
    as_normal_user "ln -s $(which fdfind) $HOME/.local/bin/fd"
fi

sudo apt autoremove -y && sudo apt clean -y
print_green '# Reminder: Change to Wayland'
print_green '# Reminder: Install password manager'
print_green '# Reminder: SETUP ubuntu keybindings'
