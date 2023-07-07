#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

print_green "### UPDATING SYSTEM"
sudo apt update

print_green "### INSTALLING REQUIRED PACKAGES"
sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https

if is_ubuntu; then
    print_green "### SETTING UP DOCKER REPOSITORY"
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    print_green "### UPDATING ALL REPOSITORIES"
    sudo apt update

    print_green "### INSTALLING DOCKER"
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    print_green "### SETTING UP DOCKER"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    # sudo systemctl enable docker.service --now
    # sudo systemctl enable containerd.service --now

    print_green "### CLEANARDO BB"
    sudo apt autoremove -y
fi
