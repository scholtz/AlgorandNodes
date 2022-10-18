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


currentFile="current-relay-version.txt"
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

cd /home/scholtz/AlgorandKMDServer

git pull || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "git pull failed";
	exit 1;
fi

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

git add .
git commit -m "cicd update from ${base} to ${produce}"
git push  || error_code=$?
if [ $error_code_int -ne 0 ]; then
    echo "git push failed";
	exit 1;
fi

cd /home/scholtz/AlgorandNodes/docker


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


cd /home/scholtz/AlgorandNodes/kubernetes/mainnet-relay-fi
f1=h2-deployment.yaml
sed -i "s~$base~$produce~g" $f1

f1=h1-deployment.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/mainnet
f1=statefulset.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/sandbox
f1=sandbox.yaml
sed -i "s~$base~$produce~g" $f1
f1=participation-win-minikube.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/kmd-fi
f1=h2-deployment.yaml
sed -i "s~$base~$produce~g" $f1
f1=kmd-win-minikube.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/kmd-de
f1=h2-deployment.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/testnet
f1=statefulset.yaml
sed -i "s~$base~$produce~g" $f1

cd /home/scholtz/AlgorandNodes/kubernetes/mainnet-relay-de
f1=g2-deployment.yaml
sed -i "s~$base~$produce~g" $f1

f1=g1-deployment.yaml
sed -i "s~$base~$produce~g" $f1

echo $produce > $currentFile

cd /home/scholtz/AlgorandNodes/

git add .
git commit -m "cicd update from ${base} to ${produce}"
git push  || error_code=$?
if [ $error_code_int -ne 0 ]; then
    echo "git push failed";
	exit 1;
fi


END=$(date +%s);

echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}'


date