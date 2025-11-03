#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

function setup_code() {

	print_green '### SETTING UP VSCODE'
	if ! command -v code &>/dev/null; then
		ensure_root
		print_green "### INSTALLING VS CODE VIA SNAP..."
		if_snap "sudo snap install --classic code"
	else
		print_yellow "!!! VS CODE ALREADY INSTALLED, SKIPPING TO EXTENSIONS"
	fi

	### INSTALL EXTENSIONS
	local extensions=(
		"miguelsolorio.fluent-icons"
		"emmanuelbeziat.vscode-great-icons"
		"vscodevim.vim"
		"esbenp.prettier-vscode"
		"GitHub.github-vscode-theme"
		"mkhl.shfmt"
	)

	print_green "### Installing VS Code extensions..."
	local installed_extensions
	installed_extensions=$(run_as_user "code --list-extensions")

	for ext in "${extensions[@]}"; do
		if echo "$installed_extensions" | grep -q "^${ext}\$"; then
			print_yellow "EXTENSION '${ext}' ALREADY INSTALLED"
		else
			print_green "INSTALLING '${ext}'..."
			if ! run_as_user "code --install-extension ${ext} --force"; then
				print_red "XXX FAILED TO INSTALL '${ext}'"
			fi
		fi
	done

	### CONFIGURATION ---
	local CODE_CONFIG="$HOME/.config/Code/User"

	print_green "### Stowing VS Code config"
	run_as_user "rm -rf $CODE_CONFIG && mkdir -p $CODE_CONFIG"
	run_as_user "cd $HOME/dotfiles/configs && stow --no-folding --target=$HOME code"

}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
	setup_code
fi
