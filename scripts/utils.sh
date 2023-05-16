# Reset
NOCOLOR='\033[0m'       # Text Reset

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

release_file=$(cat /etc/os-release | grep 'Ubuntu')
snap=$(snap version | grep 'snap')

function check_sudo() {
    [ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
    HOME="$(getent passwd "$SUDO_USER" | cut -f6 -d:)"
    USER=$SUDO_USER
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
        as_normal_user "rm -rf $i"
        print_red "### Removing $i"
    done
}

function as_normal_user() {
    sudo -H -u $SUDO_USER bash -c "$1"
}

function print_green() {
    echo -e "${BGREEN}$1${NOCOLOR}" >&2
}

function print_red() {
    echo -e "${BRED}$1${NOCOLOR}" >&2
}

function is_ubuntu() {
    [[ ! -z $release_file ]] && return 0 || return 1
}

#############################################
# Deletes every element of the provided array
#
# Example:
#   snap 'sudo snap install --edge nvim --classic'
#############################################
function if_snap() {
    if [[ ! -z $snap ]]; then 
        $1
    else
        print_red '### SNAP NOT FOUND'
        exit 1
    fi
}
