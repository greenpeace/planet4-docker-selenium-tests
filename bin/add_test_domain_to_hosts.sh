#!/bin/bash

HOST_IP=$(ip route | awk 'NR==1 {print $3}')
echo $HOST_IP
sudo bash -c "echo '$HOST_IP $PLANET4_URL' >> /etc/hosts"