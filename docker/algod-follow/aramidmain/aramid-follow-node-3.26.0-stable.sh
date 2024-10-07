ver=v3.26.0-stable
outputVer=v3.26.0-stable
docker build -t scholtz2/aramid-algo-follow-node:$outputVer -f compose-aramid.dockerfile --build-arg ALGO_VER=$ver context-aramid/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi
docker push scholtz2/aramid-algo-follow-node:$outputVer || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push image";
	exit 1;
fi