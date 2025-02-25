FROM alpine:3.21

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