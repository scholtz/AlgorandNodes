ver=master
outputVer=master
docker build -t scholtz2/aramid-explorer:$outputVer -f compose-aramid-explorer.dockerfile  --build-arg CACHEBUST=$(date +%s) --progress=plain context-dappflow/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi
#docker push scholtz2/aramid-explorer:$outputVer || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi