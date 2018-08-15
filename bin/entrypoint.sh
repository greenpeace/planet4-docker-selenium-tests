#!/bin/bash
set -e

echo
echo "  * Site:  $P4_PROTO://$P4_DOMAIN"
echo "  * User:  $P4_USER"
echo "  * Pass:  $P4_PASS"
echo

dockerize --template /home/seluser/config.php.tmpl:/home/seluser/config/config.php

if [[ $P4_DOMAIN =~ test$ ]]
then
	echo "Adding host $P4_DOMAIN to hostfile"
	add_test_domain_to_hosts.sh
fi

# Upstream container CMD will be /usr/bin/entry.sh
if [[ "$1" = "/usr/bin/entry.sh" ]]
then
	exec /usr/bin/entry.sh
else
  # Execute the custom CMD
	exec /bin/bash -c "$*"
fi
