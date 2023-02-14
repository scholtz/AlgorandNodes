kubectl delete configmap algorand-indexer-conf -n algorand-indexer-testnet
kubectl create configmap algorand-indexer-conf --from-file=conf -n algorand-indexer-testnet
