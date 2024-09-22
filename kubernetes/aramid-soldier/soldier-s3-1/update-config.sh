kubectl apply -f soldier-app.yaml

kubectl delete configmap aramid-s31-soldier-app-conf -n aramid-s31
kubectl create configmap aramid-s31-soldier-app-conf --from-file=conf -n aramid-s31
kubectl rollout restart deployment/aramid-s31-soldier-app-deployment -n aramid-s31
