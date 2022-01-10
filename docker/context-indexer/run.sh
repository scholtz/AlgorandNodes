echo "starting indexer"
date
algorand-indexer import
sleep 1
algorand-indexer daemon
sleep 1
algorand-indexer import
sleep 1
algorand-indexer daemon

while true; do echo "hello indexer" `date`; sleep 600;done