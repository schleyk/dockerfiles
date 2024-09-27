## Features
- based on alpine:3.19
- install Tor from official apt source
- not run as root
- include nyx

## Install and Setup Tor Config
chown -R 1001:1001 tor/
chmod -R 700 tor/

## Set Tor mode
torrc.relay
torrc.socks5

## nice to know
docker-compose exec tor nyx

##  Tuning /etc/sysctl.conf for network, memory and CPU load
```
net.ipv4.tcp_fin_timeout = 20
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000

```
if you run tor with min RAM:
```
vm.vfs_cache_pressure=50
vm.swappiness=100
```