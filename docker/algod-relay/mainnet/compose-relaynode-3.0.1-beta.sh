ver=v3.0.1-beta
docker build -t scholtz2/algorand-relay-mainnet:$ver -f compose-relaynode.dockerfile --build-arg ALGO_VER=$ver context/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build";
	exit 1;
fi
docker push scholtz2/algorand-relay-mainnet:$ver