#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

PNPM="$HOME/.local/share/pnpm/pnpm"
if [ -e "$PNPM" ]; then
    as_pnpm_loaded 'pnpm add -g tree-sitter-cli'
fi

# [[ ! -z $snap ]] && echo 'Not Empty' || echo 'Empty'
