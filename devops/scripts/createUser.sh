#!/usr/bin/env bash
set -euo pipefail

# Source all required scripts
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASE_DIR/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

# ---------------------------------------------------------------------------
# 1. Root & distro check
# ---------------------------------------------------------------------------
ensure_root

ensure_ubuntu

# ---------------------------------------------------------------------------
# 2. Create user, sudo group, set password
# ---------------------------------------------------------------------------
print_green "### USER SETUP"
USERNAME="${1:-}"
if [[ -z "$USERNAME" ]]; then
	read -rp "Enter username to create: " USERNAME
fi

if [[ -z "$USERNAME" ]]; then
	print_red "XXX Username cannot be empty"
	exit 1
fi

if id "$USERNAME" &>/dev/null; then
	print_green "### User $USERNAME already exists, skipping creation"
else
	adduser --gecos "" "$USERNAME"
	print_green "### Created user $USERNAME"
fi

usermod -aG sudo "$USERNAME"
print_green "### Added $USERNAME to sudo group (password required for sudo)"

# ---------------------------------------------------------------------------
# 3. Copy SSH keys from root
# ---------------------------------------------------------------------------
USER_HOME="/home/$USERNAME"
if [[ -f /root/.ssh/authorized_keys ]]; then
	mkdir -p "$USER_HOME/.ssh"
	cp /root/.ssh/authorized_keys "$USER_HOME/.ssh/authorized_keys"
	chmod 700 "$USER_HOME/.ssh"
	chmod 600 "$USER_HOME/.ssh/authorized_keys"
	chown -R "$USERNAME:$USERNAME" "$USER_HOME/.ssh"
	print_green "### Copied SSH authorized_keys to $USERNAME"
else
	print_red "### WARNING: /root/.ssh/authorized_keys not found — add keys manually"
fi

# ---------------------------------------------------------------------------
# 4. Add to docker group (if docker is installed)
# ---------------------------------------------------------------------------
if command -v docker &>/dev/null; then
	usermod -aG docker "$USERNAME"
	print_green "### Added $USERNAME to docker group"
fi

# ---------------------------------------------------------------------------
# 5. Disable root login now that a non-root user exists
# ---------------------------------------------------------------------------
SSHD_CONFIG="/etc/ssh/sshd_config"
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
systemctl restart ssh
print_green "### SSH root login disabled"

# ---------------------------------------------------------------------------
# 6. Done
# ---------------------------------------------------------------------------
print_green "#### USER SETUP COMPLETE ####"
print_green "# Reminder: Test SSH as $USERNAME before closing this session"
print_green "#   ssh $USERNAME@<server-ip>"
