ver=3.11.2
docker build -t scholtz2/algorand-relay-testnet:$ver-stable -f compose-relaynode-official-testnet.dockerfile --build-arg ALGO_VER=$ver context-testnet/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build";
	exit 1;
fi

docker push scholtz2/algorand-relay-testnet:$ver-stable || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push";
	exit 1;
fi