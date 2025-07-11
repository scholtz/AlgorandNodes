ver=4.1.1
docker build -t scholtz2/algorand-relay-voimain:$ver-stable -f compose-relaynode-official-voimain.dockerfile --build-arg ALGO_VER=$ver context-voimain/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build";
	exit 1;
fi

docker push scholtz2/algorand-relay-voimain:$ver-stable || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push";
	exit 1;
fi