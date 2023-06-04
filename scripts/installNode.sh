#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh

PNPM_HOME="$HOME/.local/share/pnpm"
NVM_DIR="$HOME/.nvm"

if [[ -d "$PNPM_HOME" ]]; then
    print_red "### REMOVING PNPM"
    rm -rf $PNPM_HOME
fi
if [[ -d "$NVM_DIR" ]]; then
    print_red "### REMOVING NVM"
    rm -rf $NVM_DIR
fi

print_green "### INSTALLING NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

print_green "### INSTALLING PNPM"
curl -fsSL https://get.pnpm.io/install.sh | bash

print_green "### INSTALLING LATEST NODEJS"
WHICH_SHELL=$(echo $SHELL)
if [[ $WHICH_SHELL = '/usr/bin/zsh' ]]; then
    print_green '### SOURCING .zshrc AND INSTALLING NODE'
    zsh -c "source $HOME/.zshrc && nvm install node"
elif [[ $WHICH_SHELL = '/usr/bin/bash' ]]; then
    print_green '### SOURCING .bashrc AND INSTALLING NODE'
    bash -c "source "$HOME/.bashrc" && nvm install node"
else
    print_green '### SHELL NOT SUPPORTED'
    exit 1
fi
