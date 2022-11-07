#!/usr/bin/env bash

# Reset
NOCOLOR='\033[0m'       # Text Reset

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

echo -e "${BGREEN}### INSTALLING GOOGLE CHROME REPO${NOCOLOR}" >&2
sudo dnf -y install fedora-workstation-repositories
sudo dnf -y config-manager --set-enabled google-chrome

echo -e "${BGREEN}### INSTALLING GOOGLE CHROME${NOCOLOR}" >&2
sudo dnf -y install google-chrome-stable