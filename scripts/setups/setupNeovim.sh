#!/usr/bin/env bash
set -euo pipefail

# Source all required scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

function setup_neovim() {
	print_green '### SETTING UP NEOVIM'

	ensure_root
	require_commands snap

	# Install Neovim via snap if not installed
	if ! command -v nvim &>/dev/null; then
		print_green '### INSTALLING NEOVIM (SNAP)'
		snap install nvim --classic
		# Ensure 'vi' alias points to nvim
		snap alias nvim vi
	else
		print_yellow '!!! NEOVIM ALREADY INSTALLED, SKIPPING INSTALL'
	fi

	# Make nvim the default editor system-wide (for sudo, crontab, git, etc.)
	update-alternatives --install /usr/bin/editor editor "$(command -v nvim)" 100
	update-alternatives --set editor "$(command -v nvim)"
	# Create lightweight shims for vim and vi that point to nvim (no purging needed)
	for cmd in vim vi; do
		if [[ -e "/usr/local/bin/$cmd" || -L "/usr/local/bin/$cmd" ]]; then
			sudo rm -f "/usr/local/bin/$cmd"
		fi
		sudo ln -sf "$(command -v nvim)" "/usr/local/bin/$cmd"
	done

	# Clean any old config directories
	local nvim_config_array=(
		"$HOME/.config/nvim"
		"$HOME/.local/share/nvim"
		"$HOME/.local/state/nvim"
		"$HOME/.cache/nvim"
	)
	remove_with_array "${nvim_config_array[@]}"

	# Stow dotfiles
	run_as_user "mkdir -p $HOME/.config/nvim"
	run_as_user "cd $HOME/dotfiles/configs && stow --no-folding --target=$HOME nvim"

	# Run headless plugin install
	print_green "### INSTALLING NEOVIM PLUGINS (Lazy.nvim)"
	run_as_user "nvim --headless '+Lazy! sync' +q"

	print_green "### NEOVIM SETUP COMPLETE"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	setup_neovim
fi
