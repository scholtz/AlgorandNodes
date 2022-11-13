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
produce=2.14.2
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

echo $produce > $currentFile

cd /home/scholtz/AlgorandNodes/

git add .
git commit -m "cicd update indexer from ${base} to ${produce}"
git push  || error_code=$?
if [ $error_code_int -ne 0 ]; then
    echo "git push failed";
	exit 1;
fi

END=$(date +%s);

echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}'


date