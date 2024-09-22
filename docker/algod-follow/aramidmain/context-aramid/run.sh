#!/bin/bash

cp --update=none config.json data/config.json; 
cp -f genesis/aramidmain/genesis.json data/genesis.json; 
cp -f consensus.json data/consensus.json; 
date; 
goal node start; 
date; 
while :; do date; goal node status; sleep 600 ; done