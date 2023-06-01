#!/bin/bash
if [ ! -f data/config.json ]
then
    cp mainnet/* data/ -R
fi
diagcfg telemetry enable
diagcfg metric enable
goal node start 

while true; do echo `date`; goal node status; sleep 600;done
