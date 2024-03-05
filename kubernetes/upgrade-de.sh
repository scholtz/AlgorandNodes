cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/mainnet-relay/de-1-mainnet-relay
echo "kubectl apply -f g1-deployment.yaml"
date
kubectl apply -f g1-deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment relaynode-1 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "kubectl apply -f g2-deployment.yaml"
kubectl apply -f g2-deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment relaynode-2 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "kubectl apply -f g3-deployment.yaml"
kubectl apply -f g3-deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment relaynode-3 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "DONE ALGO RELAY DE, Upgrading Participation KMD DE"

cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/mainnet-participation/de-1-participation
echo "kubectl apply -f h2-deployment.yaml"
date
kubectl apply -f h2-deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment kmd-node-2 -n algo-kmd-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

# date
# echo "DONE Upgrading Participation KMD DE, Upgrading aramid servers"
# cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/aramid-relay/de-1-aramid-relay

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

echo "DONE Upgrading VoiTest public participation server"
cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/voitest-participation/de-1-participation
date
kubectl apply -f deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment participation-node-2 -n algo-participation-voitest -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done
