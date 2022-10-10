if [ ! -f "/app/data/genesis.json" ] 
then
    cp /app/net/Node/* /app/data -rf
    cp /app/sandbox/config.json /app/data/config.json
fi

echo "goal kmd start"
goal kmd start || error_code=$?
if [ "$error_code" -ne "0" ]; then
    echo "goal kmd start failed";
	exit 1;
fi
echo "goal node start"
goal node start || error_code=$?
if [ "$error_code" -ne "0" ]; then
    echo "goal node start failed";
	exit 1;
fi

algodtoken=$(cat /app/data/algod.token)
sed -i s~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~$algodtoken~g /kmd/appsettings.json
cd /kmd/ && nohup dotnet AlgorandKMDServer.dll &

while true; do date; goal node status; sleep 600;done