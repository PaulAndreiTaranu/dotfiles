#!/usr/bin/env bash

UTILS_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
.  $UTILS_DIR/utils.sh
check_sudo

if [[ -d "$HOME/xdd" && -e "$HOME/xd" ]]; then
    print_green "true"
else
    print_red "false"
fi

# [[ ! -z $snap ]] && echo 'Not Empty' || echo 'Empty'