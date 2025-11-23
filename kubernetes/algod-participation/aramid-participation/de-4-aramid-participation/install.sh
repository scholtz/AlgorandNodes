helm repo add biatec-repo https://scholtz.github.io/AlgorandNodes/helm/
helm repo update

helm upgrade --install --create-namespace aramid-participation biatec-repo/aramid-participation --values ./p1.yaml --namespace aramid
