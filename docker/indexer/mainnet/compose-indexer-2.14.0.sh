ver=2.14.0
echo $ver
echo "docker build -t scholtz2/algorand-indexer:$ver-stable -f compose-indexer-stable.dockerfile --build-arg INDEXER_VER=$ver context-indexer/"
docker build -t scholtz2/algorand-indexer:$ver-stable -f compose-indexer-stable.dockerfile --build-arg INDEXER_VER=$ver context-indexer/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi
docker push scholtz2/algorand-indexer:$ver-stable || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push image";
	exit 1;
fi
echo "scholtz2/algorand-indexer:$ver-stable"