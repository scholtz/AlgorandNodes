# Algorand Nodes docker and kubernetes setups

## Relay node setup in Linode

https://github.com/scholtz/AlgorandNodes/blob/main/kubernetes/algod-relay/mainnet-relay/generic-linode/h1-deployment.yaml

## Sandbox in K8S

https://github.com/scholtz/AlgorandNodes/blob/main/kubernetes/algod-relay/sandbox-relay/sandbox.yaml

## Participation node with KMD proxy

https://github.com/scholtz/AlgorandNodes/tree/main/docker/algod-participation

# Helm repository

## Add helm repository

```
helm repo add biatec-repo https://scholtz.github.io/AlgorandNodes/helm/
helm repo update
```

## Install algorand nodes

Check the example of [algorand relay installation using HELM charts](https://github.com/scholtz/AlgorandNodes/blob/main/kubernetes/algod-relay/mainnet-relay/de-4-mainnet-relay/install.sh)
