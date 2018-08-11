#!/usr/bin/env bash
set -eu

# 2 seconds * 150 == 5+ minutes
interval=2
loop=150

# Number of consecutive successes to qualify as 'up'
threshold=2
success=0
until [[ $success -ge $threshold ]]
do
  # Curl to container and expect 'greenpeace' in the response
  if docker run --network tests_test --rm appropriate/curl -s -k "https://www.planet4.test" | grep -i "greenpeace" > /dev/null
  then
    success=$((success+1))
    echo "Success: $success/$threshold"
  else
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
