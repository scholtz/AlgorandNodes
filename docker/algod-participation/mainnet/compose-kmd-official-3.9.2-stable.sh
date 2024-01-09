ver=3.9.2
docker build -t scholtz2/algorand-kmd-mainnet:$ver-stable -f compose-kmd-official.dockerfile --build-arg ALGO_VER=$ver context-kmd/
docker push scholtz2/algorand-kmd-mainnet:$ver-stable