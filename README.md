# develop_php
Docker system for php develop, PHP developement setting,
setting reference from https://github.com/devilbox/docker-php-fpm.

# Quick Start
1. Update /runtime folder setting for development.
1. Update .env setting.
1. Install https://hub.docker.com/editions/community/docker-ce-desktop-windows
1. Install VSCode version >= 1.35.0
1. Run with ```docker-compose up -d```.
1. Run test selenium ```docker-compose -f test.yml up -d```.
1. Run debug with phpmyadmin and mailcatcher ```docker-compose -f debug.yml up -d```.
1. VSCode install https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack
1. ```F1``` Run Remote-Containers: Reopen Folder in Container.
1. Do PHP development build command.
1. http://localhost:8080 for web. http://localhost:8000 for phpmyadmin. http://localhost:1080 for mailcatcher.

