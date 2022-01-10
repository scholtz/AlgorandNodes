check="Sync Time: 0.0s"
result=`goal node status | grep "$check"`
if [ "$result" = "$check" ]; then
   echo "0"
else
   echo "1"
fi

# curl http://algo-set-service.algorand-testnet:4161/v1/testnet-v1.0/block/0 --output x.tmp