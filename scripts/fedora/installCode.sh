#!/usr/bin/env bash

# Reset
NOCOLOR='\033[0m'       # Text Reset

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

echo -e "${BGREEN}### INSTALLING VSCODE REPO${NOCOLOR}" >&2
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

echo -e "${BGREEN}### INSTALLING VSCODE${NOCOLOR}" >&2
sudo dnf -y install code
cd $HOME/dotfiles && stow code