cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/mainnet-relay/fi-1-mainnet-relay
echo "kubectl apply -f h1-deployment.yaml"
date
kubectl apply -f h1-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-1 -n algo-relay-mainnet -w
while kubectl get deployment relaynode-1 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "kubectl apply -f s3-k1-fi-deployment.yaml"
kubectl apply -f s3-k1-fi-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-3 -n algo-relay-mainnet -w
while kubectl get deployment relaynode-3 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "DONE ALGO RELAY FI, Upgrading Participation KMD FI"

cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/mainnet-participation/fi-1-participation
echo "kubectl apply -f h2-deployment.yaml"
date
kubectl apply -f h2-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment kmd-node-2 -n algo-kmd-mainnet -w
while kubectl get deployment kmd-node-2 -n algo-kmd-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

# date
# echo "DONE Upgrading Participation KMD FI, Upgrading aramid servers"
# cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/aramid-relay/fi-1-aramid-relay

# date
# kubectl apply -f h1-deployment.yaml
# sleep 1
# echo "waiting for pods to be live"
# while kubectl get deployment relaynode-1 -n aramid-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

# date
# echo "kubectl apply -f h2-deployment.yaml"
# kubectl apply -f h2-deployment.yaml
# sleep 1
# echo "waiting for pods to be live"
# while kubectl get deployment relaynode-2 -n aramid-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "DONE"

echo "DONE Upgrading FI VoiTest relay"
cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/voitest-relay/fi-1-voitest-relay

date
kubectl apply -f s2-k1-fi-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-2 -n algo-relay-voitest -w
while kubectl get deployment relaynode-2 -n algo-relay-voitest -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
kubectl apply -f s3-k1-fi-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-3 -n algo-relay-voitest -w
while kubectl get deployment relaynode-3 -n algo-relay-voitest -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "DONE"

echo "DONE Upgrading VoiTest public participation server"
cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/voitest-participation/fi-1-participation
date
kubectl apply -f deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment participation-node-2 -n algo-participation-voitest -w
while kubectl get deployment participation-node-2 -n algo-participation-voitest -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done
