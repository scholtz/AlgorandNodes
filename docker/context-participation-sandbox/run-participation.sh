if [ ! -f "/app/data/genesis.json" ] 
then
    cp /app/net/Node/* /app/data -rf
    cp /app/sandbox/config.json /app/data/config.json
fi

echo "goal kmd start"
goal kmd start || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "goal kmd start failed";
	exit 1;
fi
echo "goal node start"
goal node start || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "goal node start failed";
	exit 1;
fi

data=curl http://localhost:4001/v2/transactions/params -H "X-Algo-API-Token:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
gid=`echo $data | jq '."genesis-id"'`
ghash=`echo $data | jq '."genesis-hash"'`

algodtoken=$(cat /app/data/algod.token)
sed -i s~aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~$algodtoken~g /kmd/appsettings.json
sed -i s~mainnet-v1.0~$gid~g /kmd/appsettings.json
sed -i s~wGHE2Pwdvd7S12BL5FaOP20EGYesN73ktiC1qzkkit8=~$ghash~g /kmd/appsettings.json
cd /kmd/ && nohup dotnet AlgorandKMDServer.dll &

while true; do date; goal node status; sleep 600;done