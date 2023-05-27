#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

function setup_tmux() {
    print_green '### SETTING UP TMUX'

    if [ ! -e "/usr/bin/tmux" ]; then
        print_green '### INSTALLING TMUX'
        if is_ubuntu; then
            sudo apt -y install tmux
        else
            print_red '### DISTRO NOT SUPPORTED'
            exit 1
        fi
    else
        print_red '### TMUX ALREADY INSTALLED'
    fi

    # Deleting present config and adding new config
    nvim_config_array=(
        $HOME/.config/tmux
        $HOME/.tmux/plugins
    )
    remove_with_array "${nvim_config_array[@]}"
    as_normal_user "mkdir $HOME/.config/tmux && cd $HOME/dotfiles && stow tmux"

    print_green '### INSTALLING TMUX PLUGIN MANGER AND PLUGINS'
    as_normal_user "git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm"
    as_normal_user "bash $HOME/.tmux/plugins/tpm/bin/install_plugins"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_tmux
fi
