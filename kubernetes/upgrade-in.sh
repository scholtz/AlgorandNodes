cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/mainnet-relay/in-2-mainnet-relay
echo "kubectl apply -f h4-deployment.yaml"
date
kubectl apply -f h4-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-4 -n algo-relay-mainnet -w
while kubectl get deployment relaynode-4 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "kubectl apply -f h5-deployment.yaml"
kubectl apply -f h5-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-5 -n algo-relay-mainnet -w
while kubectl get deployment relaynode-5 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "kubectl apply -f h6-deployment.yaml"
kubectl apply -f h6-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-6 -n algo-relay-mainnet -w
while kubectl get deployment relaynode-6 -n algo-relay-mainnet -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "DONE"