cd mainnet
echo "kubectl apply -f statefulset.yaml"
# date
# kubectl apply -f statefulset.yaml
# sleep 1
# echo "waiting for pods to be live"
# while kubectl get statefulset relaynode-ss -n algorand -ojson | jq '.status.conditions[].status' -r | grep -q False; do sleep 1; date; done

date
echo "DONE"