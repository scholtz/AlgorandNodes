ver=3.2.3
docker build -t scholtz2/algorand-relay-testnet:$ver-stable -f compose-relaynode-official-testnet.yaml --progress=plain --build-arg ALGO_VER=$ver context-testnet/
docker push scholtz2/algorand-relay-testnet:$ver-stable