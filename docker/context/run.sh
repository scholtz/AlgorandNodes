#apt update && apt dist-upgrade -y 


{
	"Version": 22,
	"Archival": true,
	"EnableMetricReporting": true,
	"EnableLedgerService": true,
	"EnableBlockService": true,
	"DNSSecurityFlags": 0,
    "DNSBootstrapID": "aramidmain.a-wallet.net",
	"NetAddress": ":14260",
	"EndpointAddress": "0.0.0.0:18080",
    "FallbackDNSResolverAddress": "aramidmain.a-wallet.net"
}
goal node start 
diagcfg telemetry enable
diagcfg metric enable
#./goal node catchup $catchup -d /root/node/datafastcatchup
#./goal node status -d ~/node/datafastcatchup -w 1000


while true; do echo `date`; goal node status; sleep 600;done