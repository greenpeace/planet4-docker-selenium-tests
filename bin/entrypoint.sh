#!/bin/bash

cd /var/www/tests && git pull origin master
sed -i "s|planet4_domain|$PLANET4_URL|" /var/www/tests/config/config.php.example
sed -i "s|test_user|$PLANET4_USER|" /var/www/tests/config/config.php.example
sed -i "s|u3vsREsvjwo|$PLANET4_USER_PASS|" /var/www/tests/config/config.php.example
cp -f /var/www/tests/config/config.php.example /var/www/tests/config/config.php

/opt/bin/entry_point.sh