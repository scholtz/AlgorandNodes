#apt update && apt dist-upgrade -y 


cp mainnet/* data/ -R
goal node start 
diagcfg telemetry enable
diagcfg metric enable
#./goal node catchup $catchup -d /root/node/datafastcatchup
#./goal node status -d ~/node/datafastcatchup -w 1000


while true; do echo `date`; goal node status; sleep 600;done
