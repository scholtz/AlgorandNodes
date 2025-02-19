ver=4.0.2-stable
outputVer=4.0.2-stable
docker build -t scholtz2/voimain-follow-node:$outputVer -f compose-voimain.dockerfile --build-arg ALGO_VER=$ver context-voimain/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi
docker push scholtz2/voimain-follow-node:$outputVer || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push image";
	exit 1;
fi