#!/usr/bin/env bash

# Reset
NOCOLOR='\033[0m'       # Text Reset

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

echo -e "${BGREEN}### UPDATING SYSTEM${NOCOLOR}" >&2
sudo apt update && sudo apt upgrade -y

echo -e "${BGREEN}### INSTALLING SOFTWARE${NOCOLOR}" >&2
sudo apt -y install curl wget git zsh stow neovim btop
sudo wget https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
sudo dpkg -i lsd_0.23.1_amd64.deb
sudo rm lsd_0.23.1_amd64.deb
sudo rm -rf /bin/vi && sudo ln /bin/nvim /bin/vi

echo -e "${BGREEN}### SETTING UP ZSH${NOCOLOR}" >&2
ASNORMALUSER="sudo -H -u $USER bash -c"
$ASNORMALUSER 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
$ASNORMALUSER "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
sudo usermod --shell $(which zsh) $USER

echo -e "${BGREEN}### SETTING UP DOTFILES${NOCOLOR}" >&2
$ASNORMALUSER   'rm -rf ~/.config/nvim \
                ~/.zshrc ~/.zshrc.backup ~/.bashrc ~/.bash_history ~/.bash_logout \
                ~/.bash_profile ~/.viminfo ~/.gitconfig && mkdir ~/.config'
$ASNORMALUSER 'cd $HOME/dotfiles && stow git nvim zsh'

echo -e "${BGREEN}### CLEANARDO BB${NOCOLOR}" >&2
$ASNORMALUSER 'find $HOME/dotfiles/scripts -type f -iname "*.sh" -exec chmod +x {} \;'
sudo apt autoremove -y