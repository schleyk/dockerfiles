
## Features:
- based on alpine:3.21
- install tor from official apt source
- not run as root
- include nyx
- Incllude Realy / Socks5 / OBFS4 / Hidden Service

## Install and Setup Tor Config:
```
chown -R 1001:1001 tor 
chmod -R 700 tor
```

## Set Tor mode and rename to "torrc":
```
torrc.relay
torrc.socks5
torrc.obfs4
torrc.hidden
```

## build own custom hidden onion domain:
go to **mkp224o** folder and build mkp224o tool
```
docker build --rm -t mkp224o .
```
 generate your onion domain with ***test*** prefix
```
docker run --rm -v $(pwd)/out:/out mkp224o test -d /out
```
copy your custom onion from folder  **out** to ***./tor/data/*** and add to ***torrc*** 
and dont forget to fix your file permissions ;)
## Tor Status:
```
docker-compose exec tor nyx
```

##  Tuning /etc/sysctl.conf for network, memory and CPU load:
```
net.ipv4.tcp_fin_timeout = 20
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000

```
### if you run tor with min RAM:
```
vm.vfs_cache_pressure=50
vm.swappiness=100
```
