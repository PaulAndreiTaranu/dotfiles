#!/usr/bin/env bash
set -euo pipefail

# =============================================================
# Hetzner VPS Initial Setup Script
# =============================================================
# Usage:
#   1. scp this file to your new server:
#      scp setup-vps.sh root@YOUR_SERVER_IP:~
#
#   2. SSH in and run it:
#      ssh root@YOUR_SERVER_IP
#      bash ~/setup-vps.sh
#
#   OR from a GitHub repo:
#      curl -fsSL https://raw.githubusercontent.com/YOU/REPO/main/setup-vps.sh | bash
# =============================================================

# --------------- Inline utils (no external dependency) ---------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function print_green() { echo -e "${GREEN}$1${NC}"; }
function print_red() { echo -e "${RED}$1${NC}"; }
function print_yellow() { echo -e "${YELLOW}$1${NC}"; }

function ensure_root() {
	if [ "$EUID" -ne 0 ]; then
		print_red "XXX This script must be run as root"
		exit 1
	fi
}

# --------------- Configuration ---------------
# Change these to your preferences
NEW_USER="deploy"
TIMEZONE="Europe/London"
SSH_PORT=22

# --------------- Functions ---------------

function setup_system() {
	ensure_root
	print_green "### UPDATING SYSTEM PACKAGES"
	apt update && apt upgrade -y

	print_green "### SETTING TIMEZONE TO $TIMEZONE"
	timedatectl set-timezone "$TIMEZONE"

	print_green "### INSTALLING ESSENTIAL PACKAGES"
	apt install -y \
		ca-certificates \
		curl \
		git \
		ufw \
		htop \
		nano \
		unzip \
		fail2ban
}

function setup_user() {
	ensure_root
	print_green "### CREATING NON-ROOT USER: $NEW_USER"

	if id "$NEW_USER" &>/dev/null; then
		print_yellow "### USER $NEW_USER ALREADY EXISTS, SKIPPING CREATION"
	else
		adduser --disabled-password --gecos "" "$NEW_USER"
	fi

	usermod -aG sudo "$NEW_USER"

	# Copy root's SSH keys to the new user
	print_green "### COPYING SSH KEYS TO $NEW_USER"
	mkdir -p /home/"$NEW_USER"/.ssh
	cp /root/.ssh/authorized_keys /home/"$NEW_USER"/.ssh/
	chown -R "$NEW_USER":"$NEW_USER" /home/"$NEW_USER"/.ssh
	chmod 700 /home/"$NEW_USER"/.ssh
	chmod 600 /home/"$NEW_USER"/.ssh/authorized_keys

	# Passwordless sudo
	echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/"$NEW_USER"
	chmod 440 /etc/sudoers.d/"$NEW_USER"

	print_green "### USER $NEW_USER CREATED SUCCESSFULLY"
}

function setup_firewall() {
	ensure_root
	print_green "### CONFIGURING UFW FIREWALL"

	ufw default deny incoming
	ufw default allow outgoing
	ufw allow "$SSH_PORT"/tcp comment 'SSH'
	ufw allow 80/tcp comment 'HTTP'
	ufw allow 443/tcp comment 'HTTPS'
	ufw --force enable

	print_green "### FIREWALL ENABLED - ALLOWED PORTS: $SSH_PORT, 80, 443"
}

function setup_ssh_hardening() {
	ensure_root
	print_green "### HARDENING SSH CONFIGURATION"

	local sshd_config="/etc/ssh/sshd_config"

	# Backup original config
	cp "$sshd_config" "$sshd_config.bak"

	# Disable root login
	sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$sshd_config"

	# Disable password authentication
	sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$sshd_config"

	# Disable empty passwords
	sed -i 's/^#\?PermitEmptyPasswords.*/PermitEmptyPasswords no/' "$sshd_config"

	# Restart SSH
	systemctl restart sshd

	print_red "### WARNING: ROOT LOGIN IS NOW DISABLED"
	print_red "### MAKE SURE YOU CAN SSH AS $NEW_USER BEFORE CLOSING THIS SESSION"
}

