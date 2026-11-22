# AGENTS.md

Infrastructure repo for running Algorand-family nodes (Algorand mainnet/testnet, Voi, Aramid) as Docker images, Kubernetes manifests and Helm charts. There is no application code, no test suite and no CI config in the repo: it is shell scripts, Dockerfiles, YAML and JSON. Docker Hub namespace: `scholtz2`.

## Layout

- `docker/`
  - `algod-relay/{mainnet,testnet,voimain,aramidmain,diatomix}` – relay node images. Base: `algorand/stable:$ALGO_VER`. `context/` (or `context-aramid/`) holds `run.sh`, `health.sh`, `config.json`, genesis files.
  - `algod-participation/{mainnet,sandbox}` – participation + KMD images. `mainnet/compose-kmd-official.dockerfile` builds `FROM scholtz2/algorand-relay-mainnet:$ALGO_VER-stable`, so the relay image must be built and pushed first. `context-kmd/run-participation-<network>[-with-appsettings].sh` are the entrypoints.
  - `algod-follow/{aramidmain,voimain}` – follow-node images.
  - `indexer/`, `goracle/`, `dappflow/` – other services.
  - `current-relay-version.txt`, `current-indexer-version.txt` – current released version; the update scripts read and write them.
  - `update-relay-generic.sh`, `update-indexer-generic.sh` – release automation (see below).
- `kubernetes/` – plain manifests by role/network/site (e.g. `algod-relay/mainnet-relay/de-1-mainnet-relay/g1-deployment.yaml`). `upgrade-*.sh` apply deployments one at a time and wait for rollout.
- `helm/` – charts: `algorand-relay`, `algorand-participation`, `aramid-relay`, `aramid-participation`, `voimain-participation`, `aramid-indexer`, `voimain-indexer`, `algorand-indexer`. The three indexer charts share identical templates (postgres, follower node, conduit, indexer, ingress) and differ only in `values.yaml`, `Chart.yaml` and the generated README/schema, so apply template fixes to all three. Validate with `docker run --rm -v <abs path>/helm:/c -w /c alpine/helm:3.16.4 lint <chart>`; regenerate `values.schema.json` with the readme-generator command in `helm/reindex.sh`; after `helm package` use `helm repo index --merge index.yaml` so existing entries keep their timestamps. Packaged `.tgz` files, `index.yaml` and `pubkey.asc` are generated and published via GitHub Pages (`https://scholtz.github.io/AlgorandNodes/helm/`).

## Version-per-file convention

Each Algorand release gets its own build script, named with the version, for example:

- `docker/algod-relay/mainnet/compose-relaynode-official-5.1.1-stable.sh` (also `-testnet`, `-voimain` variants)
- `docker/algod-relay/aramidmain/aramid-from-official-5.1.1-stable.sh`
- `docker/algod-participation/mainnet/compose-kmd-official-5.1.1-stable.sh`
- `docker/algod-follow/{aramidmain,voimain}/*-follow-node-5.1.1-stable.sh`

The scripts are near-identical: set `ver=`, `docker build ... --build-arg ALGO_VER=$ver`, `docker push`, with an error check after each step. Old versions are kept on purpose. Never edit an old versioned script. To add a version, copy the latest one and `sed` the old version string to the new one, as the update script does.

## Release automation (`docker/update-relay-generic.sh`)

It is meant to run on the maintainer's server, not in this checkout. It hardcodes `~/AlgorandNodes` and the sibling repo `~/AlgorandKMDServer`. It does the following:

1. Fetches the latest tag from Docker Hub `algorand/stable`, compares it with `current-relay-version.txt`, and exits if they match.
2. Copies each versioned script and builds and pushes the images.
3. Runs `sed -i "s~$base~$produce~g"` over a hardcoded list of Kubernetes manifests and the helm `Chart.yaml` and `values.yaml` files.
4. Runs `helm package` and `helm repo index`.
5. Writes the new version to `current-relay-version.txt` and commits and pushes with the message `cicd update from X to Y`.

## Which update script owns what

There are two release scripts. Put version-bump logic in the script whose version the artifact tracks, never in the other one:

- `docker/update-relay-generic.sh` (driven by `current-relay-version.txt`, the algod/node version) owns: relay, participation/KMD and follow-node images, the `kubernetes/algod-*` manifests and the node helm charts (`algorand-relay`, `algorand-participation`, `aramid-relay`, `aramid-participation`, `voimain-participation`).
- `docker/update-indexer-generic.sh` (driven by `current-indexer-version.txt`, the indexer version) owns: indexer images, `kubernetes/indexer/*` manifests and the indexer helm charts `voimain-indexer` and `algorand-indexer`. Their `Chart.yaml` version/appVersion track the indexer version, and the script also sets the follower node image tag from `current-relay-version.txt`.
- `aramid-indexer` is versioned by hand (its images are built separately). Neither script touches it.
- When you add a chart, manifest or image, first decide which version it follows and extend only that script. Do not add indexer steps to the relay script or node steps to the indexer script.
- Both scripts must call `helm repo index --merge index.yaml ...` and must bump the chart `version` whenever a packaged chart's contents change; never re-package different content under an already published version.

Consequences for edits:

- A new manifest or chart that pins an image version will only be bumped automatically if it is added to the `sed` list in this script.
- The `sed` replaces the old version string everywhere in the target files, so do not put unrelated text containing that version string in those files.
- Do not run these scripts casually: they push to Docker Hub and to git.
- Treat commits named `cicd update from ...` as bot-generated version bumps.

## Working notes

- Shell scripts are bash with LF endings. They are run on Linux. This machine is Windows, so use Git Bash or WSL, and don't convert line endings.
- Building or pushing images needs Docker and Docker Hub credentials; `helm` is needed for the charts. Don't run `docker push`, `kubectl apply` or `helm` against real clusters unless the user asks.
- After changing a chart's `values.yaml`, regenerate the README and schema docs and re-package (see `helm/reindex.sh`). Bump the chart version in `Chart.yaml`.
- Genesis files and `consensus*.json` in `context*` directories are vendored network data. Do not hand-edit them. Each network has its own copy per image context, so a change may need repeating across `algod-relay`, `algod-participation` and `algod-follow`.
- Do not commit secrets: participation keys, KMD tokens, `appsettings` credentials or kubeconfigs.
- Many files are duplicated per site/network (`de-1`, `fi-1`, `in-1`, ...). When changing shared behaviour, grep for sibling files and keep them consistent.
