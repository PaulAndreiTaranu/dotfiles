#!/usr/bin/env bash

# Reset
NOCOLOR='\033[0m'       # Text Reset

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

echo -e "${BGREEN}### SETTING UP SSH${NOCOLOR}" >&2
ssh-keygen -t ed25519 -f ~/.ssh/$(uname -n) -P "" -q

