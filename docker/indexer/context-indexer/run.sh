echo "starting indexer"
date
sleep 1
algorand-indexer daemon

while true; do echo "hello indexer" `date`; sleep 600;done