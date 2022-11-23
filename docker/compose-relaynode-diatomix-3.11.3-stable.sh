ver=3.11.3
branch=v3.11.3-stable
docker build -t scholtz2/diatomix-relay-mainnet:$ver-stable -f compose-relaynode-diatomix.dockerfile --progress=plain --build-arg ALGO_VER=$ver --build-arg ALGO_BRANCH=$branch  --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" context/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build";
	exit 1;
fi
docker push scholtz2/diatomix-relay-mainnet:$ver-stable || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push";
	exit 1;
fi