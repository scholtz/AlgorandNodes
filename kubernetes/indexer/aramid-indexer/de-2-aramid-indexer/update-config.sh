#kubectl delete configmap aramidmain-conduit-indexer2-conf -n aramid-indexer2-mainnet
#kubectl create configmap aramidmain-conduit-indexer2-conf --from-file=conduit -n aramid-indexer2-mainnet
kubectl apply -f g1-deployment.yaml
kubectl rollout restart deployment/h31-conduit-aramid-indexer2-mainnet-deployment -n aramid-indexer2-mainnet
kubectl rollout restart deployment/h31-aramid-indexer2-mainnet -n aramid-indexer2-mainnet
#kubectl rollout restart deployment/h31-db-aramid-indexer2-mainnet-deployment -n aramid-indexer2-mainnet
