###
# DOWNLOAD

FROM alpine AS source
RUN apk add --no-cache git
RUN git clone --recursive https://github.com/cathugger/mkp224o.git /usr/src/mkp224o

###
# BUILD

FROM alpine AS builder
RUN apk add --no-cache alpine-sdk autoconf libsodium-dev
COPY --from=source /usr/src/mkp224o/ /usr/src/mkp224o/
WORKDIR /usr/src/mkp224o/

RUN ./autogen.sh
#RUN ./configure --enable-amd64-51-30k --prefix=/target/
RUN ./configure --enable-donna
RUN make -j$(nproc)

###
# FINAL IMAGE

FROM alpine
RUN apk add --no-cache libsodium
COPY --from=builder /usr/src/mkp224o/mkp224o /usr/local/bin/
STOPSIGNAL TERM
ENTRYPOINT ["mkp224o"]
