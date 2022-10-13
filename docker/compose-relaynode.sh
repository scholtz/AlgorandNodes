ver=v2.10.1-stable
docker build -t scholtz2/algorand-relay-node-mainnet:$ver -f compose-relaynode.dockerfile --progress=plain --build-arg ALGO_VER=$ver context/
docker push scholtz2/algorand-relay-node-mainnet:$ver