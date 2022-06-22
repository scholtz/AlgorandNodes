#apt update && apt dist-upgrade -y 
cp -n config.json data/config.json
cp -n genesis/aramidmain/genesis.json data/genesis.json
cp -n consensus.json data/consensus.json

goal node start 
goal kmd start 
#diagcfg telemetry enable
#diagcfg metric enable
#./goal node catchup $catchup -d /root/node/datafastcatchup
#./goal node status -d ~/node/datafastcatchup -w 1000


while true; do echo `date`; goal node status; sleep 600;done