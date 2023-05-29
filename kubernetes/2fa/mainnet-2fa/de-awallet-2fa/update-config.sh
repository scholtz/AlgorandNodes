kubectl apply -f de-1-deployment.yaml -n algo2fa
kubectl delete configmap algo2fa-mainnet-conf -n algo2fa
kubectl create configmap algo2fa-mainnet-conf --from-file=conf -n algo2fa
kubectl rollout restart deployment/algo2fa-web-mainnet-deployment -n algo2fa
