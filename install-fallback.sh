#!/usr/bin/env bash
set -euo pipefail

# Color output functions
function print_green() { echo -e "\033[0;32m$*\033[0m"; }
function print_yellow() { echo -e "\033[0;33m$*\033[0m"; }
function print_red() { echo -e "\033[0;31m$*\033[0m"; }

function ensure_root() {
	if [[ "$EUID" -ne 0 ]]; then
		exec sudo --preserve-env=USER,HOME,PATH "$0" "$@"
	fi
}

function run_as_user() {
	local user="${SUDO_USER:-$USER}"
	if [[ "$user" == "root" ]]; then
		print_red "XXX I'M ROOT. CANNOT RUN SCRIPT AS USER"
		return 1
	fi

	# Extra environment for desktop apps (VSCode, Flatpak, Snap, etc.)
	local env_vars="HOME,USER,DISPLAY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR,XDG_CONFIG_HOME"
	sudo -u "$user" -H --preserve-env=$env_vars bash -c "$*"
}

print_green "### EMERGENCY INSTALL - INSTALLING BASICS"
ensure_root
apt update && apt upgrade -y

print_green "### INSTALLING ESSENTIAL TOOLS"
apt install -y build-essential curl wget git stow

print_green "### INSTALLING CLI TOOLS"
apt install -y ripgrep fd-find btop shfmt

print_green "### INSTALLING TERMINAL & SHELL"
apt install -y kitty fish

# GNOME tools (if running GNOME)
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] || [[ -n "${GNOME_DESKTOP_SESSION_ID:-}" ]]; then
	print_green "### INSTALLING GNOME TOOLS"
	apt install -y \
		gnome-tweaks \
		gnome-shell-extension-manager \
		wl-clipboard \
		ubuntu-wallpapers-lunar
else
	print_yellow "### SKIPPING GNOME TOOLS (NOT RUNNING GNOME)"
fi

# Snap packages
if command -v snap &>/dev/null; then
	print_green "### INSTALLING SNAP PACKAGES"
	snap install --classic brave || print_yellow "### FAILED TO INSTALL BRAVE"
	snap install --classic zellij || print_yellow "### FAILED TO INSTALL ZELLIJ"
	snap install --classic nvim || print_yellow "### FAILED TO INSTALL NVIM"
	snap install --classic code || print_yellow "### FAILED TO INSTALL CODE"
else
	print_red "### SNAP NOT FOUND - SKIPPING SNAP PACKAGES"
fi

print_green "### REMOVING USELESS FILES"
run_as_user "rm -rf $HOME/.config/kitty $HOME/.config/git $HOME/.local/bin $HOME/.config/zellij"
run_as_user "mkdir -p $HOME/.config/kitty $HOME/.config/git $HOME/.local/bin $HOME/.config/zellij"
run_as_user "cd $HOME/dotfiles/configs && stow --no-folding --target=$HOME git kitty zellij code"

print_green "### EMERGENCY INSTALL COMPLETE!"
print_yellow "### RECOMMENDED: Restart your shell or log out/in"
