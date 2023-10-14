#!/bin/bash

if ! test -f "/app/data/genesis.json"; then
    echo "initiating new node. genesis.json was not found";
	cp /app/voitest/* /app/data/ -R

	echo "diagcfg telemetry enable"
	diagcfg telemetry enable
	host=`hostname`.voi
	echo "diagcfg telemetry name -n $host"
	diagcfg telemetry name -n $host
fi

echo "goal node start"
goal node start  || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to start node";
    exit 1;
fi

myNodeRound=`goal node lastround`
blockchainRoundMath=$(curl -s https://testnet-api.voi.nodly.io/v2/status | jq -r '.["last-round"]' )" - 1000"
blockchainRound=$(echo $blockchainRoundMath | bc)

echo "catchup check: my round is $myNodeRound, blockchain round is $blockchainRound"
if [ "$myNodeRound" -lt "$blockchainRound" ]; then
	echo "Executing catchup script because my current round is $myNodeRound"
	catchup=$(curl -s https://testnet-api.voi.nodly.io/v2/status | jq -r '.["last-catchpoint"]')
	sleep 10s
	echo "going to run 'goal node catchup $catchup'"
	goal node catchup $catchup || error_code=$?
	if [ $error_code_int -ne 0 ]; then
		echo "failed to start catchup";
		exit 1;
	fi
fi

echo "initializing part keys proxy"
algodtoken=$(cat /app/data/algod.token)
sed -i s~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~$algodtoken~g /kmd/appsettings.json
cd /kmd/ && nohup dotnet AlgorandKMDServer.dll &

echo "initialized"
while true; do date; goal node status; sleep 600;done