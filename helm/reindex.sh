
docker run -it -v "$(pwd)/algorand-relay:/app/data" scholtz2/readme-generator-for-helm:2.7.2 readme-generator -v data/values.yaml -s data/values.schema.json

helm package algorand-relay/

docker run -it -v "$(pwd)/algorand-participation:/app/data" scholtz2/readme-generator-for-helm:2.7.2 readme-generator -v data/values.yaml -s data/values.schema.json

helm package algorand-participation/

docker run -it -v "$(pwd)/aramid-relay:/app/data" scholtz2/readme-generator-for-helm:2.7.2 readme-generator -v data/values.yaml -s data/values.schema.json

helm package aramid-relay/

docker run -it -v "$(pwd)/aramid-participation:/app/data" scholtz2/readme-generator-for-helm:2.7.2 readme-generator -v data/values.yaml -s data/values.schema.json

helm package aramid-participation/

docker run -it -v "$(pwd)/voimain-participation:/app/data" scholtz2/readme-generator-for-helm:2.7.2 readme-generator -v data/values.yaml -s data/values.schema.json

helm package voimain-participation/

docker run -it -v "$(pwd)/aramid-indexer:/app/data" scholtz2/readme-generator-for-helm:2.7.2 readme-generator -v data/values.yaml -s data/values.schema.json

helm package aramid-indexer/

helm repo index --url https://scholtz.github.io/AlgorandNodes/helm/ .
