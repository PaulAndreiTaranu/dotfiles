#!/usr/bin/env bash
set -euo pipefail

# Source all required scripts
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASE_DIR/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}
source "$BASE_DIR/installDocker.sh" || {
	echo "XXX FAILED TO LOAD INSTALLDOCKER.SH"
	exit 1
}

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
SWAP_SIZE="2G" # Adjust based on your VPS RAM

# ---------------------------------------------------------------------------
# 1. Root & distro check
# ---------------------------------------------------------------------------
ensure_root

ensure_ubuntu

print_green "#### HETZNER VPS SETUP ####"
print_green "=== VPS setup started ==="

# ---------------------------------------------------------------------------
# 2. System update
# ---------------------------------------------------------------------------
print_green "### UPDATING SYSTEM"
apt update && apt upgrade -y

# ---------------------------------------------------------------------------
# 3. Set timezone & enable NTP
# ---------------------------------------------------------------------------
print_green "### CONFIGURING TIMEZONE & NTP"
timedatectl set-timezone UTC
timedatectl set-ntp true
print_green "Timezone set to UTC, NTP enabled"

# ---------------------------------------------------------------------------
# 4. Base essentials
# ---------------------------------------------------------------------------
print_green "### INSTALLING BASE PACKAGES"
apt -y install \
	build-essential \
	curl \
	wget \
	git \
	btop \
	jq \
	unzip \
	chrony

systemctl enable chrony
systemctl start chrony
print_green "Base packages installed, chrony enabled"

# ---------------------------------------------------------------------------
# 5. Swap (skip if already exists)
# ---------------------------------------------------------------------------
print_green "### CONFIGURING SWAP"
if swapon --show | grep -q '/swapfile'; then
	print_green "### Swap already configured, skipping"
else
	fallocate -l "$SWAP_SIZE" /swapfile
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	# Persist across reboots
	grep -q '/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >>/etc/fstab
	# Tune swappiness for a server (low value = prefer RAM)
	sysctl vm.swappiness=10
	grep -q 'vm.swappiness' /etc/sysctl.conf || echo 'vm.swappiness=10' >>/etc/sysctl.conf
	print_green "Swap configured: $SWAP_SIZE"
fi

# ---------------------------------------------------------------------------
# 6. Docker + Compose
# ---------------------------------------------------------------------------
install_docker
enable_docker

# ---------------------------------------------------------------------------
# 7. Security hardening
# ---------------------------------------------------------------------------
print_green "### SECURITY HARDENING"

# --- UFW ---
apt -y install ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable
print_green "UFW configured"

# --- Fail2ban ---
apt -y install fail2ban
# Create a local override so updates don't clobber config
if [[ ! -f /etc/fail2ban/jail.local ]]; then
	cat >/etc/fail2ban/jail.local <<'EOF'
[DEFAULT]
bantime  = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port    = ssh
backend = systemd
EOF
	print_green "fail2ban jail.local created"
fi
systemctl enable fail2ban
systemctl restart fail2ban
print_green "### fail2ban enabled"

# --- Harden SSH (root login is disabled by createUser.sh) ---
SSHD_CONFIG="/etc/ssh/sshd_config"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
sed -i 's/^#\?X11Forwarding.*/X11Forwarding no/' "$SSHD_CONFIG"
sed -i 's/^#\?MaxAuthTries.*/MaxAuthTries 3/' "$SSHD_CONFIG"
systemctl restart ssh
print_green "SSH hardened"

# --- Kernel / sysctl hardening ---
print_green "### SYSCTL HARDENING"
SYSCTL_HARDENING="/etc/sysctl.d/99-hardening.conf"
cat >"$SYSCTL_HARDENING" <<'EOF'
# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0

# Ignore source-routed packets
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0

# SYN flood protection
net.ipv4.tcp_syncookies = 1

# Log martian packets
net.ipv4.conf.all.log_martians = 1

# Disable ICMP broadcast echo (smurf protection)
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Harden BPF JIT
net.core.bpf_jit_harden = 2
EOF
sysctl --system >/dev/null 2>&1
print_green "sysctl hardening applied"

# ---------------------------------------------------------------------------
# 8. Automatic security updates
# ---------------------------------------------------------------------------
print_green "### ENABLING UNATTENDED UPGRADES"
apt -y install unattended-upgrades apt-listchanges
dpkg-reconfigure -plow unattended-upgrades
print_green "Unattended upgrades enabled"

# ---------------------------------------------------------------------------
# 9. Limit journald disk usage
# ---------------------------------------------------------------------------
print_green "### CONFIGURING JOURNALD LIMITS"
mkdir -p /etc/systemd/journald.conf.d
cat >/etc/systemd/journald.conf.d/size.conf <<'EOF'
[Journal]
SystemMaxUse=200M
MaxRetentionSec=30day
EOF
systemctl restart systemd-journald
print_green "Journald limits set (200M, 30 days)"

# ---------------------------------------------------------------------------
# 10. Cleanup
# ---------------------------------------------------------------------------
print_green "### CLEANUP"
apt autoremove -y && apt clean -y

print_green "=== VPS setup complete ==="
print_green "#### VPS SETUP COMPLETE ####"
print_green "# Next steps:"
print_green "#   1. Run createUser.sh to create a non-root user"
print_green "#      bash createUser.sh <username>"
print_green "#   2. Test SSH login as that user"
print_green "#   3. Reboot:  reboot"
