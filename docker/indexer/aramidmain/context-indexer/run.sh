#!/bin/bash

cp -f genesis/aramidmain/genesis.json data/genesis.json
cp -f consensus.json data/consensus.json

algorand-indexer daemon
