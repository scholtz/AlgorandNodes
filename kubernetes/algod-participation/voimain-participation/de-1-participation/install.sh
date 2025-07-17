helm repo add biatec-repo https://scholtz.github.io/AlgorandNodes/helm/
helm repo update
helm upgrade --install voimain-participation biatec-repo/voimain-participation -n voimain-participation --create-namespace --values ./p-1-values.yaml
helm upgrade --install voimain-participation biatec-repo/voimain-participation -n voimain-participation-2 --create-namespace --values ./p-2-values.yaml

helm upgrade --install voimain-participation biatec-repo/voimain-participation -n voimain-participation --create-namespace --values ./p-3-values.yaml