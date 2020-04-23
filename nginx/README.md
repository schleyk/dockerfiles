
#Fix CVE-2020-1967
https://www.openssl.org/news/secadv/20200421.txt

nginx version: nginx/1.18.0
built by gcc 9.3.0 (Alpine 9.3.0)
built with OpenSSL 1.1.1g  21 Apr 2020
TLS SNI support enabled
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-http_xslt_module=dynamic --with-http_image_filter_module=dynamic --with-http_geoip_module=dynamic --with-threads --with-stream --with-stream_ssl_module --with-stream_ssl_preread_module --with-stream_realip_module --with-stream_geoip_module=dynamic --with-http_slice_module --with-mail --with-mail_ssl_module --with-compat --with-file-aio --with-http_v2_module


#Add Patch file:

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