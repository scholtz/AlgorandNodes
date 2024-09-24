#!/bin/bash

cp --update=none config.json data/config.json
cp -f genesis/aramidmain/genesis.json data/genesis.json
cp -f consensus.json data/consensus.json

goal node start  || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "goal node start failed";
	exit 1;
fi

sleep 1

myNodeRound=`goal node lastround`
blockchainRoundMath=$(curl -s https://algod.aramidmain.a-wallet.net/v2/status | jq -r '.["last-round"]' )" - 1000"
blockchainRound=$(echo $blockchainRoundMath | bc)

echo "catchup check: my round is $myNodeRound, blockchain round is $blockchainRound"
if [ "$myNodeRound" -lt "$blockchainRound" ]; then
	echo "Executing catchup script because my current round is $myNodeRound"
	catchup=$(curl -s https://algod.aramidmain.a-wallet.net/v2/status | jq -r '.["last-catchpoint"]')
	sleep 10s
	echo "going to run 'goal node catchup $catchup'"
	goal node catchup $catchup || error_code=$?
	if [ $error_code_int -ne 0 ]; then
		echo "failed to start catchup";
		exit 1;
	fi
fi


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
chmod 0700 /app/data/kmd-v0.5
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