#!/usr/bin/env bash

set -e
set -u
set -o pipefail


if ! [ -f git_clone.done ]; then
    run "usermod -a -G www-data coder" "${DEBUG_LEVEL}"
    run "mkdir -p ./.vscode" "${DEBUG_LEVEL}"
    run "cp /run.d/*.json ./.vscode/" "${DEBUG_LEVEL}"
    git_clone "https://github.com/ChurchCRM/CRM.git" "CRM" "${DEBUG_LEVEL}"

    cd CRM
    run "cp BuildConfig.json.example BuildConfig.json" "${DEBUG_LEVEL}"
    run "chmod +x ./travis-ci/*.sh" "${DEBUG_LEVEL}"
    run "chmod +x ./scripts/*.sh" "${DEBUG_LEVEL}"
    run "find . -type d -exec chmod -R 775 {} \;" "${DEBUG_LEVEL}"
    run "find . -type f -exec chmod -R 664 {} \;" "${DEBUG_LEVEL}"

    cd ..
    run "chown -R coder:www-data CRM" "${DEBUG_LEVEL}"
    touch git_clone.done
fi

run "rm -rf /var/www/html" "${DEBUG_LEVEL}"
run "ln -s /var/www/CRM/src /var/www/html" "${DEBUG_LEVEL}"
