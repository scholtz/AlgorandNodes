kubectl delete statefulset relaynode-ss -n algorand  --cascade=orphan
kubectl apply -f statefulset.yaml

# to reside .. delete with orphan, delete pod, resize in control panel, apply statefulset, ssh to server, df, resize2fs /dev/disk/.. repeat for each pod