ver=v3.0.1-beta
docker build -t scholtz2/algorand-relay-mainnet:$ver -f compose-relaynode.dockerfile --progress=plain --build-arg ALGO_VER=$ver context/
docker push scholtz2/algorand-relay-mainnet:$ver