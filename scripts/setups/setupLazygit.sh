#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

function setup_lazygit() {
	ensure_root
	require_commands curl tar grep stow

	print_green '### SETTING UP LAZYGIT'

	# Check if lazygit is already installed
	if command -v lazygit &>/dev/null; then
		print_yellow '### LAZYGIT ALREADY INSTALLED'
	else
		print_green '### INSTALLING LAZYGIT'

		# Get latest version
		local lazygit_version
		lazygit_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

		if [ -z "$lazygit_version" ]; then
			print_red "XXX FAILED TO GET LAZYGIT VERSION"
			exit 1
		fi

		print_green "### DOWNLOADING LAZYGIT v${lazygit_version}"

		# Download and install
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${lazygit_version}_Linux_x86_64.tar.gz"
		tar xf lazygit.tar.gz lazygit
		install lazygit /usr/local/bin
		rm -rf lazygit.tar.gz lazygit

		print_green "### LAZYGIT v${lazygit_version} INSTALLED"
	fi

	# Stow configuration
	print_green '### STOWING LAZYGIT CONFIG'
	run_as_user "rm -rf $HOME/.config/lazygit"
	run_as_user "mkdir -p $HOME/.config/lazygit"
	run_as_user "cd $HOME/dotfiles/configs && stow --no-folding --target=$HOME lazygit"

	print_green '### LAZYGIT SETUP COMPLETE!'
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
	setup_lazygit
fi
