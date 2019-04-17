#!/usr/bin/env bash

set -e
set -u
set -o pipefail


if ! [ -f git_clone.done ]; then
git_clone "https://github.com/ChurchCRM/CRM.git" "CRM" "${DEBUG_LEVEL}"
run "cp CRM/BuildConfig.json.example CRM/BuildConfig.json" "${DEBUG_LEVEL}"
run "cd CRM && npm install" "${DEBUG_LEVEL}"
touch git_clone.done
fi

###
### Supervisor: socat
###
###for line in $( port_forward_get_lines "FORWARD_PORTS_TO_LOCALHOST" ); do
###	lport="$( port_forward_get_lport "${line}" )"
###	rhost="$( port_forward_get_rhost "${line}" )"
###	rport="$( port_forward_get_rport "${line}" )"
###	supervisor_add_service \
###		"socat-${lport}-${rhost}-${rport}" \
###		"/usr/bin/socat tcp-listen:${lport},reuseaddr,fork tcp:${rhost}:${rport}" \
###		"${DVL_SUPERVISOR_CONFD}" \
###		"${DEBUG_LEVEL}"
###done