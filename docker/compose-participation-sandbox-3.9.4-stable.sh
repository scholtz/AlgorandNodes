ver=3.9.4
docker build -t scholtz2/algorand-participation-sandbox:$ver-stable -f compose-participation-sandbox.dockerfile --progress=plain --build-arg ALGO_VER=$ver context-participation-sandbox/ || error_code=$?
if [ "$error_code" -ne "0" ]; then
    echo "failed to build";
	exit 1;
fi
docker push scholtz2/algorand-participation-sandbox:$ver-stable || error_code=$?
if [ "$error_code" -ne "0" ]; then
    echo "failed to push";
	exit 1;
fi
