cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/mainnet-relay/in-1-mainnet-relay
echo "kubectl apply -f h1-deployment.yaml"
date
kubectl apply -f h1-deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment relaynode-1 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "kubectl apply -f h2-deployment.yaml"
kubectl apply -f h2-deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment relaynode-2 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "kubectl apply -f h3-deployment.yaml"
kubectl apply -f h3-deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment relaynode-3 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "DONE"