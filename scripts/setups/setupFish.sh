#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

function setup_fish() {
	ensure_root
	print_green '### SETTING UP FISH'

	require_commands curl stow fish

	# Removing old config
	run_as_user "rm -rf $HOME/.config/fish $HOME/.config/starship.toml"
	run_as_user "mkdir -p $HOME/.config/fish"

	print_green '### INSTALLING STARSHIP PROMPT'
	if ! command -v starship &>/dev/null; then
		curl -sS https://starship.rs/install.sh | sh -s -- --yes
	else
		print_yellow '### STARSHIP ALREADY INSTALLED'
	fi

	print_green '### CHANGE DEFAULT SHELL TO FISH'
	local fish_path=$(which fish)

	# Ensure fish is in /etc/shells
	if ! grep -q "^$fish_path$" /etc/shells; then
		print_yellow "### ADDING FISH TO /etc/shells"
		echo "$fish_path" >>/etc/shells
	fi
	# Change shell (using preserved $USER)
	usermod --shell "$fish_path" "$USER"

	print_green "### INSTALLING FISHER PLUGIN MANAGER"
	FISHER_LINK="https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish"
	run_as_fish "curl -sL $FISHER_LINK | source && fisher install jorgebucaran/fisher"

	print_green "### INSTALLING FISHER PLUGINS"
	# run_as_fish "fisher install IlanCosman/tide@v6"
	run_as_fish "fisher install jethrokuan/z"
	run_as_user "cd $HOME/dotfiles/configs && stow --target=$HOME fish starship"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
	setup_fish
fi
