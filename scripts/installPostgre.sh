#!/usr/bin/env bash

# Reset
NOCOLOR='\033[0m'       # Text Reset

# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'

echo -e "${BGREEN}### INSTALLING POSTGRESQL REPO${NOCOLOR}" >&2
sudo dnf -y install http://apt.postgresql.org/pub/repos/yum/reporpms/F-36-x86_64/pgdg-fedora-repo-latest.noarch.rpm

echo -e "${BGREEN}### INSTALLING POSTGRESQL${NOCOLOR}" >&2
sudo dnf -y install postgresql14-server postgresql14-docs

echo -e "${BGREEN}### SETTING UP POSTGRESQL${NOCOLOR}" >&2
sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
sudo systemctl enable postgresql-14 --now
sudo systemctl status postgresql-14