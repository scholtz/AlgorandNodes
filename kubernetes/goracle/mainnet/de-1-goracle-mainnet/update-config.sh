kubectl delete configmap --ignore-not-found=true goracle-mainnet-config -n goracle-mainnet
kubectl -n goracle-mainnet create configmap goracle-mainnet-config --from-file=config
kubectl apply -f g1-deployment.yaml
kubectl rollout restart deployment goracle-mainnet-1 -n goracle-mainnet
kubectl rollout status deployment goracle-mainnet-1 -n goracle-mainnet
