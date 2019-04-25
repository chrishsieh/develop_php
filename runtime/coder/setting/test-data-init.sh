set_db(){
    cd CRM

    # Import Docker Secrets
    local MYSQL_USER=churchcrm
    local MYSQL_USER_PWD=changeme
    local MYSQL_USER_DB=churchcrm_test
    local MYSQL_ROOT_PWD=changeme

    sudo chown coder:www-data src/Include/Config.php
    sed -i "s/sSERVERNAME = \(.*\);/sSERVERNAME = '$MYSQL_DB_HOST';/g" /var/www/CRM/travis-ci/Config.php
    sed -i "s/sUSER = \(.*\);/sUSER = '$MYSQL_USER';/g" /var/www/CRM/travis-ci/Config.php
    sed -i "s/sPASSWORD = \(.*\);/sPASSWORD = '$MYSQL_USER_PWD';/g" /var/www/CRM/travis-ci/Config.php
    sed -i "s/sRootPath = \(.*\);/sRootPath = '';/g" /var/www/CRM/travis-ci/Config.php
    sed -i "s|'http://\(.*\)/';|'http://web:80/';|g" /var/www/CRM/travis-ci/Config.php

    sed -i "s/sSERVERNAME = \(.*\);/sSERVERNAME = '$MYSQL_DB_HOST';/g" /var/www/CRM/tests/bootstrap.php
    sed -i "s/sRootPath = \(.*\);/sRootPath = '';/g" /var/www/CRM/tests/bootstrap.php

    sed -i "s|vagrant|var/www/CRM|g" /var/www/CRM/scripts/tests-run.sh
    sed -i 's|{"goutte" : "~","selenium2":"~"}|{"selenium2" : { "wd_host": "http://selenium:4444/wd/hub"}}|g' /var/www/CRM/scripts/tests-run.sh

    sed -i "s|http://\(.*\)|http://web:80|g" /var/www/CRM/tests/behat/behat.yml
    sed -i "s|Chrome|chrome|g" /var/www/CRM/tests/behat/behat.yml
    sed -i "s|platform: Windows 10|browser: chrome|g" /var/www/CRM/tests/behat/behat.yml
    sed -i "s|version: 67.0|marionette: true\r          chrome:\r            switches: ['--disable-gpu', '--window-size=1280,1600']|g" /var/www/CRM/tests/behat/behat.yml

    echo "Database: mysql started"

    mysql -uroot -p"$MYSQL_ROOT_PWD" -h"$MYSQL_DB_HOST" -e "DROP DATABASE IF EXISTS churchcrm_test;"
    mysql -uroot -p"$MYSQL_ROOT_PWD" -h"$MYSQL_DB_HOST" -e "DROP USER '$MYSQL_USER';"
    echo "Database: cleared"

    mysql -uroot -p"$MYSQL_ROOT_PWD" -h"$MYSQL_DB_HOST" -e "CREATE DATABASE churchcrm_test CHARACTER SET utf8;"
    echo "Database: created"

    mysql -uroot -p"$MYSQL_ROOT_PWD" -h"$MYSQL_DB_HOST" -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PWD';"
    mysql -uroot -p"$MYSQL_ROOT_PWD" -h"$MYSQL_DB_HOST" -e "GRANT ALL PRIVILEGES ON churchcrm_test.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;"
    mysql -uroot -p"$MYSQL_ROOT_PWD" -h"$MYSQL_DB_HOST" -e "FLUSH PRIVILEGES;"
    echo "Database: user created with needed PRIVILEGES"

    echo "=========================================================="
    echo "===============   db script import       ================="
    echo "=========================================================="
    mysql churchcrm_test < /var/www/CRM/src/mysql/install/Install.sql -uroot -p"$MYSQL_ROOT_PWD" -h"$MYSQL_DB_HOST";
    mysql churchcrm_test < /var/www/CRM/src/mysql/upgrade/update_config.sql -uroot -p"$MYSQL_ROOT_PWD" -h"$MYSQL_DB_HOST";
    echo "===============   db demo script import  ================"
    mysql churchcrm_test < /var/www/CRM/demo/ChurchCRM-Database.sql -uroot -p"$MYSQL_ROOT_PWD" -h"$MYSQL_DB_HOST";
    echo "===============   db script import  Done  ================"
    cp /var/www/CRM/travis-ci/Config.php /var/www/CRM/src/Include/Config.php
    npm run tests-install
    cd ..
}

set_db;
