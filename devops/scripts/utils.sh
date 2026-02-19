#!/usr/bin/env bash
set -euo pipefail

# Colors — disabled when stderr is not a terminal (pipes, cron, non-interactive SSH)
if [[ -t 2 ]] && [[ -n "${TERM:-}" ]]; then
	_GREEN='\033[1;32m'
	_YELLOW='\033[1;33m'
	_RED='\033[1;31m'
	_RESET='\033[0m'
else
	_GREEN=''
	_YELLOW=''
	_RED=''
	_RESET=''
fi

# All status output goes to stderr so it never pollutes stdout/pipes
print_green() { printf "${_GREEN}%s${_RESET}\n" "$*" >&2; }
print_yellow() { printf "${_YELLOW}%s${_RESET}\n" "$*" >&2; }
print_red() { printf "${_RED}%s${_RESET}\n" "$*" >&2; }

# Re-exec with sudo if not root
ensure_root() {
	if [[ $EUID -ne 0 ]]; then
		exec sudo --preserve-env=USER,HOME,PATH "$0" "$@"
	fi
}

ensure_ubuntu() {
	if ! [[ -f /etc/os-release ]] || ! grep -qi 'ubuntu' /etc/os-release; then
		print_red "XXX This script only supports Ubuntu"
		exit 1
	fi
}

##########################################################
# Runs a command as the non-root user who invoked sudo.
# Use this in scripts that run as root but need to install
# or configure things in the user's home (e.g. flatpak,
# user-level pip packages, dotfile managers).
#
# Preserves desktop environment vars so GUI apps and
# user-scoped tools (XDG dirs, D-Bus) work correctly.
#
# Usage:
#   run_as_user flatpak install flathub com.example.App
#   run_as_user pip install --user some-package
##########################################################
run_as_user() {
	local user="${SUDO_USER:-$USER}"
	if [[ "$user" == "root" ]]; then
		print_red "XXX Cannot run as user — no non-root user found"
		return 1
	fi
	local env_vars="HOME,USER,DISPLAY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR,XDG_CONFIG_HOME"
	sudo -u "$user" -H --preserve-env="$env_vars" -- "$@"
}

require_commands() {
	local missing=()
	local cmd
	for cmd in "$@"; do
		if ! command -v "$cmd" &>/dev/null; then
			missing+=("$cmd")
		fi
	done
	if [[ ${#missing[@]} -gt 0 ]]; then
		print_red "XXX Missing required commands: ${missing[*]}"
		exit 1
	fi
}
