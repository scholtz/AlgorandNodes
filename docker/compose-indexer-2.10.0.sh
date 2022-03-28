ver=2.10.0
echo $ver
echo "docker build -t scholtz2/algorand-indexer:$ver-stable -f compose-indexer-stable.yaml --progress=plain --build-arg INDEXER_VER=$ver context-indexer/"
docker build -t scholtz2/algorand-indexer:$ver-stable -f compose-indexer-stable.yaml --progress=plain --build-arg INDEXER_VER=$ver context-indexer/
docker push scholtz2/algorand-indexer:$ver-stable

echo "scholtz2/algorand-indexer:$ver-stable"