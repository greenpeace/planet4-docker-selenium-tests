#!/bin/bash
set -eu

domain=${1:-$P4_DOMAIN}
ip=${2:-$(ip route | awk 'NR==1 {print $3}')}

echo "$ip $domain" | sudo tee -a /etc/hosts
