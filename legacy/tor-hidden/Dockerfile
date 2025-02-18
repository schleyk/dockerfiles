FROM ubuntu:mantic

# Base packages
RUN apt update && apt-get -y install tor torsocks ntpdate libssl-dev nginx python3 pip && rm -rf /var/lib/apt/lists/*
RUN pip install nyx --break-system-packages

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

# Create a new user tor
ARG UID=1001
ARG GID=1001
RUN groupadd --gid $GID tor
RUN useradd --system --create-home --shell /usr/sbin/nologin --uid $UID --gid $GID tor

# Run with user tor
USER tor

ENTRYPOINT ["/init.sh"]
