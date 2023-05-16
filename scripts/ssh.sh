#!/usr/bin/env bash

UTILS_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
.  $UTILS_DIR/utils.sh

print_green '### SETTING UP SSH'
ssh-keygen -t ed25519 -f ~/.ssh/$(uname -n) -P "" -q

### 1. SSH file with private key: config

# Host ubuntuServer
#     HostName 127.0.0.1
#     Port 4099
#     User paul
#     IdentityFile C:\Users\paula\.ssh\ubuntuServer

### 2. SSH file with public key: authorized_keys
# ssh-rsa exampleAAAAB3NzaC1yc2E...
