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

print_green() { printf "${_GREEN}%s${_RESET}\n" "$*" >&2; }
print_yellow() { printf "${_YELLOW}%s${_RESET}\n" "$*" >&2; }
print_red() { printf "${_RED}%s${_RESET}\n" "$*" >&2; }

# Root of the dotfiles repo, wherever it was cloned
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Under sudo, HOME points to /root. Point it back to the invoking user's home
# so every $HOME path in the scripts targets the real user.
if [[ $EUID -eq 0 && -n "${SUDO_USER:-}" && "$SUDO_USER" != "root" ]]; then
	HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
	export HOME
fi

# Re-exec the running script as root if it wasn't started with sudo
# Usage: ensure_root "$@"
ensure_root() {
	if [[ $EUID -ne 0 ]]; then
		print_yellow "### ROOT REQUIRED, RE-RUNNING WITH SUDO"
		exec sudo bash "$0" "$@"
	fi
}

ensure_ubuntu() {
	if ! [[ -f /etc/os-release ]] || ! grep -qi 'ubuntu' /etc/os-release; then
		print_red "XXX This script only supports Ubuntu"
		exit 1
	fi
}

is_ubuntu() {
	[[ -f /etc/os-release ]] && grep -qi 'ubuntu' /etc/os-release
}

# Run a command as the non-root user under a given shell
# Usage: _run_as "bash" "cd /tmp && ls"
#        _run_as "fish" "fisher install jethrokuan/z"
_run_as() {
	local shell="$1"
	shift
	local user="${SUDO_USER:-$USER}"
	if [[ "$user" == "root" ]]; then
		print_red "XXX Cannot run as user — no non-root user found"
		return 1
	fi
	local env_vars="HOME,USER,DISPLAY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR,XDG_CONFIG_HOME"
	sudo -u "$user" -H --preserve-env="$env_vars" "$shell" -c "$*"
}

run_as_user() { _run_as bash "$@"; }
run_as_fish() { _run_as fish "$@"; }

# True if the non-root user is running a GNOME session.
# Checks the process list because sudo strips XDG_CURRENT_DESKTOP.
is_gnome() {
	[[ "${XDG_CURRENT_DESKTOP:-}" == *"GNOME"* ]] ||
		pgrep -u "${SUDO_USER:-$USER}" -x gnome-shell &>/dev/null
}

# Run gsettings as the non-root user against their desktop session bus,
# so settings land in their dconf database instead of root's
# Usage: run_gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Super>1']"
run_gsettings() {
	local user="${SUDO_USER:-$USER}"
	local bus="/run/user/$(id -u "$user")/bus"
	if [[ ! -S "$bus" ]]; then
		print_red "XXX No session bus for $user, log in to the desktop first"
		return 1
	fi
	sudo -u "$user" env DBUS_SESSION_BUS_ADDRESS="unix:path=$bus" gsettings "$@"
}

# Deletes every path in the provided array
# Usage: remove_with_array "${array[@]}"
remove_with_array() {
	local item
	for item in "$@"; do
		print_red "XXX REMOVING $item"
		run_as_user "rm -rf '$item'"
	done
}

# Run a command only if snap is available
if_snap() {
	if command -v snap &>/dev/null; then
		"$@"
	else
		print_red "### SNAP NOT FOUND"
	fi
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
