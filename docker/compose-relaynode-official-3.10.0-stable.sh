ver=3.10.0
docker build -t scholtz2/algorand-relay-mainnet:$ver-stable -f compose-relaynode-official.dockerfile --progress=plain --build-arg ALGO_VER=$ver context/
docker push scholtz2/algorand-relay-mainnet:$ver-stable