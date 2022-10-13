ver=v3.7.2-stable
outputVer=v3.7.2-beta
docker build -t scholtz2/aramid-algo-node:$outputVer -f compose-relaynode.dockerfile --progress=plain --build-arg ALGO_VER=$ver context-aramid/ || error_code=$?
if [ $error_code -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi
docker push scholtz2/aramid-algo-node:$outputVer