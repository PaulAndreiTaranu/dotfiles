#!/usr/bin/env bash
set -euo pipefail

# Source all required scripts
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASE_DIR/scripts/utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}
print_green "#### UBUNTU BASE INSTALL ####"

for script in setupFish setupFont setupCode setupLazygit setupUbuntuKeybindings; do
	print_green "$BASE_DIR"
	source "$BASE_DIR/scripts/setups/$script.sh" || {
		print_red "XXX FAILED TO LOAD $script.sh"
		exit 1
	}
done
print_green "### ALL SCRIPTS SOURCED SUCCESSFULLY"

ensure_root "$@"

print_green "### UPDATING SYSTEM"
sudo apt update && sudo apt upgrade -y

print_green "### INSTALLING ESSENTIAL TOOLS"
apt install -y build-essential curl wget git stow

print_green "### INSTALLING CLI TOOLS"
apt install -y ripgrep fd-find btop shfmt

print_green "### INSTALLING TERMINAL & SHELL"
apt install -y kitty fish

if ! command -v brave &>/dev/null; then
	print_green '### INSTALLING BRAVE BROWSER FROM SNAP'
	if_snap snap install brave
fi

if ! command -v zellij &>/dev/null; then
	print_green '### INSTALLING ZELLIJ FROM SNAP'
	if_snap snap install --classic zellij
fi

if ! command -v lsd &>/dev/null; then
	print_green '### INSTALLING LSD'
	LSD_VERSION="lsd-musl_1.2.0_amd64.deb"
	wget https://github.com/lsd-rs/lsd/releases/download/v1.2.0/$LSD_VERSION
	sudo dpkg -i $LSD_VERSION && rm -rf $LSD_VERSION
fi

if is_gnome; then
	print_green "### INSTALLING GNOME TOOLS"
	apt install -y \
		gnome-tweaks \
		gnome-shell-extension-manager \
		wl-clipboard \
		ubuntu-wallpapers-lunar

	setup_ubuntu_keybindings
else
	print_yellow "### SKIPPING GNOME TOOLS (NOT RUNNING GNOME)"
fi

print_green "### REMOVING USELESS FILES"
files_to_remove=(
	# Config dirs we re-create and stow further down
	"$HOME/.config/kitty"
	"$HOME/.config/zellij"
	"$HOME/.config/git"
	"$HOME/.local/bin"

	# Default shell/editor dotfiles
	"$HOME/.gitconfig"
	"$HOME/.bashrc" "$HOME/.bash_history" "$HOME/.bash_logout" "$HOME/.bash_profile"
	"$HOME/.profile"
	"$HOME/.viminfo"
	"$HOME/.sudo_as_admin_successful"

	# Unused XDG user dirs
	"$HOME/Pictures"
	"$HOME/Music"
	"$HOME/Videos"
	"$HOME/Desktop"
	"$HOME/Templates"
)
remove_with_array "${files_to_remove[@]}"
run_as_user "mkdir -p $HOME/.config/kitty $HOME/.config/git $HOME/.local/bin $HOME/.config/zellij"
run_as_user "cd $DOTFILES_DIR/configs && stow --no-folding --target=$HOME git kitty zellij"

# Setting up imported configs
setup_font
setup_code
setup_lazygit

print_green "### CLEANARDO BB"
run_as_user "find $DOTFILES_DIR/scripts -type f -exec chmod +x {} \;"

# Create link of fdfind to fd
if command -v fdfind &>/dev/null; then
	run_as_user "ln -fs $(command -v fdfind) $HOME/.local/bin/fd"
fi

sudo apt autoremove -y && sudo apt clean -y

print_green "# Reminder: Setup Fish: sudo bash scripts/setups/setupFish.sh"
print_green "# Reminder: Setup Neovim: sudo bash scripts/setups/setupNeovim.sh"
print_green "# Reminder: Install Just Perfection gnome extension"
print_green "# Reminder: Install password manager"
