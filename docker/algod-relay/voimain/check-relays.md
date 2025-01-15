# Job to check the other relays performance

```
mkdir ~/voi-relay-tracking

cd ~/voi-relay-tracking

wget https://raw.githubusercontent.com/scholtz/AlgorandNodes/refs/heads/main/docker/algod-relay/voimain/check-relays.sh

chmod +x check-relays.sh
```

Test it with

```
./check-relays.sh
```

This will create data folder with year and month folders. In the folder will be the latest report.

### Schedule it

```
crontab -e
```

Replace 13 with random minute.

```
13 * * * * cd ~/voi-relay-tracking && ./check-relays.sh >> out.txt 2>&1
```
