cd "$(dirname "$0")"
outputVer=v3.11.1-stable
tag=v3.11.1

error_code=0
cp context-indexer/* /home/cicd/Indexer/context -Rf

docker build -t scholtz2/aramid-indexer:$outputVer -f compose-indexer-fix.dockerfile --build-arg TAG=$tag /home/cicd/Indexer || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi

echo scholtz2/aramid-indexer:$outputVer
docker push scholtz2/aramid-indexer:$outputVer || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push image";
	exit 1;
fi