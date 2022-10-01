#apt update && apt dist-upgrade -y 

#diagcfg telemetry enable
#diagcfg metric enable

if test -f "/app/data/genesis.json"; then

	goal node start

#./goal node status -d ~/node/datafastcatchup -w 1000
else

	cp mainnet/* data/ -R

	goal node start
	catchup=`curl https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/mainnet/latest.catchpoint`
	goal node catchup $catchup

fi

while true; do date; goal node status; sleep 600;done