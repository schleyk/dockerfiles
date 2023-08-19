FROM ubuntu:mantic

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
