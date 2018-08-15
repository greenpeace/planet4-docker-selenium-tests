#!/usr/bin/env bash
set -eu

network=tests_proxy
endpoint=http://www.planet4.test
string=greenpeace

# 1 seconds * 120 == 2+ minutes
interval=1
loop=120

# Number of consecutive successes to qualify as 'up'
threshold=3
success=0

echo "Waiting for services to start ..."
until [[ $success -ge $threshold ]]
do
  # Curl to container and expect 'greenpeace' in the response
  if docker run --network $network --rm appropriate/curl -s -k "$endpoint" | grep -s "$string" > /dev/null
  then
    success=$((success+1))
    echo -en "\xE2\x9C\x94"
  else
    echo -n "."
    success=0
  fi

  loop=$((loop-1))
  if [[ $loop -lt 1 ]]
  then
    >&2 echo "[ERROR] Timeout waiting for docker-compose to start"
    >&2 docker-compose -p test logs
    exit 1
  fi

  [[ $success -ge $threshold ]] || sleep $interval

done
echo
