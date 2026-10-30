#!/usr/bin/env bash
set -euo pipefail

# Source all required scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

function setup_neovim() {
	print_green "$HOME"
	print_green '### SETTING UP NEOVIM'
	ensure_root
	require_commands snap stow getent

	# Resolve the target user's real home.
	# If ensure_root preserved HOME (script self-elevated), $HOME is already
	# the user's. If the script was started as root directly, $HOME is /root,
	# so fall back to SUDO_USER/USER via getent.
	local target_user user_home
	if [[ "$HOME" != "/root" ]]; then
		user_home="$HOME"
		target_user="${USER:-${SUDO_USER}}"
	else
		target_user="${SUDO_USER:-$USER}"
		user_home="$(getent passwd "$target_user" | cut -d: -f6)"
	fi
	if [[ -z "$user_home" || ! -d "$user_home" ]]; then
		print_red "!!! Could not resolve home for user '$target_user'"
		return 1
	fi

	# Install Neovim via snap if not installed
	if ! command -v nvim &>/dev/null; then
		print_green '### INSTALLING NEOVIM (SNAP)'
		snap install nvim --classic
	else
		print_yellow '!!! NEOVIM ALREADY INSTALLED, SKIPPING INSTALL'
	fi

	local nvim_bin
	nvim_bin="$(command -v nvim)"
	if [[ -z "$nvim_bin" ]]; then
		# PATH may not include /snap/bin under sudo; check explicitly
		[[ -x /snap/bin/nvim ]] && nvim_bin=/snap/bin/nvim
	fi
	if [[ -z "$nvim_bin" ]]; then
		print_red "!!! nvim not found on PATH after install"
		return 1
	fi

	# Make nvim the default editor system-wide (sudo, crontab, git, etc.)
	update-alternatives --install /usr/bin/editor editor "$nvim_bin" 100
	update-alternatives --set editor "$nvim_bin"

	# Lightweight shims for vim and vi -> nvim.
	# /usr/local/bin sits ahead of /snap/bin on PATH, so this wins without
	# 'snap alias' (which would compete with these shims).
	for cmd in vim vi; do
		if [[ -e "/usr/local/bin/$cmd" || -L "/usr/local/bin/$cmd" ]]; then
			rm -f "/usr/local/bin/$cmd"
		fi
		ln -sf "$nvim_bin" "/usr/local/bin/$cmd"
	done

	# Clean any old config directories (target user's home, not /root)
	local nvim_config_array=(
		"$user_home/.config/nvim"
		"$user_home/.local/share/nvim"
		"$user_home/.local/state/nvim"
		"$user_home/.cache/nvim"
	)
	remove_with_array "${nvim_config_array[@]}"

	# Stow dotfiles
	run_as_user 'mkdir -p "$HOME/.config/nvim"'
	run_as_user "cd '$DOTFILES_DIR/configs' && stow --no-folding --target='$HOME' nvim"

	# Headless plugin install
	print_green "### INSTALLING NEOVIM PLUGINS (Lazy.nvim)"
	run_as_user "nvim --headless '+Lazy! sync' +q"

	print_green "### NEOVIM SETUP COMPLETE"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	setup_neovim
fi
