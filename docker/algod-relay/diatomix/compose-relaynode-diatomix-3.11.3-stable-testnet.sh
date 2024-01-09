diatomixVer=3.11.3-stable
algoVer=3.11.3
docker build -t scholtz2/diatomix-relay-testnet:$diatomixVer -f compose-relaynode-diatomix-testnet.dockerfile --build-arg ALGO_TAG=$algoVer --build-arg DIATOMIX_TAG=$diatomixVer context-testnet/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build";
	exit 1;
fi

docker push scholtz2/diatomix-relay-testnet:$diatomixVer || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push";
	exit 1;
fi