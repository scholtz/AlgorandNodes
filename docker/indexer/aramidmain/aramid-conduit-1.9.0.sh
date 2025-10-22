outputVer=v1.9.0-stable
tag=1.9.0
docker build -t scholtz2/aramid-conduit:$outputVer -f compose-conduit-fix.dockerfile --build-arg TAG=$tag /home/cicd/Conduit || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build image";
	exit 1;
fi
echo scholtz2/aramid-conduit:$outputVer
docker push scholtz2/aramid-conduit:$outputVer