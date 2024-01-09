ver=3.0.1
docker build -t scholtz2/algorand-relay-testnet:$ver-stable -f compose-relaynode-official-testnet.dockerfile --build-arg ALGO_VER=$ver context-testnet/
docker push scholtz2/algorand-relay-testnet:$ver-stable