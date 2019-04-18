#!/usr/bin/env bash

set -e
set -u
set -o pipefail


run "mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini" "${DEBUG_LEVEL}"
run "cp /run.d/uploads.conf ${PHP_INI_DIR}/conf.d/" "${DEBUG_LEVEL}"
