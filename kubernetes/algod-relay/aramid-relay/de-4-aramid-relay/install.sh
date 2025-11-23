helm repo add biatec-repo https://scholtz.github.io/AlgorandNodes/helm/
helm repo update

helm upgrade --install --create-namespace aramid-relay biatec-repo/aramid-relay --values ./r1.yaml --namespace aramid

helm upgrade --install --create-namespace aramid-relay biatec-repo/aramid-relay --values ./a1.yaml --namespace aramid
