#!/usr/bin/env bash
set -euo pipefail

# Source all required scripts
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASE_DIR/utils.sh" || {
	echo "XXX FAILED TO LOAD UTILS.SH"
	exit 1
}

# ---------------------------------------------------------------------------
# Lynis audit — add this section to setupVPS.sh before the cleanup step
# ---------------------------------------------------------------------------

print_green "### INSTALLING LYNIS"
# Option A: from Ubuntu repos (slightly older version, simpler)
apt -y install lynis

# Option B: from official repo (latest version, uncomment to use instead)
# curl -fsSL https://packages.cisofy.com/keys/cisofy-software-public.key | \
#     gpg --batch --yes --dearmor -o /etc/apt/keyrings/cisofy.gpg
# echo "deb [signed-by=/etc/apt/keyrings/cisofy.gpg] https://packages.cisofy.com/community/lynis/deb/ stable main" | \
#     tee /etc/apt/sources.list.d/cisofy-lynis.list >/dev/null
# apt update && apt -y install lynis

print_green "Lynis installed"

# ---------------------------------------------------------------------------
# Run an initial audit and save the report
# ---------------------------------------------------------------------------
print_green "### RUNNING LYNIS AUDIT"
LYNIS_REPORT="/var/log/lynis-initial-audit.log"

# --quick skips interactive prompts, --no-colors keeps the log clean
lynis audit system --quick | tee "$LYNIS_REPORT"

# Lynis also writes structured data here:
#   /var/log/lynis.log        — full debug log
#   /var/log/lynis-report.dat — machine-parseable results

# Extract the hardening index from the report
HARDENING_INDEX=$(grep 'Hardening index' /var/log/lynis-report.dat | awk -F'=' '{print $2}' | tr -d ' ')
print_green "### Lynis hardening index: ${HARDENING_INDEX:-unknown}/100"
print_green "Lynis audit complete — hardening index: ${HARDENING_INDEX:-unknown}/100"

print_green "### Full report saved to: $LYNIS_REPORT"
print_green "### Structured data at:   /var/log/lynis-report.dat"
print_green "### To review suggestions: grep 'suggestion' /var/log/lynis-report.dat"
