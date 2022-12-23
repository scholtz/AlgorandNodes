ver=night-build

docker build -t scholtz2/algorand-relay-mainnet:$ver -f compose-relaynode.dockerfile --progress=plain --build-arg CACHEBUST=$(date +%s) --build-arg ALGO_VER=master context/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build";
	exit 1;
fi
docker push scholtz2/algorand-relay-mainnet:$ver || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push";
	exit 1;
fi

# docker build -t scholtz2/algorand-relay-testnet:$ver -f compose-relaynode-night-build-testnet.dockerfile --progress=plain  context/ || error_code=$?
# error_code_int=$(($error_code + 0))
# if [ $error_code_int -ne 0 ]; then
#     echo "failed to build";
# 	exit 1;
# fi
# docker push scholtz2/algorand-relay-testnet:$ver || error_code=$?
# error_code_int=$(($error_code + 0))
# if [ $error_code_int -ne 0 ]; then
#     echo "failed to push";
# 	exit 1;
# fi


docker build -t scholtz2/algorand-participation-sandbox:$ver -f compose-participation-sandbox-night-build.dockerfile --progress=plain context-participation-sandbox/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build";
	exit 1;
fi
docker push scholtz2/algorand-participation-sandbox:$ver || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push";
	exit 1;
fi
