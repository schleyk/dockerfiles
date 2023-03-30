#!/bin/bash
chown root:root /data
chmod 700 /data
tor -f /etc/tor/torrc & nginx & sleep infinity