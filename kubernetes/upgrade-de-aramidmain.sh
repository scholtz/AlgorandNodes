cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/aramid-relay/de-1-aramid-relay
echo "kubectl apply -f h1-deployment.yaml"
date
kubectl apply -f h1-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-1 -n aramid-relay-mainnet -w

date
echo "kubectl apply -f h2-deployment.yaml"
kubectl apply -f h2-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-2 -n aramid-relay-mainnet -w

date
echo "kubectl apply -f h3-deployment.yaml"
kubectl apply -f h3-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-3 -n aramid-relay-mainnet -w

cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/aramid-participation/de-1-participation
echo "kubernetes/algod-participation/aramid-participation/de-1-participation"
echo "kubectl apply -f deployment.yaml"
date
kubectl apply -f deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment participation-node-1 -n algo-participation-aramidmain -w
