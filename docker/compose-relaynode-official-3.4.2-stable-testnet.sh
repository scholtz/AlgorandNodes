ver=3.4.2
docker build -t scholtz2/algorand-relay-testnet:$ver-stable -f compose-relaynode-official-testnet.dockerfile --progress=plain --build-arg ALGO_VER=$ver context-testnet/
docker push scholtz2/algorand-relay-testnet:$ver-stable