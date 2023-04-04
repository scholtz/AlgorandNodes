#!/bin/bash

cp mainnet/* data/ -R
diagcfg telemetry enable
diagcfg metric enable
goal node start 

while true; do echo `date`; goal node status; sleep 600;done
