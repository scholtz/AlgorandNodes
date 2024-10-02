ver=3.26.0
docker build -t scholtz2/algorand-kmd-mainnet:$ver-stable -f compose-kmd-official.dockerfile --build-arg ALGO_VER=$ver context-kmd/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi
docker push scholtz2/algorand-kmd-mainnet:$ver-stable || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push image";
	exit 1;
fi
docker tag scholtz2/algorand-kmd-mainnet:$ver-stable scholtz2/algorand-participation-mainnet:$ver-stable
docker push scholtz2/algorand-participation-mainnet:$ver-stable

#docker build -t scholtz2/algorand-participation-sandbox:$ver-stable -f compose-participation-sandbox.dockerfile --build-arg ALGO_VER=$ver context-participation-sandbox/
