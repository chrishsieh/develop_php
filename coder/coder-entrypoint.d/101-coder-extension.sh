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
add_extension() {
	local extension_path="${1}"
	local debug="${2}"    # show commands if debug level > 1

	local clr_red="\033[0;31m"
	local clr_green="\033[0;32m"
	local clr_reset="\033[0m"

	local folder_name="$(echo ${extension_path}| cut -d '/' -f 8).$(echo ${extension_path}| cut -d '/' -f 10)-$(echo ${extension_path}| cut -d '/' -f 11)"

	if [ "${debug}" -gt "1" ]; then
		printf "${clr_red}%s \$${clr_green}install extension ${folder_name}${clr_reset}\n" "$( whoami )"
	fi
	mkdir -p ${VSCODE_EXTENSIONS}/${folder_name}
	curl -JL --retry 10 ${extension_path} | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/${folder_name} extension
}

############################################################
# Sanity Checks
############################################################

if ! command -v printenv >/dev/null 2>&1; then
	log "err" "printenv not found, but required." "1"
	exit 1
fi