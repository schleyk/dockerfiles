FROM debian:bookworm

RUN apt update && apt-get -y install wget apt-transport-https ca-certificates gpg
COPY tor.list /etc/apt/sources.list.d/
ADD https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc /tmp/
RUN cat /tmp/*.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg

# Base packages
RUN apt update && apt-get -y install tor torsocks ntpdate libssl-dev python3 pip && rm -rf /var/lib/apt/lists/*
RUN pip install nyx --break-system-packages

# init script
ADD ./init.sh /init.sh
RUN chmod +x /init.sh

# Create a new user tor
ARG UID=1001
ARG GID=1001
RUN groupadd --gid $GID tor
RUN useradd --system --create-home --shell /usr/sbin/nologin --uid $UID --gid $GID tor

# Run with user tor
USER tor

# Configuration files and data output folder
ENTRYPOINT ["/init.sh"]
