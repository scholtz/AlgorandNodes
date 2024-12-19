#!/bin/bash

# mkdir ~/voi-relay-tracking
# wget https://raw.githubusercontent.com/scholtz/AlgorandNodes/refs/heads/main/docker/algod-relay/voimain/check-relays.sh -O ~/voi-relay-tracking
# crontab -e
# 43 * * * * cd ~/voi-relay-tracking && ./check-relays.sh >> out.txt 2>&1

# Set the DNS name
dns_name1="_algobootstrap._tcp.voimain.mainnet-voi.network"
dns_name2="_archive._tcp.voimain.mainnet-voi.network"
statusURL="https://mainnet-api.voi.nodely.dev/v2/status"

srv_records=$(dig +short SRV $dns_name1)

# Check if any SRV records were found
if [ -z "$srv_records" ]; then
    echo "No SRV records found for $dns_name1"
    exit 1
fi


to_base36() {
    local num=$1
    local base36=""
    local chars="0123456789abcdefghijklmnopqrstuvwxyz"

    while (( num > 0 )); do
        remainder=$(( num % 36 ))
        base36="${chars:remainder:1}$base36"
        num=$(( num / 36 ))
    done

    echo "$base36"
}

blockchainRoundMath=$(curl -s $statusURL | jq -r '.["last-round"]' )" - 0"
blockchainRound=$(echo $blockchainRoundMath | bc)
echo "blockchainRound=$blockchainRound"
# blockchainRound_hex=$(printf "%x" "$blockchainRound")
# echo "blockchainRound_hex=$blockchainRound_hex"
blockchainRound_b36=$(to_base36 "$blockchainRound")
echo "blockchainRound_b36=$blockchainRound_b36"

# Declare an associative array
declare -A data
declare -A times

# Process each SRV record without subshell
while read -r record; do
    # Extract the port and domain from the SRV record
    priority=$(echo $record | awk '{print $1}')
    weight=$(echo $record | awk '{print $2}')
    port=$(echo $record | awk '{print $3}')
    domain=$(echo $record | awk '{print $4}')

    # Remove the trailing dot from the domain (if any)
    domain=${domain%.}

    # Fetch the block data and calculate the sha256 checksum
    #echo "Fetching block data from http://$domain:$port/v1/aramidmain-v1.0/block/$blockchainRound_b36"
    start_time=$(date +%s.%N)
    data["$domain:$port"]=$(wget -q -O /dev/stdout  --timeout=5 --tries=1 --dns-timeout=1  --connect-timeout=1 --read-timeout=1  "http://$domain:$port/v1/aramidmain-v1.0/block/$blockchainRound_b36" | sha256sum)
    end_time=$(date +%s.%N)
    # Calculate elapsed time
    elapsed_time=$(echo "$end_time - $start_time" | bc)
    
    times["$domain:$port"]=$elapsed_time

    #echo "$domain:$port: ${data["$domain:$port"]}"
done < <(echo "$(dig +short SRV $dns_name1)")

# # Process each SRV record without subshell
# while read -r record; do
#     # Extract the port and domain from the SRV record
#     priority=$(echo $record | awk '{print $1}')
#     weight=$(echo $record | awk '{print $2}')
#     port=$(echo $record | awk '{print $3}')
#     domain=$(echo $record | awk '{print $4}')

#     # Remove the trailing dot from the domain (if any)
#     domain=${domain%.}

#     # Fetch the block data and calculate the sha256 checksum
#     #echo "Fetching block data from http://$domain:$port/v1/aramidmain-v1.0/block/$blockchainRound_b36"
#     data["$domain:$port"]=$(wget -q -O /dev/stdout  --timeout=5 --tries=1 --dns-timeout=1  --connect-timeout=1 --read-timeout=1 "http://$domain:$port/v1/aramidmain-v1.0/block/$blockchainRound_b36" | sha256sum)
#     #echo "$domain:$port: ${data["$domain:$port"]}"
# done < <(echo "$(dig +short SRV $dns_name2)")

declare -A count
for value in "${data[@]}"; do
    ((count["$value"]++))
done

# Find the most common checksum
most_common_value=""
max_count=0
for value in "${!count[@]}"; do
    if (( count["$value"] > max_count )); then
        max_count=${count["$value"]}
        most_common_value=$value
    fi
done

# Output the most common value and its count
echo "Most common value: $most_common_value"
echo "Occurrences: $max_count"

# Define color for output
RED='\033[0;31m'
NC='\033[0m' # No color

# Print keys and values, marking mismatches in red
for key in $(printf "%s\n" "${!data[@]}" | sort); do
    if [[ "${data[$key]}" != "$most_common_value" ]]; then
        echo -e "Key: ${RED}$key${NC}, Value: ${data[$key]}, Time: ${times[$key]}"
    else
        echo "Key: $key, Value: ${data[$key]}, Time: ${times[$key]}"
    fi
done

slowest_results=()
for key in "${!times[@]}"; do
    slowest_results+=("$key ${times[$key]}")
done

# Sort the results by time (last column) in descending order
IFS=$'\n' sorted_slowest=($(sort -k2 -n <<< "${slowest_results[*]}"))
unset IFS

# Print the slowest results
echo -e "\nSlowest Results:"
for result in "${sorted_slowest[@]}"; do
    key=$(echo "$result" | awk '{print $1}')
    time=$(echo "$result" | awk '{print $2}')
    echo "Key: $key, Time: $time seconds"
done
