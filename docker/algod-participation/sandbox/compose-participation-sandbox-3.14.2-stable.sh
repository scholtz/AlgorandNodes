ver=3.14.2
docker build -t scholtz2/algorand-participation-sandbox:$ver-stable -f compose-participation-sandbox.dockerfile --progress=plain --build-arg ALGO_VER=$ver context-participation-sandbox/ || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to build";
	exit 1;
fi
docker push scholtz2/algorand-participation-sandbox:$ver-stable || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "failed to push";
	exit 1;
fi
