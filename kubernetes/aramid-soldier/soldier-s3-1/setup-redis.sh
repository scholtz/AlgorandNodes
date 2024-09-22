kubectl create namespace aramid-s31
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm template redis --values redis-values.yaml bitnami/redis --namespace aramid-s31 > redis-template.yaml
kubectl apply -f redis-template.yaml --namespace aramid-s31