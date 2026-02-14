FROM alpine:3.23

RUN apk upgrade --no-cache \
  && apk add --update --no-cache \
  bash \
  tor \
  torsocks \
  nyx \
  && adduser --disabled-password --uid 1001 torrelay

# init script
COPY ./init.sh /init.sh
RUN chmod +x /init.sh

# Run with user torrelay
USER torrelay

# Configuration files and data output folder
ENTRYPOINT ["/init.sh"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -fk https://217.160.98.239:9001 || exit 1