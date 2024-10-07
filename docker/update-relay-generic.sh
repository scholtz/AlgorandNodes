#!/bin/bash

#base=3.10.0
#produce=3.10.0

tags=$(curl https://hub.docker.com/v2/repositories/algorand/stable/tags/?page_size=2&page=1)
tag=$(echo $tags | jq -r  .results[0].name)
if [ "$tag" == "latest" ]; then
    #echo "first is latest"
    tag=$(echo $tags | jq -r  .results[1].name)
fi

if [ "$tag" == "" ]; then
    echo "failed to fetch latest version";
	exit 1;
fi

if [ "$tag" == "latest" ]; then
    echo "failed to fetch latest version";
	exit 1;
fi
produce=$tag

cd /home/scholtz/AlgorandNodes/docker

currentFile="/home/scholtz/AlgorandNodes/docker/current-relay-version.txt"
base=$(cat "$currentFile")

if [ "$base" == "" ]; then
    echo "failed to fetch base version";
	exit 1;
fi

date
START=$(date +%s);

echo "base $base produce $produce"
if [ "$base" == "$produce" ]; then
    echo "nothing to do";
	exit 0;
fi


cd /home/scholtz/AlgorandNodes/docker
git pull || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "git pull failed";
	exit 1;
fi

cd /home/scholtz/AlgorandNodes/docker/algod-relay/mainnet

f1base="compose-relaynode-official-${base}-stable.sh"
f1="compose-relaynode-official-${produce}-stable.sh"
if [ ! -f "$f1" ]; then
    cp $f1base $f1
    sed -i "s~$base~$produce~g" $f1
fi
echo "Processing ${f1}"
bash $f1 || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "$f1 failed";
	exit 1;
fi

cd /home/scholtz/AlgorandNodes/docker/algod-relay/aramidmain
echo "docker/algod-relay/aramidmain"

f1base="aramid-from-official-${base}-stable.sh"
f1="aramid-from-official-${produce}-stable.sh"
if [ ! -f "$f1" ]; then
    cp $f1base $f1
    sed -i "s~$base~$produce~g" $f1
fi

echo "Processing ${f1}"
bash $f1 || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "$f1 failed";
	exit 1;
fi

cd /home/scholtz/AlgorandNodes/docker/algod-relay/voimain
echo "docker/algod-relay/voimain"
f1base="compose-relaynode-official-${base}-stable-voimain.sh"
f1="compose-relaynode-official-${produce}-stable-voimain.sh"
if [ ! -f "$f1" ]; then
    echo "copy $f1base to $f1"
    cp $f1base $f1
    sed -i "s~$base~$produce~g" $f1
fi
echo "Processing ${f1}"
bash $f1 || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "$f1 failed";
	exit 1;
fi

cd /home/scholtz/AlgorandNodes/docker/algod-relay/testnet

f1base="compose-relaynode-official-${base}-stable-testnet.sh"
f1="compose-relaynode-official-${produce}-stable-testnet.sh"
if [ ! -f "$f1" ]; then
    cp $f1base $f1
    sed -i "s~$base~$produce~g" $f1
fi

echo "Processing ${f1}"
bash $f1 || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "$f1 failed";
	exit 1;
fi

cd /home/scholtz/AlgorandNodes/docker/algod-participation/mainnet
echo "docker/algod-participation/mainnet"

f1base="compose-kmd-official-${base}-stable.sh"
f1="compose-kmd-official-${produce}-stable.sh"
if [ ! -f "$f1" ]; then
    cp $f1base $f1
    sed -i "s~$base~$produce~g" $f1
fi

echo "Processing ${f1}"
bash $f1 || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "$f1 failed";
	exit 1;
fi

cd /home/scholtz/AlgorandKMDServer/
echo "AlgorandKMDServer"

git pull || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "git pull failed";
	exit 1;
fi

cd /home/scholtz/AlgorandKMDServer/docker/mainnet
echo "AlgorandKMDServer/docker/mainnet"

f1base="compose-algorand-kmd-mainnet-extended-${base}.sh"
f1="compose-algorand-kmd-mainnet-extended-${produce}.sh"
if [ ! -f "$f1" ]; then
    cp $f1base $f1
    sed -i "s~$base~$produce~g" $f1
fi

echo "Processing ${f1}"
bash $f1 || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "$f1 failed";
	exit 1;
fi

cd /home/scholtz/AlgorandKMDServer/docker/voimain
echo "AlgorandKMDServer/docker/voimain"

f1base="compose-algorand-participation-voimain-extended-${base}.sh"
f1="compose-algorand-participation-voimain-extended-${produce}.sh"
if [ ! -f "$f1" ]; then
    cp $f1base $f1
    sed -i "s~$base~$produce~g" $f1
fi

echo "Processing ${f1}"
bash $f1 || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "$f1 failed";
	exit 1;
fi


cd /home/scholtz/AlgorandKMDServer/docker/aramidmain
echo "AlgorandKMDServer/docker/aramidmain"

f1base="compose-algorand-participation-aramidmain-extended-${base}.sh"
f1="compose-algorand-participation-aramidmain-extended-${produce}.sh"
if [ ! -f "$f1" ]; then
    cp $f1base $f1
    sed -i "s~$base~$produce~g" $f1
fi

echo "Processing ${f1}"
bash $f1 || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "$f1 failed";
	exit 1;
fi


cd /home/scholtz/AlgorandNodes/docker/algod-follow/aramidmain
echo "AlgorandNodes/docker/algod-follow/aramidmain"

f1base="aramid-follow-node-${base}-stable.sh"
f1="aramid-follow-node-${produce}-stable.sh"
if [ ! -f "$f1" ]; then
    cp $f1base $f1
    sed -i "s~$base~$produce~g" $f1
fi

echo "Processing ${f1}"
bash $f1 || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "$f1 failed";
	exit 1;
fi

cd /home/scholtz/AlgorandNodes/docker/algod-follow/voimain
echo "AlgorandNodes/docker/algod-follow/voimain"

f1base="voimain-follow-node-${base}-stable.sh"
f1="voimain-follow-node-${produce}-stable.sh"
if [ ! -f "$f1" ]; then
    cp $f1base $f1
    sed -i "s~$base~$produce~g" $f1
fi

echo "Processing ${f1}"
bash $f1 || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "$f1 failed";
	exit 1;
fi

cd /home/scholtz/AlgorandKMDServer/

git add .
git commit -m "cicd update from ${base} to ${produce}"
git push  || error_code=$?
if [ $error_code_int -ne 0 ]; then
    echo "git push failed";
	exit 1;
fi

cd /home/scholtz/AlgorandNodes/docker/algod-participation/sandbox
echo "docker/algod-participation/sandbox"

f1=compose-participation-sandbox-night-build.dockerfile
sed -i "s~$base~$produce~g" $f1


f1base="compose-participation-sandbox-${base}-stable.sh"
f1="compose-participation-sandbox-${produce}-stable.sh"
if [ ! -f "$f1" ]; then
    cp $f1base $f1
    sed -i "s~$base~$produce~g" $f1
fi

echo "Processing ${f1}"
bash $f1 || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "$f1 failed";
	exit 1;
fi

cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/mainnet-relay/fi-1-mainnet-relay
f1=h2-deployment.yaml
sed -i "s~$base~$produce~g" $f1

f1=h1-deployment.yaml
sed -i "s~$base~$produce~g" $f1

f1=s3-k1-fi-deployment.yaml
sed -i "s~$base~$produce~g" $f1


cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/mainnet-relay/de-1-mainnet-relay
f1=g2-deployment.yaml
sed -i "s~$base~$produce~g" $f1

f1=g1-deployment.yaml
sed -i "s~$base~$produce~g" $f1

f1=g3-deployment.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/mainnet-relay/in-1-mainnet-relay
f1=h2-deployment.yaml
sed -i "s~$base~$produce~g" $f1

f1=h1-deployment.yaml
sed -i "s~$base~$produce~g" $f1

f1=h3-deployment.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/mainnet-relay/in-2-mainnet-relay
f1=h4-deployment.yaml
sed -i "s~$base~$produce~g" $f1

f1=h5-deployment.yaml
sed -i "s~$base~$produce~g" $f1

f1=h6-deployment.yaml
sed -i "s~$base~$produce~g" $f1

# cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/mainnet-relay/jp-1-mainnet-relay
# f1=statefulset.yaml
# sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/sandbox-relay
f1=sandbox.yaml
sed -i "s~$base~$produce~g" $f1
f1=participation-win-minikube.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/mainnet-participation/fi-1-participation
f1=h2-deployment.yaml
sed -i "s~$base~$produce~g" $f1
f1=kmd-win-minikube.yaml
sed -i "s~$base~$produce~g" $f1

# cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/voimain-participation/fi-1-participation
# f1=deployment.yaml
# sed -i "s~$base~$produce~g" $f1

# cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/voimain-participation/de-1-participation
# f1=deployment.yaml
# sed -i "s~$base~$produce~g" $f1

# cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/voimain-participation/linode-generic
# f1=deployment.yaml
# sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/mainnet-participation/de-1-participation
f1=h2-deployment.yaml
sed -i "s~$base~$produce~g" $f1

################### VOIMAIN
cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/voimain-relay/de-1-voimain-relay
f1=s1-k1-de-deployment.yaml
sed -i "s~$base~$produce~g" $f1
f1=s2-k1-de-deployment.yaml
sed -i "s~$base~$produce~g" $f1
f1=s3-k1-de-deployment.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/voimain-relay/fi-1-voimain-relay
f1=s1-k1-fi-deployment.yaml
sed -i "s~$base~$produce~g" $f1
f1=s2-k1-fi-deployment.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/voimain-relay/in-1-voimain-relay
f1=h1-deployment.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/testnet-relay/de-1-testnet-relay
f1=statefulset.yaml
sed -i "s~$base~$produce~g" $f1

# cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/mainnet-relay/jp-2-mainnet-relay
# f1=h1-deployment.yaml
# sed -i "s~$base~$produce~g" $f1

# f1=h2-deployment.yaml
# sed -i "s~$base~$produce~g" $f1


################### ARAMIDMAIN
cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/aramid-relay/fi-1-aramid-relay
f1=h1-deployment.yaml
sed -i "s~$base~$produce~g" $f1
f1=h2-deployment.yaml
sed -i "s~$base~$produce~g" $f1
f1=a1-deployment.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/aramid-relay/de-1-aramid-relay
f1=h1-deployment.yaml
sed -i "s~$base~$produce~g" $f1
f1=h2-deployment.yaml
sed -i "s~$base~$produce~g" $f1
f1=h3-deployment.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/aramid-relay/linode-example

f1=statefulset.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-relay/aramid-relay/aws
f1=deployment.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/aramid-participation/de-1-participation
f1=deployment.yaml
sed -i "s~$base~$produce~g" $f1
cd /home/scholtz/AlgorandNodes/kubernetes/algod-participation/aramid-participation/fi-1-participation
f1=deployment.yaml
sed -i "s~$base~$produce~g" $f1

################### HELM CHARTS
cd /home/scholtz/AlgorandNodes/helm/aramid-relay
f1=Chart.yaml
sed -i "s~$base~$produce~g" $f1
f1=values.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/helm/

helm package aramid-relay/
helm repo index --url https://scholtz.github.io/AlgorandNodes/helm/ .

################### FINISH
cd /home/scholtz/AlgorandNodes/docker

echo $produce > $currentFile

cd /home/scholtz/AlgorandNodes/

git add .
git commit -m "cicd update from ${base} to ${produce}"
git push || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "git push failed";
	exit 1;
fi


END=$(date +%s);

echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}'


date