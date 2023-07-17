ver=v1.1.13
docker build -t scholtz2/goracle-testnet:$ver-stable -f goracle-testnet.dockerfile --progress=plain --build-arg GORACLE_VER=$ver context/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "build failed";
	exit 1;
fi

docker push scholtz2/goracle-testnet:$ver-stable  || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "git push failed";
	exit 1;
fi
echo "scholtz2/goracle-testnet:$ver-stable"