Add Patch file:



diff --git a/mainline/alpine/Dockerfile b/mainline/alpine/Dockerfile
index 112b81d..9bce7a9 100644
--- a/mainline/alpine/Dockerfile
+++ b/mainline/alpine/Dockerfile
@@ -1,4 +1,4 @@
-FROM alpine:3.8
+FROM alpine:edge
 
 LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"
 
@@ -52,6 +52,7 @@ RUN GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 \
        " \
        && addgroup -S nginx \
        && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
+       && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
        && apk add --no-cache --virtual .build-deps \
                gcc \
                libc-dev \