check="Sync Time: 0.0s"
result=`goal node status | grep "$check"`
if [ "$result" = "$check" ]; then
   echo "0"
else
   echo "1"
fi

# curl http://algo-set-service.algorand-mainnet:4160/v1/mainnet-v1.0/block/0 --output x.tmp
# wget  -q -O /dev/stdout http://algo-set-service.algorand-mainnet:4160/v1/mainnet-v1.0/block/20000000 | sha256sum e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
# wget  -q -O /dev/stdout http://relay-fi.a-wallet.net:4160/v1/mainnet-v1.0/block/20000000 | sha256sum e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855