#!/usr/bin/env bash

set -e
set -u
set -o pipefail

if ! [ -f add_extension.done ]; then
###
### Add extensions
###
# Setup PHP IntelliSense Extension
add_extension "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/felixfbecker/vsextensions/php-intellisense/2.3.10/vspackage" "${DEBUG_LEVEL}"
# Setup QuickTask Extension
add_extension "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/lkytal/vsextensions/quicktask/3.5.4/vspackage" "${DEBUG_LEVEL}"
# Setup React Extension
add_extension "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/vsmobile/vsextensions/vscode-react-native/0.9.1/vspackage" "${DEBUG_LEVEL}"

touch add_extension.done
fi
