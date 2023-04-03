#!/usr/bin/env bash

# Reset
NOCOLOR='\033[0m'       # Text Reset

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

PYTHON_VERSION='3.11'

echo -e "${BGREEN}### INSTALLING PYTHON${NOCOLOR}" >&2
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update -y
sudo apt install -y "python$PYTHON_VERSION"

sudo rm -rf /bin/py
sudo "ln /bin/python$PYTHON_VERSION /bin/py"

sudo apt autoremove -y
