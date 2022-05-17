check="Sync Time: 0.0s"
result=`goal node status | grep "$check"`
if [ "$result" = "$check" ]; then
   echo "0"
else
   echo "1"
fi

# curl http://algo-set-service.algorand-mainnet:4160/v1/mainnet-v1.0/block/0 --output x.tmp
# wget  -q -O /dev/stdout http://algo-set-service.algorand-mainnet:4160/v1/mainnet-v1.0/block/0 | sha256sum dd42911a7326348672638c5571d7cc4d6a62284b6d9c4b1307389a545f52a451
# wget  -q -O /dev/stdout http://relay-fi.a-wallet.net:4160/v1/mainnet-v1.0/block/0 | sha256sum dd42911a7326348672638c5571d7cc4d6a62284b6d9c4b1307389a545f52a451