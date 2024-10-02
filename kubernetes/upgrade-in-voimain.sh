cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/voimain-relay/in-1-voimain-relay
echo "kubernetes/algod-relay/voimain-relay/in-1-voimain-relay"
echo "kubectl apply -f h1-deployment.yaml"
date
kubectl apply -f h1-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-1 -n algo-relay-voimain -w
