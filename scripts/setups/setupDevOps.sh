#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

function setup_docker() {
    print_green "### SETTING UP DOCKER"

    print_green "### INSTALLING REQUIRED PACKAGES"
    sudo apt install -y ca-certificates curl

    DOCKER_PACKAGES="docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc"
    if [[ -e /usr/bin/docker ]]; then
        print_red "### UNINSTALL DOCKER PACKAGES"
        for package in $DOCKER_PACKAGES; do
            print_red "### Uninstalling $package"
            sudo apt-get remove -y $package
        done
    fi

    print_green "### SETTING UP DOCKER REPOSITORY"
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    print_green "ADD THE REPOSITORY TO APT SOURCES:"
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update

    print_green "### INSTALLING DOCKER"
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    print_green "### SETTING UP DOCKER"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker

    # Automatically start Docker and containerd on boot for other Linux distributions using systemd:
    # sudo systemctl enable docker.service --now
    # sudo systemctl enable containerd.service --now

}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    print_green "### UPDATING SYSTEM"
    sudo apt update

    setup_docker

    print_green "### CLEANARDO BB"
    sudo apt autoremove -y
fi