function setup_docker() {
	ensure_root
	print_green "### SETTING UP DOCKER"

	# Remove any old Docker installations
	if command -v docker >/dev/null 2>&1; then
		print_red "### REMOVING PREVIOUS DOCKER INSTALLATION"
		local pkgs="docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc"
		apt-get remove -y $pkgs || true
	fi

	print_green "### ADDING DOCKER REPOSITORY"
	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	chmod a+r /etc/apt/keyrings/docker.asc

	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
		tee /etc/apt/sources.list.d/docker.list >/dev/null
	apt-get update

	print_green "### INSTALLING DOCKER"
	apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	print_green "### CONFIGURING DOCKER GROUP"
	groupadd -f docker
	usermod -aG docker "$NEW_USER"

	# Enable Docker to start on boot
	systemctl enable docker.service --now
	systemctl enable containerd.service --now

	print_green "### DOCKER INSTALLED SUCCESSFULLY"
	docker --version
	docker compose version
}

function setup_fail2ban() {
	ensure_root
	print_green "### CONFIGURING FAIL2BAN"

	# Create a local config (overrides without touching the default)
	cat >/etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime  = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port    = $SSH_PORT
EOF

	systemctl enable fail2ban --now
	systemctl restart fail2ban

	print_green "### FAIL2BAN CONFIGURED - 5 failed attempts = 1h ban"
}

function create_project_structure() {
	ensure_root
	print_green "### CREATING PROJECT DIRECTORY STRUCTURE"

	local projects_dir="/home/$NEW_USER/projects"
	mkdir -p "$projects_dir"

	# Create a template docker-compose for reference
	cat >"$projects_dir/docker-compose.template.yml" <<'EOF'
# =============================================================
# Template Docker Compose - Copy this for new projects
# =============================================================
# cp docker-compose.template.yml my-project/docker-compose.yml
# =============================================================

services:
  app:
    image: your-image:latest
    container_name: project-name-app
    restart: unless-stopped
    # labels:
    #   - "traefik.enable=true"
    #   - "traefik.http.routers.project-name.rule=Host(`project.yourdomain.com`)"
    networks:
      - web
      - internal

  db:
    image: postgres:16-alpine
    container_name: project-name-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${DB_USER:-appuser}
      POSTGRES_PASSWORD: ${DB_PASS:-changeme}
      POSTGRES_DB: ${DB_NAME:-appdb}
    volumes:
      - db_data:/var/lib/postgresql/data
    networks:
      - internal

networks:
  web:
    external: true    # Shared Traefik network
  internal:
    driver: bridge    # Project-internal network

volumes:
  db_data:
EOF

	chown -R "$NEW_USER":"$NEW_USER" "$projects_dir"
	print_green "### PROJECT STRUCTURE CREATED AT $projects_dir"
}

function print_summary() {
	local server_ip
	server_ip=$(curl -s ifconfig.me 2>/dev/null || echo "UNKNOWN")

	echo ""
	print_green "============================================"
	print_green "  VPS SETUP COMPLETE!"
	print_green "============================================"
	echo ""
	print_green "  Server IP:     $server_ip"
	print_green "  User:          $NEW_USER"
	print_green "  Timezone:      $TIMEZONE"
	print_green "  Docker:        $(docker --version 2>/dev/null | cut -d' ' -f3 | tr -d ',')"
	print_green "  Compose:       $(docker compose version 2>/dev/null | cut -d' ' -f4)"
	echo ""
	print_yellow "  NEXT STEPS:"
	print_yellow "  1. OPEN A NEW TERMINAL and test SSH:"
	print_yellow "     ssh $NEW_USER@$server_ip"
	print_yellow ""
	print_yellow "  2. DO NOT close this session until step 1 works!"
	print_yellow ""
	print_yellow "  3. Once logged in as $NEW_USER, test Docker:"
	print_yellow "     docker run hello-world"
	print_yellow ""
	print_yellow "  4. Projects go in: ~/projects/"
	print_green "============================================"
}

# --------------- Main ---------------

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
	ensure_root

	setup_system
	setup_user
	setup_firewall
	setup_docker
	setup_fail2ban
	setup_ssh_hardening # Do this LAST so you can still fix things if it breaks
	create_project_structure

	print_green "### CLEANARDO BB"
	apt autoremove -y

	print_summary
fi
