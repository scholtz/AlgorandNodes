cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/voimain-relay/de-1-voimain-relay
echo "kubectl apply -f g1-deployment.yaml"
date
kubectl apply -f s1-k1-de-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-1 -n algo-relay-voimain -w
while kubectl get deployment relaynode-1 -n algo-relay-voimain -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "kubectl apply -f s2-k1-de-deployment.yaml"
kubectl apply -f s2-k1-de-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-2 -n algo-relay-voimain -w
while kubectl get deployment relaynode-2 -n algo-relay-voimain -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "kubectl apply -f s3-k1-de-deployment.yaml"
kubectl apply -f s3-k1-de-deployment.yaml
sleep 1
echo "waiting for pods to be live"
kubectl rollout status deployment relaynode-3 -n algo-relay-voimain -w
while kubectl get deployment relaynode-3 -n algo-relay-voimain -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done
