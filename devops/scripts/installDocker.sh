#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

# ---------------------------------------------------------------------------
# Install Docker + Compose (idempotent)
# ---------------------------------------------------------------------------
install_docker() {
	print_green "### INSTALLING DOCKER"

	if command -v docker &>/dev/null; then
		print_green "### Docker already installed, skipping"
		return 0
	fi

	apt -y install ca-certificates gnupg

	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
		gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
	chmod a+r /etc/apt/keyrings/docker.gpg

	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
		tee /etc/apt/sources.list.d/docker.list >/dev/null

	apt update
	apt -y install \
		docker-ce \
		docker-ce-cli \
		containerd.io \
		docker-buildx-plugin \
		docker-compose-plugin

	print_green "### Docker installed"
}

enable_docker() {
	systemctl enable docker
	systemctl start docker
	print_green "### Docker service enabled & started"
}

# Run directly if executed (not just sourced)
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	ensure_root
	ensure_ubuntu
	install_docker
	enable_docker
fi
