#!/usr/bin/env bash

set -e
set -u
set -o pipefail


if ! [ -f ../git_clone.done ]; then
git_clone "https://github.com/ChurchCRM/CRM.git" "CRM" "${DEBUG_LEVEL}"
run "mv ./CRM/* ." "${DEBUG_LEVEL}"
run "mv ./CRM/.[!.]* ." "${DEBUG_LEVEL}"
run "rm -rf ./CRM" "${DEBUG_LEVEL}"
run "cp BuildConfig.json.example BuildConfig.json" "${DEBUG_LEVEL}"
run "chmod +x ./travis-ci/*.sh" "${DEBUG_LEVEL}"
run "chmod +x ./scripts/*.sh" "${DEBUG_LEVEL}"
run "chown -R www-data:www-data /home/coder/project/src" "${DEBUG_LEVEL}"
run "mkdir -p ./.vscode" "${DEBUG_LEVEL}"
run "cp /run.d/*.json ./.vscode/" "${DEBUG_LEVEL}"
touch ../git_clone.done
fi

run "rm -rf /var/www/html" "${DEBUG_LEVEL}"
run "ln -s /home/coder/project/src /var/www/html" "${DEBUG_LEVEL}"
