outputVer=v1.6.0-beta
tag=v1.6.0
docker build -t scholtz2/aramid-conduit:$outputVer -f compose-indexer-fix.dockerfile --build-arg TAG=$tag /home/scholtz/Conduit/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi
docker push scholtz2/aramid-conduit:$outputVer