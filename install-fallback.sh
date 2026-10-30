#!/usr/bin/env bash
set -euo pipefail

# Color output functions
function print_green() { echo -e "\033[0;32m$*\033[0m"; }
function print_yellow() { echo -e "\033[0;33m$*\033[0m"; }
function print_red() { echo -e "\033[0;31m$*\033[0m"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Under sudo, HOME points to /root. Point it back to the invoking user's home
if [[ $EUID -eq 0 && -n "${SUDO_USER:-}" && "$SUDO_USER" != "root" ]]; then
	HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
	export HOME
fi

function ensure_root() {
	if [[ "$EUID" -ne 0 ]]; then
		exec sudo bash "$0" "$@"
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

# sudo strips XDG_CURRENT_DESKTOP, so also check the user's processes
function is_gnome() {
	[[ "${XDG_CURRENT_DESKTOP:-}" == *"GNOME"* ]] ||
		pgrep -u "${SUDO_USER:-$USER}" -x gnome-shell &>/dev/null
}

# Run gsettings as the user against their session bus, not root's
function run_gsettings() {
	local user="${SUDO_USER:-$USER}"
	local bus="/run/user/$(id -u "$user")/bus"
	if [[ ! -S "$bus" ]]; then
		print_red "XXX No session bus for $user, log in to the desktop first"
		return 1
	fi
	sudo -u "$user" env DBUS_SESSION_BUS_ADDRESS="unix:path=$bus" gsettings "$@"
}

print_green "### EMERGENCY INSTALL - INSTALLING BASICS"
ensure_root "$@"
apt update && apt upgrade -y

print_green "### INSTALLING ESSENTIAL TOOLS"
apt install -y build-essential curl wget git stow

print_green "### INSTALLING CLI TOOLS"
apt install -y ripgrep fd-find btop shfmt

print_green "### INSTALLING TERMINAL & SHELL"
apt install -y kitty fish

# GNOME tools (if running GNOME)
if is_gnome; then
	print_green "### INSTALLING GNOME TOOLS"
	apt install -y \
		gnome-tweaks \
		gnome-shell-extension-manager \
		wl-clipboard \
		ubuntu-wallpapers-lunar

	run_gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Super>1', '<Super>h']"
	run_gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Super>2', '<Super>j']"
	run_gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Super>3', '<Super>k']"
	run_gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Super>4', '<Super>l']"
else
	print_yellow "### SKIPPING GNOME TOOLS (NOT RUNNING GNOME)"
fi

# Snap packages
if command -v snap &>/dev/null; then
	print_green "### INSTALLING SNAP PACKAGES"
	snap install brave || print_yellow "### FAILED TO INSTALL BRAVE"
	snap install --classic zellij || print_yellow "### FAILED TO INSTALL ZELLIJ"
	snap install --classic nvim || print_yellow "### FAILED TO INSTALL NVIM"
	snap install --classic code || print_yellow "### FAILED TO INSTALL CODE"
else
	print_red "### SNAP NOT FOUND - SKIPPING SNAP PACKAGES"
fi

print_green "### REMOVING USELESS FILES"
run_as_user "rm -rf $HOME/.config/kitty $HOME/.config/git $HOME/.local/bin $HOME/.config/zellij"
run_as_user "mkdir -p $HOME/.config/kitty $HOME/.config/git $HOME/.local/bin $HOME/.config/zellij"
run_as_user "cd $DOTFILES_DIR/configs && stow --no-folding --target=$HOME git kitty zellij code"

print_green "### EMERGENCY INSTALL COMPLETE!"
print_yellow "### RECOMMENDED: Restart your shell or log out/in"
