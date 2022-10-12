#!/usr/bin/env bash

# Username
USERNAME='paul'

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

echo -e "${BGREEN}### INSTALLING SOFTWARE${NOCOLOR}" >&2
sudo dnf -y install kitty zsh stow neovim pipenv btop lsd

# Neovim
echo -e "${BGREEN}### SETTING UP NEOVIM${NOCOLOR}" >&2
sudo rm -rf /bin/vi && ln /bin/nvim /bin/vi

# ZSH
echo -e "${BGREEN}### SETTING UP ZSH${NOCOLOR}" >&2
# ASNORMALUSER="sudo -H -u $USERNAME bash -c"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
usermod --shell $(which zsh) $USERNAME
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# PNPM
echo -e "${BGREEN}### INSTALLING PNPM${NOCOLOR}" >&2
curl -fsSL https://get.pnpm.io/install.sh | sh -

echo -e "${BGREEN}### SETTING UP dotfiles WITH STOW${NOCOLOR}" >&2
rm $HOME/.zshrc $HOME/.bashrc
cd $HOME/dotfiles && stow git nvim zsh kitty

echo -e "${BGREEN}### CLEANARDO BB${NOCOLOR}" >&2
find $HOME/dotfiles/scripts -type f -iname '*.sh' -exec chmod +x {} \;
git config --global credential.helper store
sudo dnf -y upgrade && dnf -y autoremove && dnf -y clean all