#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/utils.sh" || { echo "XXX FAILED TO LOAD UTILS.SH"; exit 1; }

require_commands curl stow