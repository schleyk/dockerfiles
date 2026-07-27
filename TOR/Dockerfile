FROM alpine:3.24

RUN apk upgrade --no-cache \
  && apk add --update --no-cache \
  bash \
  tor \
  torsocks \
  nyx \
  && adduser --disabled-password --uid 1001 tor

# init script
COPY ./init.sh /init.sh
RUN chmod +x /init.sh

# Run with user tor
USER tor

# Configuration files and data output folder
ENTRYPOINT ["/init.sh"]

HEALTHCHECK --interval=60s --timeout=10s --start-period=60s --retries=3 \
  CMD bash -c 'echo > /dev/tcp/127.0.0.1/9001' || exit 1
