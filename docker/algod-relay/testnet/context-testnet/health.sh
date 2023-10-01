check="Sync Time: 0.0s"
result=`goal node status | grep "$check"`
if [ "$result" = "$check" ]; then
   echo "0"
   exit 0
else
   echo "1"
   exit 1
fi
