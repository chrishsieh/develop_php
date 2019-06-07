# develop_php
Docker system for php develop, PHP developement setting,
setting reference from https://github.com/devilbox/docker-php-fpm.

# Quick Start
1. Update /runtime folder setting for development.
1. Update .env setting. If want trace PHP need set DEV_EN_XDEBUG=true
1. Install https://hub.docker.com/editions/community/docker-ce-desktop-windows
1. Install VSCode version >= 1.35.0
1. VSCode install https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack
1. ```F1``` Run Remote-Containers: Reopen Folder in Container.
1. Wait /var/www git_clone.done file.
1. Run /var/www/quick-install.sh to build ChurchCRM
1. http://localhost:8080 for web. MySQL Database Server Name: db, others setting reference .env setting.
1. Run test selenium ```docker-compose -f test.yml up -d```.
1. Run debug with phpmyadmin and mailcatcher ```docker-compose -f debug.yml up -d```.
1. http://localhost:8000 for phpmyadmin. http://localhost:1080 for mailcatcher.

