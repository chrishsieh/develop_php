# develop_php
Docker system for php develop, include online VSCode, PHP developement setting,
Online VSCode(https://github.com/codercom/code-server), 
setting reference from https://github.com/devilbox/docker-php-fpm and https://github.com/theia-ide/theia-apps.

# Quick Start
1. Virtual machine memory requirement 2560MB.
1. Update /runtime folder setting for development.
1. Update .env setting.
1. Run with vagrant ```vagrant up```, others ```docker-compose up -d```.
1. Run test selenium ```docker-compose -f test.yml up -d```.
1. Run portainer ```docker-compose -f portainer.yml up -d```.
1. Run debug with phpmyadmin and mailcatcher ```docker-compose -f debug.yml up -d```.
1. Build coder(need memory 3072MB) ```docker-compose -f coder-gen.yml build``` then remove docker-compose.yml build mask and ```docker-compose build```.
1. http://localhost:8443 for coder(online VSCode), do PHP development build command.
1. http://localhost:8080 for web. http://localhost:8000 for phpmyadmin. http://localhost:1080 for mailcatcher.
1. http://localhost:9000 for portainer.
