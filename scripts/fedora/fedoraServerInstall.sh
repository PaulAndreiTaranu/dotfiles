#!/usr/bin/env bash

# Reset
NOCOLOR='\033[0m'       # Text Reset

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

echo -e "${BGREEN}### INSTALLING SOFTWARE${NOCOLOR}" >&2
# sudo dnf -y install zsh stow neovim pipenv btop lsd
# sudo rm -rf /bin/vi && ln /bin/nvim /bin/vi

# ZSH
echo -e "${BGREEN}### SETTING UP ZSH${NOCOLOR}" >&2
ASNORMALUSER="sudo -H -u $USER bash -c"
$ASNORMALUSER 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
$ASNORMALUSER "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
usermod --shell $(which zsh) $USER


echo -e "${BGREEN}### SETTING UP DOTFILES${NOCOLOR}" >&2
$ASNORMALUSER 'rm ~/.zshrc ~/.bashrc ~/.bash_history ~/.bash_logout ~/.bash_profile ~/.viminfo ~/.gitconfig'
$ASNORMALUSER 'cd $HOME/dotfiles && stow git nvim zsh'

echo -e "${BGREEN}### CLEANARDO BB${NOCOLOR}" >&2
$ASNORMALUSER 'find $HOME/dotfiles/scripts -type f -iname "*.sh" -exec chmod +x {} \;'
# sudo dnf -y upgrade && dnf -y autoremove && dnf -y clean all