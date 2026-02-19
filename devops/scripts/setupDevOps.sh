#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}
source "$SCRIPT_DIR/installDocker.sh" || {
	echo "XXX FAILED TO LOAD INSTALLDOCKER.SH"
	exit 1
}

function setup_kubectl() {
	ensure_root

	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
	echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
	rm -rf kubectl kubectl.sha256
}

function setup_minikube() {
	ensure_root

	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	print_green "### UPDATING SYSTEM"
	sudo apt update

	ensure_root
	install_docker
	enable_docker
	# setup_kubectl
	# setup_minikube

	print_green "### CLEANUP"
	sudo apt autoremove -y
fi
