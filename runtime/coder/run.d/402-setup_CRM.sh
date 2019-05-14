#!/usr/bin/env bash

set -e
set -u
set -o pipefail


if ! [ -f git_clone.done ]; then
    run "usermod -a -G www-data coder" "${DEBUG_LEVEL}"
    run "mkdir -p ./.vscode" "${DEBUG_LEVEL}"
    run "cp /setting/*.json ./.vscode/" "${DEBUG_LEVEL}"
    run "cp /setting/*.sh ." "${DEBUG_LEVEL}"
    run "chmod +x ./*.sh" "${DEBUG_LEVEL}"
    run "chown -R coder:coder ." "${DEBUG_LEVEL}"
    git_clone "https://github.com/ChurchCRM/CRM.git" "CRM" "${DEBUG_LEVEL}"
    run "chown -R coder:coder CRM" "${DEBUG_LEVEL}"
    touch git_clone.done
fi

run "rm -rf /var/www/html" "${DEBUG_LEVEL}"
run "ln -s /var/www/CRM/src /var/www/html" "${DEBUG_LEVEL}"
