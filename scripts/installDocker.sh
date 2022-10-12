#!/usr/bin/env bash

# Reset
NOCOLOR='\033[0m'       # Text Reset

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

echo -e "${BGREEN}### INSTALLING DOCKER REPO${NOCOLOR}" >&2
sudo dnf -y config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

echo -e "${BGREEN}### INSTALLING DOCKER${NOCOLOR}" >&2
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo -e "${BGREEN}### SETTING UP DOCKER${NOCOLOR}" >&2
sudo groupadd docker
sudo usermod -aG docker $USERNAME
sudo systemctl enable docker.service --now
sudo systemctl enable containerd.service --now