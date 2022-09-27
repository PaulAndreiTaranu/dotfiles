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

Check if the script is run by sudo
if ! [ $(id -u) = 0 ]; then
    echo -e "${BRED}### The script need to be run as root.${NOCOLOR}" >&2
    exit
fi

echo -e "${BGREEN}### INSTALLING SOFTWARE${NOCOLOR}" >&2

# Install VSCode repo
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Install Google Chrome repo
dnf -y install fedora-workstation-repositories
dnf -y config-manager --set-enabled google-chrome

# Install postgresql repo
dnf -y install http://apt.postgresql.org/pub/repos/yum/reporpms/F-36-x86_64/pgdg-fedora-repo-latest.noarch.rpm

# Install docker repo
dnf -y config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

dnf -y install code
dnf -y install google-chrome-stable
dnf -y install postgresql14-server postgresql14-docs
dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
dnf -y install kitty zsh neovim pipenv btop

# Setup docker
groupadd docker
usermod -aG docker $USERNAME
systemctl enable docker.service --now
systemctl enable containerd.service --now

# Setup postgresql and check availability check
echo -e "${BGREEN}### SETTING UP POSTGRES${NOCOLOR}" >&2
/usr/pgsql-14/bin/postgresql-14-setup initdb
systemctl enable postgresql-14 --now
systemctl status postgresql-14

# Neovim
echo -e "${BGREEN}### SETTING UP NEOVIM${NOCOLOR}" >&2
rm -rf /bin/vi && ln /bin/nvim /bin/vi

# ZSH
echo -e "${BGREEN}### SETTING UP ZSH FOR USER: ${USERNAME}${NOCOLOR}" >&2

ASNORMALUSER="sudo -H -u $USERNAME bash -c"
# $ASNORMALUSER 'bash $HOME/dotfiles/ohmyzsh.sh'

$ASNORMALUSER 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
$ASNORMALUSER 'usermod --shell $(which zsh) $USERNAME'
$ASNORMALUSER 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'

echo -e "${BGREEN}### SETTING UP dotfiles WITH STOW${NOCOLOR}" >&2
$ASNORMALUSER 'rm $HOME/.zshrc'
$ASNORMALUSER 'cd $HOME/dotfiles && stow git nvim code zsh && exit'

echo -e "${BGREEN}### CLEANARDO BB${NOCOLOR}" >&2
dnf -y upgrade && dnf -y autoremove && dnf -y clean all