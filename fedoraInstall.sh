#!/bin/bash

# Reset
NOCOLOR='\033[0m'       # Text Reset

# Regular Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

# Check if the script is run by sudo
if ! [ $(id -u) = 0 ]; then
   echo -e "${BRED}### The script need to be run as root.${NOCOLOR}" >&2
   exit 1
fi

# Install VSCode repo
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Install Google Chrome repo
echo -e "${BGREEN}### INSTALLING SOFTWARE${NOCOLOR}" >&2
dnf -y install fedora-workstation-repositories
dnf -y config-manager --set-enabled google-chrome

dnf -y install code google-chrome-stable kitty zsh neovim

# Neovim
echo -e "${BGREEN}### NEOVIM SETUP${NOCOLOR}" >&2
rm -rf /bin/vi && ln /bin/nvim /bin/vi