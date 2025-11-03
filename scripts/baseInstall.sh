#!/usr/bin/env bash
set -euo pipefail

# Source all required scripts
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASE_DIR/utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}
print_green "#### UBUNTU BASE INSTALL ####"

for script in setupFish setupFont setupCode setupLazygit; do
	source "$BASE_DIR/setups/$script.sh" || {
		print_red "XXX FAILED TO LOAD $script.sh"
		exit 1
	}
done
print_green "### ALL SCRIPTS SOURCED SUCCESSFULLY"

ensure_root

print_green "### UPDATING SYSTEM"
sudo apt update && sudo apt upgrade -y

print_green "### INSTALLING SOFTWARE"
if is_ubuntu; then
	apt -y install build-essential curl wget ripgrep fd-find git stow shfmt kitty fish
	apt -y install gnome-tweaks gnome-shell-extension-manager wl-clipboard
	apt -y install ubuntu-wallpapers-lunar btop
else
	print_red "### DISTRO NOT SUPPORTED"
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
	LSD_VERSION="lsd-musl_1.2.0_amd64.deb"
	wget https://github.com/lsd-rs/lsd/releases/download/v1.2.0/$LSD_VERSION
	dpkg -i $LSD_VERSION && rm -rf $LSD_VERSION
fi

print_green "### REMOVING USELESS FILES"
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
run_as_user "mkdir -p $HOME/.config/kitty $HOME/.config/git $HOME/.local/bin $HOME/.config/zellij"
run_as_user "cd $HOME/dotfiles/configs && stow --target=$HOME git kitty zellij"

# Setting up imported configs
setup_font
setup_code
setup_lazygit

print_green "### CLEANARDO BB"
run_as_user "find $HOME/dotfiles/scripts -type f -exec chmod +x {} \;"

# Create link of fdfind to fd
if [ -e "/usr/bin/fdfind" ]; then
	run_as_user "ln -fs $(which fdfind) $HOME/.local/bin/fd"
fi

sudo apt autoremove -y && sudo apt clean -y

print_green "# Reminder: Install password manager"
print_green "# Reminder: SETUP ubuntu keybindings"
