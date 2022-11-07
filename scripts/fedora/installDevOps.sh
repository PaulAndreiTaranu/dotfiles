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
sudo usermod -aG docker $USER
sudo systemctl enable docker.service --now
sudo systemctl enable containerd.service --now

echo -e "${BGREEN}### INSTALLING TERRAFORM REPO${NOCOLOR}" >&2
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

echo -e "${BGREEN}### INSTALLING TERRAFORM${NOCOLOR}" >&2
sudo dnf -y install terraform

echo -e "${BGREEN}### INSTALLING AZURE-CLI${NOCOLOR}" >&2
sudo dnf -y install azure-cli

echo -e "${BGREEN}### DOWNLOADING KUBECTL${NOCOLOR}" >&2
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo -e "${BGREEN}### CHECKING KUBECTL${NOCOLOR}" >&2
kubectl version --client --output=yaml

echo -e "${BGREEN}### CLEANING${NOCOLOR}" >&2
sudo dnf -y autoremove && sudo dnf -y clean all