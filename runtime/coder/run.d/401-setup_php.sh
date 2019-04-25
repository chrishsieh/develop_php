#!/usr/bin/env bash

set -e
set -u
set -o pipefail


run "cp ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini" "${DEBUG_LEVEL}"
run "cp /setting/uploads.conf ${PHP_INI_DIR}/conf.d/uploads.ini" "${DEBUG_LEVEL}"

if [ "$EN_XDEBUG" = "true" ]; then
	run "cp /setting/xdebug.ini ${PHP_INI_DIR}/conf.d/zz-xdebug.ini" "${DEBUG_LEVEL}"
fi
