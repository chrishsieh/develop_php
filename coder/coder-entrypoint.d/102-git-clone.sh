#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Functions
############################################################

###
### Add extension
###
git_clone() {
	local source_path="${1}"
	local folder_name="${2}"
	local debug="${3}"    # show commands if debug level > 1

	local clr_red="\033[0;31m"
	local clr_green="\033[0;32m"
	local clr_reset="\033[0m"

	if [ "${debug}" -gt "1" ]; then
		printf "${clr_red}%s \$${clr_green}git clone ${source_path} to ${folder_name}${clr_reset}\n" "$( whoami )"
	fi

	git clone ${source_path} ${folder_name}
}

############################################################
# Sanity Checks
############################################################

if ! command -v printenv >/dev/null 2>&1; then
	log "err" "printenv not found, but required." "1"
	exit 1
fi