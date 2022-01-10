echo "starting indexer"
date
algorand-indexer import
algorand-indexer daemon

while true; do echo "hello indexer" `date`; sleep 600;done