cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/voimain-relay/fi-1-voimain-relay
echo "kubernetes/algod-relay/voimain-relay/fi-1-voimain-relay"
echo "kubectl apply -f s1-k1-fi-deployment.yaml"
date
kubectl apply -f s1-k1-fi-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-1 -n algo-relay-voimain -w

date
echo "kubectl apply -f s2-k1-fi-deployment.yaml"
kubectl apply -f s2-k1-fi-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-2 -n algo-relay-voimain -w
