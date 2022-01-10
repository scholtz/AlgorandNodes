echo "starting indexer"
date
if [ -z "$ALGOD_DATA_DIR" ]; then
   algorand-indexer -P "$PG_CONN_STR" --algod-net="$ALGOD_HOST" ---algod-token="$ALGOD_TOKEN"
else
   algorand-indexer -P "$PG_CONN_STR" --algod="$ALGOD_DATA_DIR"
fi