#!/usr/bin/env bash
set -euo pipefail

# Source all required scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

function setup_ubuntu_keybindings() {
	print_green '### SETTING UP GNOME KEYBINDINGS'

	if ! is_gnome; then
		print_yellow '### SKIPPING KEYBINDINGS (NOT RUNNING GNOME)'
		return 0
	fi

	run_gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Super>1', '<Super>h']"
	run_gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Super>2', '<Super>j']"
	run_gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Super>3', '<Super>k']"
	run_gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Super>4', '<Super>l']"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
	setup_ubuntu_keybindings
fi
