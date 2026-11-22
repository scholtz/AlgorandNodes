#!/bin/bash
# Run manually on the maintainer's server after the patched scholtz2/aramid-indexer image
# (docker/indexer/aramidmain/aramid-indexer-<ver>.sh) for the current indexer version has been pushed.
# Brings the aramid-indexer helm chart in sync with docker/current-indexer-version.txt.
# values.schema.json defaults are documentation only and are not regenerated here (see helm/reindex.sh).

mainDir=/home/scholtz/AlgorandNodes
baseHelm=$mainDir/helm
produce=$(cat $mainDir/docker/current-indexer-version.txt)
newv=${produce#v}
relayVersion=$(cat $mainDir/docker/current-relay-version.txt)

if [ "$produce" == "" ] || [ "$relayVersion" == "" ]; then
    echo "failed to read current versions";
    exit 1;
fi

cd $baseHelm/aramid-indexer || exit 1
cur=$(awk '/^version:/{print $2}' Chart.yaml)
curApp=$(awk '/^appVersion:/{print $2}' Chart.yaml | tr -d "'\"")
# a previous run may have failed after editing the chart: edited but uncommitted means resume at packaging
dirty=$(git -C $mainDir status --porcelain -- helm/aramid-indexer)
if [ "$curApp" == "$newv" ] && [ "$dirty" == "" ]; then
    echo "aramid-indexer chart already at $newv";
    exit 0;
fi

if ! curl -sf "https://hub.docker.com/v2/repositories/scholtz2/aramid-indexer/tags/v${newv}-stable" > /dev/null; then
    echo "scholtz2/aramid-indexer:v${newv}-stable does not exist yet, build it first";
    exit 1;
fi

if ! curl -sf "https://hub.docker.com/v2/repositories/scholtz2/aramid-algo-follow-node/tags/v${relayVersion}-stable" > /dev/null; then
    echo "scholtz2/aramid-algo-follow-node:v${relayVersion}-stable does not exist yet";
    exit 1;
fi

if [ "$curApp" != "$newv" ]; then
git -C $mainDir pull || exit 1

top=$(printf '%s\n%s\n' "$cur" "$newv" | sort -V | tail -1)
if [ "$top" == "$newv" ] && [ "$cur" != "$newv" ]; then
    chartVersion=$newv
else
    chartVersion="${cur%.*}.$((${cur##*.}+1))"
fi
sed -i "s~^version: .*~version: ${chartVersion}~" Chart.yaml
sed -i "s~^appVersion: .*~appVersion: '${newv}'~" Chart.yaml
sed -i "s~tag: \"v$curApp-stable\"~tag: \"v${newv}-stable\"~" values.yaml
sed -i "/^deploymentFollowerNode:/,/^## @section Deployment for conduit/ s~tag: \"\(v\?\)[0-9][0-9.]*-stable\"~tag: \"\1${relayVersion}-stable\"~" values.yaml
fi
chartVersion=$(awk '/^version:/{print $2}' Chart.yaml)

cd $baseHelm || exit 1
helm package aramid-indexer/ || exit 1
helm repo index --merge index.yaml --url https://scholtz.github.io/AlgorandNodes/helm/ . || exit 1

cd $mainDir || exit 1
git add .
git commit -m "cicd update aramid-indexer chart to ${chartVersion}" || exit 1
git push || { echo "git push failed"; exit 1; }
