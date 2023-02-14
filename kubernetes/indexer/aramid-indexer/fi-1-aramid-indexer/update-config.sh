kubectl delete configmap aramidmain-indexer-conf -n aramidmain-indexer-testnet
kubectl create configmap aramidmain-indexer-conf --from-file=conf -n aramidmain-indexer-testnet
