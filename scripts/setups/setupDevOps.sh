#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

if is_ubuntu; then
    print_green "### UPDATING SYSTEM"
    sudo apt update

    print_green "### INSTALLING REQUIRED PACKAGES"
    sudo apt install -y ca-certificates curl

    DOCKER_PACKAGES="docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc"
    if [[ -e /usr/bin/docker ]]; then
        print_red "### UNINSTALL DOCKER"
        for package in $DOCKER_PACKAGES; do
            print_red "### Uninstalling $package"
            sudo apt-get remove -y $package
        done

        sudo rm -rf "/var/lib/docker"
        sudo rm -rf "/var/lib/containered"
    fi

    print_green "### SETTING UP DOCKER REPOSITORY"
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update

    print_green "### UPDATING ALL REPOSITORIES"
    sudo apt update

    print_green "### INSTALLING DOCKER"
    for package in $DOCKER_PACKAGES; do
        print_green "### Installing $package"
        sudo apt install -y $package
    done

    print_green "### SETTING UP DOCKER"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    # sudo systemctl enable docker.service --now
    # sudo systemctl enable containerd.service --now

    print_green "### CLEANARDO BB"
    sudo apt autoremove -y
fi
