#!/usr/bin/dumb-init bash

set -e
set -u

###
### Globals
###

# Path to scripts to source
_CONFIG_DIR="/coder-entrypoint.d"
RUNTIME_CONFIG_DIR="/run.d"

###
### Source libs
###
init="$( find "${_CONFIG_DIR}" -name '*.sh' -type f | sort -u )"
for f in ${init}; do
	. "${f}"
done

#############################################################
## Entry Point
#############################################################

###
### Set Debug level
###
DEBUG_LEVEL="$( env_get "DEBUG_ENTRYPOINT" "0" )"
log "info" "Debug level: ${DEBUG_LEVEL}" "${DEBUG_LEVEL}"

###
### Runtime script
###
exec_script="$( find "${RUNTIME_CONFIG_DIR}" -name '*.sh' -type f | sort -u )"
for f in ${exec_script}; do
	. "${f}"
done

###
###
### Startup
###
log "info" "Starting Code-Server" "${DEBUG_LEVEL}"
exec /usr/local/bin/code-server --password=churchcrm
