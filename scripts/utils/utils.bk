# Reset
NOCOLOR='\033[0m' # Text Reset
# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BBLUE='\033[1;34m'
BMAGENTA='\033[1;35m'
BCYAN='\033[1;36m'
BWHITE='\033[1;37m'

release_file=$(cat /etc/os-release | grep 'Ubuntu')
snap=$(snap version | grep 'snap')

function ensure_root() {
	if [[ "$EUID" -ne 0 ]]; then
		exec sudo --preserve-env=USER,HOME,PATH "$0" "$@"
	fi
}

function run_as_user() {
	local user="${SUDO_USER:-$USER}"
	if [[ "$user" == "root" ]]; then
		print_red "XXX I'M ROOT. CANNOT RUN SCRIPT AS USER"
		return 1
	fi

	# Extra environment for desktop apps (VSCode, Flatpak, Snap, etc.)
	local env_vars="HOME,USER,DISPLAY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR,XDG_CONFIG_HOME"
	sudo -u "$user" -H --preserve-env=$env_vars bash -c "$*"
}

function run_as_fish() {
	local user="${SUDO_USER:-$USER}"
	if [[ "$user" == "root" ]]; then
		print_red "XXX CANNOT RUN AS_NORMAL_USER AS ROOT"
		return 1
	fi
	# Extra environment for desktop apps (VSCode, Flatpak, Snap, etc.)
	local env_vars="HOME,USER,DISPLAY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR,XDG_CONFIG_HOME"
	sudo -u "$user" -H --preserve-env=$env_vars fish -c "$*"
}

#############################################
# Deletes every element of the provided array
#
# Example:
#   remove_with_array "${array[@]}"
#############################################
function remove_with_array() {
	arr=("$@")
	for i in "${arr[@]}"; do
		print_red "️XXX REMOVING $i"
		run_as_user "rm -rf $i"
	done
}

function as_pnpm_loaded() {
	sudo -H -u $USER zsh -c "source $HOME/.zshrc && $1"
}

function print_green() {
	echo -e "${BGREEN}$1${NOCOLOR}" >&2
}

function print_yellow() {
	echo -e "${BYELLOW}$1${NOCOLOR}" >&2
}

function print_red() {
	echo -e "${BRED}$1${NOCOLOR}" >&2
}

function is_ubuntu() {
	[[ ! -z $release_file ]] && return 0 || return 1
}

# Check if snap is installed
function if_snap() {
	if [[ ! -z $snap ]]; then
		$1
	else
		print_red '### SNAP NOT FOUND'
	fi
}

##########################################################
# Checks if required commands are installed on the system.
# Exits with code 1 if any command is missing.
#
# Arguments:
#   $@ - List of command names to check
#
# Example:
#   require_commands curl stow git
#
# Output (if missing):
#   XXX MISSING REQUIRED COMMANDS: curl git
##########################################################
function require_commands() {
	local missing=()
	local cmd

	for cmd in "$@"; do
		if ! command -v "$cmd" &>/dev/null; then
			missing+=("$cmd")
		fi
	done

	if [ ${#missing[@]} -gt 0 ]; then
		print_red "XXX MISSING REQUIRED COMMANDS: ${missing[*]}"
		exit 1
	fi
}
