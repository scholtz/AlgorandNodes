#!/bin/bash

# Ensure the address is set in the environment variable
if [ -z "$ADDRESS" ]; then
  echo "Error: ADDRESS environment variable is not set."
  echo "
>>> USAGE: 

ADDRESS=RA4AOLFLSGNMDBDL3CQ3W2DADVFIFBZIZP4B6HPHMV4UYF4IPH6WXT6T4E ROUNDS=1000000 ./create-participation-key.sh
"
  echo " or 
"
  echo "ADDRESS=RA4AOLFLSGNMDBDL3CQ3W2DADVFIFBZIZP4B6HPHMV4UYF4IPH6WXT6T4E ./create-participation-key.sh
"
  echo " or 
"
  echo "export ADDRESS=RA4AOLFLSGNMDBDL3CQ3W2DADVFIFBZIZP4B6HPHMV4UYF4IPH6WXT6T4E
export ROUNDS=1000000 # Optional, defaults to 16777215 if not set
./create-participation-key.sh"
  exit 1
fi

rounds=${ROUNDS:-16777215} # Use the ROUNDS environment variable or default to 16777215
CURRENT_BLOCK=$(goal node status | grep -oP '(?<=Last committed block: )\d+')
validUntil=$((CURRENT_BLOCK + rounds))

goal account addpartkey -a $ADDRESS --roundFirstValid=$CURRENT_BLOCK --roundLastValid=$validUntil

# List the generated participation key
goal account partkeyinfo | awk -v target="$ADDRESS" '
  BEGIN { RS = ""; FS = "\n" } # Treat blocks as separated by blank lines
  $0 ~ "Parent address:" && $0 ~ target { print $0 "\n" }
'