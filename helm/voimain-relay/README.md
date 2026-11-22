# VOI Relay Node

This helm chart allows you to run a VOI relay node (voimain-1.0) in a k8s cluster easily. It uses the `scholtz2/algorand-relay-voimain` image.

Check out the source at [AlgorandNodes github repository](https://github.com/scholtz/AlgorandNodes/tree/main/helm).

See [Default values](https://github.com/scholtz/AlgorandNodes/blob/main/helm/voimain-relay/values.yaml) for the helm chart.

Ports used by the image defaults: 5010 (gossip), 28081 (algod API); 9100 is the metrics port, served only when metrics are enabled in the node. The gossip service is a `LoadBalancer` by default; the algod API and metrics services are `ClusterIP`.

The default `pvcRoot.storageClassName` is the Linode class `linode-block-storage-retain`; set it to your cluster's class (or `""` for the default class) on other providers.
