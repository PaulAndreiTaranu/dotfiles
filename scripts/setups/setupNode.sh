#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

function setup_node() {
	require_commands curl bash

	print_green '### SETTING UP NODE'

	# Install n (Node version manager)
	local n_prefix="$HOME/.local/bin/n"
	if [[ -d "$n_prefix" ]]; then
		print_yellow "### N ALREADY INSTALLED"
	else
		print_green "### INSTALLING N"
		run_as_user "curl -L https://bit.ly/n-install | N_PREFIX=$n_prefix bash -s -- -y -n"
	fi

	# Install pnpm
	local pnpm_home="$HOME/.local/share/pnpm"
	if command -v pnpm &>/dev/null; then
		print_yellow "### PNPM ALREADY INSTALLED"
	else
		print_green "### INSTALLING PNPM"
		run_as_user "curl -fsSL https://get.pnpm.io/install.sh | sh"
	fi

	print_green '### NODE SETUP COMPLETE!'
	print_yellow '### RESTART YOUR SHELL OR SOURCE YOUR CONFIG TO USE NODE/PNPM'
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
	setup_node
fi
