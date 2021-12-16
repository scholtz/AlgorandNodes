kubectl delete statefulset relaynode-ss -n algorand  --cascade=orphan
kubectl apply -f statefulset.yaml