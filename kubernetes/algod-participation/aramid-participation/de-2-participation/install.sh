helm repo add biatec-repo https://scholtz.github.io/AlgorandNodes/helm/
helm repo update
helm upgrade --install aramidmain-participation-1 biatec-repo/aramid-participation -n aramid-participation --create-namespace --values ./p-1-values.yaml
helm upgrade --install aramidmain-participation-2 biatec-repo/aramid-participation -n aramid-participation --create-namespace --values ./p-2-values.yaml
helm upgrade --install aramidmain-participation-3 biatec-repo/aramid-participation -n aramid-participation --create-namespace --values ./p-3-values.yaml