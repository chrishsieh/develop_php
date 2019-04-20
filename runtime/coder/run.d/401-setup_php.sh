#!/usr/bin/env bash

set -e
set -u
set -o pipefail


run "cp ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini" "${DEBUG_LEVEL}"
run "cp /run.d/uploads.conf ${PHP_INI_DIR}/conf.d/uploads.ini" "${DEBUG_LEVEL}"
run "cp /run.d/xdebug.ini ${PHP_INI_DIR}/conf.d/zz-xdebug.ini" "${DEBUG_LEVEL}"