#!/usr/bin/env bash

# Reset
NOCOLOR='\033[0m'       # Text Reset

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

echo -e "${BGREEN}### UPDATING SYSTEM${NOCOLOR}" >&2
sudo apt update

echo -e "${BGREEN}### INSTALLING REQUIRED PACKAGES${NOCOLOR}" >&2
sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https

echo -e "${BGREEN}### SETTING UP DOCKER REPOSITORY${NOCOLOR}" >&2
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo -e "${BGREEN}### SETTING UP TERRAFORM REPO${NOCOLOR}" >&2
sudo wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
sudo gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

echo -e "${BGREEN}### SETTING UP AZURE-CLI REPO${NOCOLOR}" >&2
sudo mkdir -p /etc/apt/keyrings
sudo curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | \
    sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] \
    https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list

echo -e "${BGREEN}### SETTING UP KUBECTL REPO${NOCOLOR}" >&2
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] \
    https://apt.kubernetes.io/ kubernetes-xenial main" | \
    sudo tee /etc/apt/sources.list.d/kubernetes.list

echo -e "${BGREEN}### UPDATING ALL REPOSITORIES${NOCOLOR}" >&2
sudo apt update

echo -e "${BGREEN}### INSTALLING DOCKER${NOCOLOR}" >&2
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo -e "${BGREEN}### SETTING UP DOCKER${NOCOLOR}" >&2
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker.service --now
sudo systemctl enable containerd.service --now

echo -e "${BGREEN}### INSTALLING TERRAFORM${NOCOLOR}" >&2
sudo apt install -y terraform

echo -e "${BGREEN}### INSTALLING AZURE-CLI${NOCOLOR}" >&2
sudo apt install -y azure-cli

echo -e "${BGREEN}### INSTALLING KUBECTL${NOCOLOR}" >&2
sudo apt install -y kubectl

echo -e "${BGREEN}### CHECKING KUBECTL${NOCOLOR}" >&2
kubectl version --client --output=yaml

echo -e "${BGREEN}### CLEANARDO BB${NOCOLOR}" >&2
sudo apt autoremove -y