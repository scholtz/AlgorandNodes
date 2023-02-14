cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/mainnet-relay/jp-2-mainnet-relay
echo "kubectl apply -f h1-deployment.yaml"
date
kubectl apply -f h1-deployment.yaml
sleep 1
echo "waiting for pods to be live"
while kubectl get deployment relaynode-1 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "DONE"