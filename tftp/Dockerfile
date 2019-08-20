FROM alpine:3.10
RUN apk add --no-cache tftp-hpa
VOLUME /srv/tftp
EXPOSE 69/udp
ENTRYPOINT ["in.tftpd"]
CMD ["-L", "--secure", "/srv/tftp"]
