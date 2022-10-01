ver=3.9.4
docker build -t scholtz2/algorand-participation-sandbox:$ver-stable -f compose-participation-sandbox.yaml --progress=plain --build-arg ALGO_VER=$ver context-participation-sandbox/
