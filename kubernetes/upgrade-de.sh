cd mainnet-relay-de
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
echo "DONE ALGO RELAY DE, Upgrading Participation KMD DE"

cd ../kmd-de
echo "kubectl apply -f h2-deployment.yaml"
date
kubectl apply -f h2-deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment kmd-node-2 -n algo-kmd-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "DONE Upgrading Participation KMD DE, Upgrading aramid servers"
cd ../aramid-main-de

date
kubectl apply -f h1-deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment relaynode-1 -n aramid-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "kubectl apply -f h2-deployment.yaml"
kubectl apply -f h2-deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment relaynode-2 -n aramid-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "DONE"