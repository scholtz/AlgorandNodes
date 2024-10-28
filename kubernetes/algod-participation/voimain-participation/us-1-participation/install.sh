helm repo add biatec-repo https://scholtz.github.io/AlgorandNodes/helm/
helm repo update
helm upgrade --install voimain-participation biatec-repo/voimain-participation -n voimain-participation --create-namespace --values ./values.yaml