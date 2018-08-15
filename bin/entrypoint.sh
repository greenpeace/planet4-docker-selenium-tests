#!/bin/bash
set -e

cd /var/www/tests && git pull origin master
cp -f /var/www/config.php.example /var/www/tests/config/config.php.example
sed -i "s|planet4_domain|$PLANET4_URL|" /var/www/tests/config/config.php.example
sed -i "s|:4444|:24444|" /var/www/tests/config/config.php.example
sed -i "s|test_user|$PLANET4_USER|" /var/www/tests/config/config.php.example
sed -i "s|u3vsREsvjwo|$PLANET4_USER_PASS|" /var/www/tests/config/config.php.example
cp -f /var/www/tests/config/config.php.example /var/www/tests/config/config.php

/usr/bin/entry.sh