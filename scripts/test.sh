#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh

print_green '### REMOVING USELESS DOTFILES && SETTING UP REMAINING DOTFILES'
files_to_remove=(
    $HOME/.config/kitty
    $HOME/.bashrc $HOME/.bash_history $HOME/.bash_logout $HOME/.bash_profile
    $HOME/.profile
    $HOME/.viminfo
    $HOME/.config/git
    $HOME/.gitconfig
)
remove_with_array "${files_to_remove[@]}"
as_normal_user "mkdir $HOME/.config/kitty $HOME/.config/git"
as_normal_user "cd $HOME/dotfiles && stow git kitty"

# [[ ! -z $snap ]] && echo 'Not Empty' || echo 'Empty'
