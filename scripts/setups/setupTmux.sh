#!/usr/bin/env bash
set -euo pipefail

# Source all required scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

function setup_tmux() {
	print_green '### SETTING UP TMUX'

	ensure_root

	if [ ! -e "/usr/bin/tmux" ]; then
		print_green '### INSTALLING TMUX'
		if is_ubuntu; then
			sudo apt -y install tmux
		else
			print_red '### DISTRO NOT SUPPORTED'
			exit 1
		fi
	else
		print_red '### TMUX ALREADY INSTALLED'
	fi

	# Deleting present config and adding new config
	nvim_config_array=(
		$HOME/.config/tmux
		$HOME/.tmux/plugins
	)
	remove_with_array "${nvim_config_array[@]}"
	run_as_user "mkdir $HOME/.config/tmux && cd $DOTFILES_DIR/configs && stow --no-folding --target=$HOME tmux"

	print_green '### INSTALLING TMUX PLUGIN MANGER AND PLUGINS'
	run_as_user "git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm"
	run_as_user "bash $HOME/.tmux/plugins/tpm/bin/install_plugins"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
	setup_tmux
fi
