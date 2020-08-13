FROM ubuntu:focal

# Base packages
RUN apt update && apt-get -y install nginx tor torsocks ntpdate libssl-dev && rm -rf /var/lib/apt/lists/*

# Configure nginx logs to go to Docker log collection (via stdout/stderr)
RUN ln --symbolic --force /dev/stdout /var/log/nginx/access.log
RUN ln --symbolic --force /dev/stderr /var/log/nginx/error.log

# init script
ADD ./init.sh /init.sh
RUN chmod +x /init.sh

# Tor Config
ADD ./torrc /etc/tor/torrc

# Add nginx default configuration
ADD ./nginx.conf /etc/nginx/nginx.conf

# Configuration files and data output folder
VOLUME /data
WORKDIR /data

ENTRYPOINT ["/init.sh"]
