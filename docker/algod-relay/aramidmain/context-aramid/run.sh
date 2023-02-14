#!/bin/bash

#apt update && apt dist-upgrade -y 
cp -n config.json data/config.json
cp -n genesis/aramidmain/genesis.json data/genesis.json
cp -n consensus.json data/consensus.json

goal node start  || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "goal node start failed";
	exit 1;
fi

sleep 1

max_retry=$((60 + 0))
counter=$((0 + 0))
until /app/health.sh
do
   echo "Trying healthcheck again. Try #$counter/$max_retry"
   sleep 10
   if [ $counter -eq $max_retry ] 
   then 
    echo "Failed!" && exit 1
   fi
   ((counter++))
done

goal kmd start  || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "goal kmd start failed";
	exit 1;
fi
#diagcfg telemetry enable
#diagcfg metric enable
#./goal node catchup $catchup -d /root/node/datafastcatchup
#./goal node status -d ~/node/datafastcatchup -w 1000


while true; do echo `date`; goal node status; sleep 600;done