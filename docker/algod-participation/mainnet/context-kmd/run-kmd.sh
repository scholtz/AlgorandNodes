#!/bin/bash

algodtoken=$(cat /app/data/algod.token)
sed -i s~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~$algodtoken~g /kmd/appsettings.json
cd /kmd/ && nohup dotnet AlgorandKMDServer.dll &

if ! test -f "/app/data/genesis.json"; then
	cp /app/mainnet/* /app/data/ -R
fi

goal node start  || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to start node";
    exit 1;
fi
round=`goal node lastround`
if [ "10000000" -gt "$round" ]; then
	echo "Executing catchup script because current round is $round"
	catchup=`curl -s https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/mainnet/latest.catchpoint`
	echo "going to run 'goal node catchup $catchup'"
	goal node catchup $catchup || error_code=$?
	if [ $error_code_int -ne 0 ]; then
		echo "failed to start catchup";
		exit 1;
	fi
fi

while true; do date; goal node status; sleep 600;done