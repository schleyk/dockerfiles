# Base docker image
FROM debian:bookworm-slim

LABEL maintainer="Philipp Winter <phw@torproject.org>"

# Install dependencies to add Tor's repository.
RUN apt-get update && apt-get install -y \
    curl \
    gpg \
    gpg-agent \
    ca-certificates \
    libcap2-bin \
    --no-install-recommends

# See: <https://2019.www.torproject.org/docs/debian.html.en>
RUN curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

RUN printf "deb https://deb.torproject.org/torproject.org bookworm main\n" >> /etc/apt/sources.list.d/tor.list

# Install remaining dependencies.
RUN apt-get update && apt-get install -y \
    tor \
    tor-geoipdb \
    --no-install-recommends

RUN printf "deb http://deb.debian.org/debian bookworm-backports main\n" >> /etc/apt/sources.list.d/backports.list
RUN apt-get update && apt-get install -y \
    obfs4proxy \
    --no-install-recommends -t bookworm-backports

# Allow obfs4proxy to bind to ports < 1024.
RUN setcap cap_net_bind_service=+ep /usr/bin/obfs4proxy

# Our torrc is generated at run-time by the script start-tor.sh.
RUN rm /etc/tor/torrc
RUN chown debian-tor:debian-tor /etc/tor
RUN chown debian-tor:debian-tor /var/log/tor

COPY start-tor.sh /usr/local/bin
RUN chmod 0755 /usr/local/bin/start-tor.sh

COPY get-bridge-line /usr/local/bin
RUN chmod 0755 /usr/local/bin/get-bridge-line

USER debian-tor

CMD [ "/usr/local/bin/start-tor.sh" ]
