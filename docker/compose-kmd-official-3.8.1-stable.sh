ver=3.8.1
docker build -t scholtz2/algorand-kmd-mainnet:$ver-stable -f compose-kmd-official.yaml --progress=plain --build-arg ALGO_VER=$ver context-kmd/
docker push scholtz2/algorand-kmd-mainnet:$ver-stable