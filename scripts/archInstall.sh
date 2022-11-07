#!/usr/bin/env bash

# First attempt to automate installation

# Update pacman and instal base tools
pacman -Syyu && pacman -S --needed base-devel git

# Paru installation and use of paru to install the rest
cd $HOME && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si
paru && paru -S neovim zsh unzip stow visual-studio-code nerd-fonts-fira-code

# Neovim
rm -rf /bin/vi && ln /bin/nvim /bin/vi
# Script to setup packer and install all plugins
vi --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Stow
stow zsh git code nvim
