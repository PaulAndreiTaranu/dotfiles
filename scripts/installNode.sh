#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh

PNPM_HOME="$HOME/.local/share/pnpm"
NVM_DIR="$HOME/.nvm"

if [[ -d "$PNPM_HOME" ]]; then
    print_red "### REMOVING PNPM"
    rm -rf $PNPM_HOME
elif [[ -d "$NVM_DIR" ]]; then
    print_red "### REMOVING NVM"
    rm -rf $NVM_DIR
fi

print_green "### INSTALLING NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

print_green "### INSTALLING PNPM"
curl -fsSL https://get.pnpm.io/install.sh | bash

print_green "### INSTALLING LATEST NODEJS"
source $HOME/.zshrc && nvm install node
