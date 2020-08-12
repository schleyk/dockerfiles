FROM ubuntu:focal

RUN apt update && apt-get -y install nginx tor torsocks ntpdate libssl-dev && rm -rf /var/lib/apt/lists/*

# Configure nginx logs to go to Docker log collection (via stdout/stderr)
RUN ln --symbolic --force /dev/stdout /var/log/nginx/access.log
RUN ln --symbolic --force /dev/stderr /var/log/nginx/error.log

ADD ./main.sh /main.sh
ADD ./torrc /etc/tor/torrc
ADD ./nginx.conf /etc/nginx/nginx.conf

VOLUME /data
WORKDIR /data

ENTRYPOINT ["/main.sh"]
