#!/bin/bash

myNodeRound=`goal node lastround`
blockchainRoundMath=$(curl -s https://mainnet-api.4160.nodely.dev/v2/status | jq -r '.["last-round"]' )" - 1000"
blockchainRound=$(echo $blockchainRoundMath | bc)

echo "catchup check: my round is $myNodeRound, blockchain round is $blockchainRound"
if [ "$myNodeRound" -lt "$blockchainRound" ]; then
	echo "Executing catchup script because my current round is $myNodeRound"
	catchup=$(curl -s https://mainnet-api.4160.nodely.dev/v2/status | jq -r '.["last-catchpoint"]')
  if [ -z $catchup ]; then
  echo "catchup from node directly failed. loading from amazon"
  catchup=`curl -s https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/mainnet/latest.catchpoint`
  fi

	sleep 10s

  if [ -z $catchup ]; then
  echo "loading catchup point has failed";
  exit 1;
  fi

	echo "going to run 'goal node catchup $catchup'"
	goal node catchup $catchup || error_code=$?
  error_code_int=$(($error_code + 0))
	if [ $error_code_int -ne 0 ]; then
		echo "failed to start catchup";
		exit 1;
	fi
fi