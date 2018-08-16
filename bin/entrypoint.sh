#!/bin/bash
set -e

# Upstream container CMD will be /usr/bin/entry.sh
if [[ "$1" = "/usr/bin/entry.sh" ]]
then
	echo
	echo "  * Site:  $P4_PROTO://$P4_DOMAIN"
	echo "  * User:  $P4_USER"
	echo "  * Pass:  $P4_PASS"
	echo

	if [[ $P4_DOMAIN =~ test$ ]]
	then
		echo "Adding host $P4_DOMAIN to hostfile"
		add_test_domain_to_hosts.sh
	fi

	dockerize --template /home/seluser/config/config.php.tmpl:/home/seluser/config/config.php
	exec /usr/bin/entry.sh
else
  # Execute the custom CMD
	exec /bin/bash -c "$*"
fi
