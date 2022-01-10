check="Sync Time: 0.0s"
result=`goal node status | grep "$check"`
if [ "$result" = "$check" ]; then
   echo "0"
else
   echo "1"
fi

# curl http://algo-set-service.algorand-mainnet:4160/v1/mainnet-v1.0/block/0 --output x.tmp