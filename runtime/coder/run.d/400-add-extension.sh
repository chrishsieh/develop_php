#!/usr/bin/env bash

set -e
set -u
set -o pipefail

if ! [ -f add_extension.done ]; then
    ###
    ### Add extensions
    ###
    # Setup PHP IntelliSense Extension
    add_extension "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/felixfbecker/vsextensions/php-intellisense/latest/vspackage" "${DEBUG_LEVEL}"
    # Setup PHP Debug Extension
    add_extension "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/felixfbecker/vsextensions/php-debug/latest/vspackage" "${DEBUG_LEVEL}"
    # Setup React Extension
    add_extension "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/msjsdiag/vsextensions/vscode-react-native/latest/vspackage" "${DEBUG_LEVEL}"
    # Setup GitLen Extension
    add_extension "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/eamodio/vsextensions/gitlens/latest/vspackage" "${DEBUG_LEVEL}"

    touch add_extension.done
fi
