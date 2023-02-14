kubectl delete configmap aramidmain-indexer-conf -n aramid-indexer-mainnet
kubectl create configmap aramidmain-indexer-conf --from-file=conf -n aramid-indexer-mainnet
kubectl apply -f deployment.yaml
kubectl rollout restart deployment/aramid-indexer-mainnet -n aramid-indexer-mainnet