#!/bin/bash

cp -f genesis/aramidmain/genesis.json /app/data/genesis.json
cp -f consensus.json /app/data/consensus.json

algorand-indexer daemon
