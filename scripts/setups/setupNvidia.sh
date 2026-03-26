#!/usr/bin/env bash
set -euo pipefail

# Source all required scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

function setup_nvidia() {
	print_green "### SETTING UP NVIDIA DRIVER + WAYLAND SUPPORT"

	ensure_root

	# 1. Remove conflicting drivers / clean slate
	print_green "### Removing old Nvidia / nouveau drivers (if any)"
	sudo apt remove --purge -y '^nvidia-.*' '^libnvidia-.*' 'nouveau-firmware' || true
	sudo apt autoremove -y || true
	sudo apt update -y

	# 2. Install recommended driver (using ubuntu-drivers)
	# Ubuntu has the `ubuntu-drivers` tool which picks the best
	print_green "### Detecting available Nvidia drivers"
	if command -v ubuntu-drivers &>/dev/null; then
		local recommended_driver
		recommended_driver=$(ubuntu-drivers list --recommended 2>/dev/null || true)

		if [[ -n "$recommended_driver" ]]; then
			print_green "Installing recommended driver(s): $recommended_driver"
			read -r -a driver_packages <<<"$recommended_driver"
			sudo apt install -y "${driver_packages[@]}"
		else
			print_yellow "No recommended driver found; falling back to latest"
			sudo apt install -y nvidia-driver-560
		fi
	else
		print_yellow "ubuntu-drivers not found — installing manually"
		sudo apt install -y nvidia-driver-560
	fi

	# Optionally you could install a specific driver version:
	# DRIVER="nvidia-driver-560"
	# sudo apt install -y "$DRIVER"

	# 3. Make sure kernel options for Wayland are enabled
	print_green "### Enabling nvidia-drm modeset and Wayland support"
	# Add kernel param nvidia-drm.modeset=1
	# and ensure GDM allows Wayland
	local grub_cfg="/etc/default/grub"
	sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia-drm.modeset=1"/' "$grub_cfg"
	sudo update-grub

	# 4. Install supporting Wayland bridge / EGL library
	print_green "### Installing supporting EGL / Wayland libraries"
	sudo apt install -y libnvidia-egl-wayland1

	# 5. Reboot or prompt user
	print_yellow "️!!! NVIDIA DRIVER INSTALLED. REBOOT IS REQUIRED FOR CHANGES TO TAKE EFFECT."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	setup_nvidia
fi
