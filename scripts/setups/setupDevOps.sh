#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

function setup_docker() {
	ensure_root
	print_green "### SETTING UP DOCKER"

	print_green "### INSTALLING REQUIRED PACKAGES"
	apt install -y ca-certificates curl

	# Uninstall any previous Docker installation
	if command -v docker >/dev/null 2>&1; then
		print_red "### REMOVING PREVIOUS DOCKER INSTALLATION"
		local pkgs="docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc"
		sudo apt-get remove -y $pkgs || true
	fi

	print_green "### ADDING DOCKER REPOSITORY"
	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	chmod a+r /etc/apt/keyrings/docker.asc

	print_green "ADD THE REPOSITORY TO APT SOURCES:"
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
		tee /etc/apt/sources.list.d/docker.list >/dev/null
	apt-get update

	print_green "### INSTALLING DOCKER"
	apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	print_green "### CONFIGURING DOCKER GROUP"
	groupadd -f docker
	usermod -aG docker "$USER"

	print_green "### NOTE: Log out & log back in for Docker group to apply"

	# Automatically start Docker and containerd on boot for other Linux distributions using systemd:
	# sudo systemctl enable docker.service --now
	# sudo systemctl enable containerd.service --now

}

function setup_kubectl() {
	ensure_root

	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
	echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
	sudo install -o root -g root -m 0755 kubectl /usr/local/bn/kubectl
	rm -rf kubectl kubectl.sha256
}

function setup_minikube() {
	ensure_root

	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
	print_green "### UPDATING SYSTEM"
	sudo apt update

	setup_docker
	# setup_kubectl
	# setup_minikube

	print_green "### CLEANARDO BB"
	sudo apt autoremove -y
fi
