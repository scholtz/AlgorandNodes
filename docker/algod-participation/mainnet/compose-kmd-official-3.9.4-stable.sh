ver=3.9.4
docker build -t scholtz2/algorand-kmd-mainnet:$ver-stable -f compose-kmd-official.dockerfile --build-arg ALGO_VER=$ver context-kmd/
docker push scholtz2/algorand-kmd-mainnet:$ver-stable
docker tag scholtz2/algorand-kmd-mainnet:$ver-stable scholtz2/algorand-participation-mainnet:$ver-stable
docker push scholtz2/algorand-participation-mainnet:$ver-stable

#docker build -t scholtz2/algorand-participation-sandbox:$ver-stable -f compose-participation-sandbox.dockerfile --build-arg ALGO_VER=$ver context-participation-sandbox/
