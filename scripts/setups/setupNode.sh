#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh

function setup_node() {
    print_green '### SETTING UP NODE'

    # NVM_DIR="$HOME/.nvm"
    # if [[ -d "$NVM_DIR" ]]; then
    #     print_red "### REMOVING NVM"
    #     rm -rf $NVM_DIR
    # fi
    # print_green "### INSTALLING NVM"
    # curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

    N_PREFIX="$HOME/.local/bin/n"
    if [[ ! -d "$N_PREFIX" ]]; then
        print_green "### INSTALLING N"
        curl -L https://bit.ly/n-install | N_PREFIX="$N_PREFIX" bash -s -- -y -n
    else
        print_red "### N ALREADY INSTALLED"
    fi

    PNPM_HOME="$HOME/.local/share/pnpm"
    if [[ ! -d "$PNPM_HOME" ]]; then
        print_green "### INSTALLING PNPM"
        curl -fsSL https://get.pnpm.io/install.sh | bash
    else
        print_red "### PNPM ALREADY INSTALLED"
    fi

    # print_green "### INSTALLING LATEST NODEJS"
    # WHICH_SHELL=$(echo $SHELL)
    # if [[ $WHICH_SHELL = '/usr/bin/zsh' ]]; then
    #     print_green '### SOURCING .zshrc AND INSTALLING NODE'
    #     zsh -c "source $HOME/.zshrc && nvm install node"
    # elif [[ $WHICH_SHELL = '/usr/bin/bash' ]]; then
    #     print_green '### SOURCING .bashrc AND INSTALLING NODE'
    #     bash -c "source "$HOME/.bashrc" && nvm install node"
    # else
    #     print_green '### SHELL NOT SUPPORTED'
    #     exit 1
    # fi
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_node
fi
