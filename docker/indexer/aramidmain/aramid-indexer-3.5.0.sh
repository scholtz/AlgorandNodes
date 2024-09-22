outputVer=v3.5.0-stable
tag=v3.5.0

cp context-indexer/* /home/scholtz/indexer-custom-build/context -Rf

docker build -t scholtz2/aramid-indexer:$outputVer -f compose-indexer-fix.dockerfile --build-arg TAG=$tag /home/scholtz/indexer-custom-build || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi
docker push scholtz2/aramid-indexer:$outputVer