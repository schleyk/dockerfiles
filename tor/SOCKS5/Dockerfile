FROM ubuntu:focal

# Base packages
RUN apt update && apt-get -y install tor torsocks ntpdate libssl-dev && rm -rf /var/lib/apt/lists/*

# init script
ADD ./init.sh /init.sh
RUN chmod +x /init.sh

# Tor Config
ADD ./torrc /etc/tor/torrc

# Configuration files and data output folder
ENTRYPOINT ["/init.sh"]
