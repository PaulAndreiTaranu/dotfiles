#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
. $SCRIPTS/setups/setupZsh.sh
. $SCRIPTS/setups/setupFont.sh
. $SCRIPTS/setups/setupCode.sh
check_sudo

print_green '### INSTALLING LAZYGIT'
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/bin
sudo rm -rf lazygit.tar.gz lazygit
