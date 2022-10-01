if test -f "/app/data/genesis.json"; then
	goal kmd start
	goal node start
else
	cp sandbox/* data/ -rf

	
	
	goal kmd start
	goal node start
fi

while true; do date; goal node status; sleep 600;done