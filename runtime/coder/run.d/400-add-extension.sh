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
    # Setup PHP Debug Extension
    add_extension "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/felixfbecker/vsextensions/php-debug/1.13.0/vspackage" "${DEBUG_LEVEL}"
    # Setup React Extension
    add_extension "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/vsmobile/vsextensions/vscode-react-native/0.9.1/vspackage" "${DEBUG_LEVEL}"
    # Setup GitLen Extension
    add_extension "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/eamodio/vsextensions/gitlens/9.6.3/vspackage" "${DEBUG_LEVEL}"

    touch add_extension.done
fi
