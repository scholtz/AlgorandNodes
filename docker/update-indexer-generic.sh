#!/bin/bash

#base=3.10.0
#produce=3.10.0

tags=$(curl https://api.github.com/repos/algorand/indexer/releases)
tag=$(echo $tags | jq -r .[0].tag_name)
echo "latest github tag: $tag";

if [ "$tag" == "" ]; then
    echo "failed to fetch latest version";
	exit 1;
fi
if [ "$tag" == "latest" ]; then
    echo "failed to fetch latest version";
	exit 1;
fi
if [ "$tag" == "develop" ]; then
    echo "failed to fetch latest version";
	exit 1;
fi
produce=$tag
cd /home/scholtz/AlgorandNodes/docker

currentFile="/home/scholtz/AlgorandNodes/docker/current-indexer-version.txt"
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

cd /home/scholtz/AlgorandNodes/docker/indexer/mainnet

f1base="compose-indexer-${base}.sh"
f1="compose-indexer-${produce}.sh"
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


cd /home/scholtz/AlgorandNodes/kubernetes/indexer/mainnet-indexer/de-1-mainnet-indexer
f1=deployment.yaml
sed -i "s~$base~$produce~g" $f1


################### HELM CHARTS (voimain-indexer, algorand-indexer)
# chart version and appVersion follow the indexer version, the indexer image tag is bumped
# and the follower node image tag follows the current relay/node version
baseHelm=/home/scholtz/AlgorandNodes/helm
relayVersion=$(cat /home/scholtz/AlgorandNodes/docker/current-relay-version.txt)
if [ "$relayVersion" == "" ]; then
    echo "failed to read current relay version";
    exit 1;
fi
for chart in voimain-indexer algorand-indexer; do
    if [ -f "$baseHelm/${chart}-${produce#v}.tgz" ]; then
        echo "$baseHelm/${chart}-${produce#v}.tgz already exists, bump the chart version by hand first";
        exit 1;
    fi
    cd $baseHelm/$chart || exit 1
    sed -i "s~^version: .*~version: ${produce#v}~" Chart.yaml
    sed -i "s~^appVersion: .*~appVersion: '${produce#v}'~" Chart.yaml
    sed -i "s~$base~$produce~g" values.yaml
    sed -i "s~tag: \"[0-9][0-9.]*-stable\"~tag: \"${relayVersion}-stable\"~" values.yaml
done

cd $baseHelm || exit 1
helm package voimain-indexer/ || exit 1
helm package algorand-indexer/ || exit 1
helm repo index --merge index.yaml --url https://scholtz.github.io/AlgorandNodes/helm/ . || exit 1

echo $produce > $currentFile

cd /home/scholtz/AlgorandNodes/

git add .
git commit -m "cicd update indexer from ${base} to ${produce}"
error_code=0
git push  || error_code=$?
error_code_int=$(($error_code + 0))
if [ $error_code_int -ne 0 ]; then
    echo "git push failed";
	exit 1;
fi

END=$(date +%s);

echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}'


date