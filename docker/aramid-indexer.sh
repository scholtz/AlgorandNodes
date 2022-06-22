ver=v3.7.2-stable
outputVer=v2.11.1-beta
docker build -t scholtz2/aramid-indexer:$outputVer -f compose-indexer.dockerfile --progress=plain context-indexer/ || error_code=$?
if [ $error_code -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi
docker push scholtz2/aramid-indexer:$outputVer