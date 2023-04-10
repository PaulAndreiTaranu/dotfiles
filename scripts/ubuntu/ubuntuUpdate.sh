#!/usr/bin/env bash

# Reset
NOCOLOR='\033[0m'       # Text Reset

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

echo -e "${BGREEN}### UPDATING SYSTEM${NOCOLOR}" >&2
sudo apt update && sudo apt upgrade -y

echo -e "${BGREEN}### CLEANARDO BB${NOCOLOR}" >&2
$ASNORMALUSER 'find $HOME/dotfiles/scripts -type f -iname "*.sh" -exec chmod +x {} \;'
sudo apt autoremove -y
