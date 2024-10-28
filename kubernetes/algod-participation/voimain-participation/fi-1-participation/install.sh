helm repo add biatec-repo https://scholtz.github.io/AlgorandNodes/helm/
helm repo update
helm upgrade --install voimain-participation-1 biatec-repo/voimain-participation -n voimain-participation --create-namespace --values ./p-1-values.yaml
helm upgrade --install voimain-participation-2 biatec-repo/voimain-participation -n voimain-participation --create-namespace --values ./p-2-values.yaml