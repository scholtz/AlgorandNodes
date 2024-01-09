outputVer=v2.14.2-beta
docker build -t scholtz2/aramid-indexer:$outputVer -f compose-indexer.dockerfile context-indexer/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi
docker push scholtz2/aramid-indexer:$outputVer