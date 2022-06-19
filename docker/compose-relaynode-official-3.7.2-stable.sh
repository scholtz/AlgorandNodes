ver=3.7.2
docker build -t scholtz2/algorand-relay-mainnet:$ver-stable -f compose-relaynode-official.yaml --progress=plain --build-arg ALGO_VER=$ver context/
docker push scholtz2/algorand-relay-mainnet:$ver-stable