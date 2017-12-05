FROM alpine:3.2

# define PHP and libiconv version
ENV PHP_VERSION 7.0.2
ENV LIBICONV_VERSION 1.15

# define workdir to home
WORKDIR /install

# install build tools
RUN apk add -U grep build-base tar re2c make file \

	# PHP dependencies
	libxpm-dev libxml2-dev curl-dev freetype-dev \
	openssl-dev libjpeg-turbo-dev libpng-dev libmcrypt-dev \
	libwebp-dev icu-dev imap-dev && \

	# download sources
	curl -SL http://cz1.php.net/get/php-${PHP_VERSION}.tar.gz/from/this/mirror | tar -xz -C ~/ && \
    curl -SL http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz | tar -xz -C ~/ && \
    mv ~/php-${PHP_VERSION} ~/php && mv ~/libiconv-${LIBICONV_VERSION} ~/libiconv && \

	# remove origin iconv
	rm /usr/bin/iconv && \

	# install libiconv from source
	~/libiconv/configure --prefix=/usr/local && \
	make && make install && \

	# install php from source
	~/php/configure --prefix=/usr \
		--with-pic \
		--with-layout=GNU \
		--enable-inline-optimization \
		--disable-phpdbg \
		--disable-cli \
		--enable-cli \
		--enable-cgi \
        --enable-fpm \
		--enable-mbstring \
        --enable-zip \
        --with-curl \
        --with-mcrypt \
        --disable-iconv \
        --with-iconv \
        --with-iconv-dir=/usr/local \
        --with-gd \
        --with-mysql \
        --with-mysqli \
        --with-pdo-mysql \
        --enable-opcache \
        --with-jpeg-dir=/usr \
        --with-webp-dir=/usr \
        --with-png-dir=/usr \
        --with-zlib-dir=/usr \
        --with-xpm-dir=/usr \
        --with-freetype-dir=/usr \
        --enable-gd-native-ttf \
        --enable-gd-jis-conv \
        --with-openssl \
        --with-zlib=/usr \
        --enable-intl \
        --disable-debug \
    	--disable-rpath \
    	--disable-static \
    	--disable-pcntl \
    	--enable-ftp \
    	--enable-shared \
    	--enable-soap \
    	--with-imap \
    	--with-config-file-path=/etc/php \
    	--with-config-file-scan-dir=/etc/php/conf.d \
    	--sysconfdir=/etc/php \
    	--without-pear \
    	--enable-sockets \
    	&& \

    make && make install && \

	# add non-dev PHP dependencies to APK
	apk add -u libxpm libxml2 curl freetype \
    openssl libjpeg-turbo libpng libmcrypt \
    libwebp icu imap && \

	# remove dev PHP dependencies
	apk del grep build-base tar re2c make file \
	libxpm-dev libxml2-dev curl-dev freetype-dev \
    openssl-dev libjpeg-turbo-dev libpng-dev libmcrypt-dev \
    libwebp-dev icu-dev && \

	# clear apk cache
	rm -rf /var/cache/apk/* && \

	# remove sources
	rm -rf ~/php ~/libiconv && rm -rf /install

WORKDIR /

# replace origin iconv
ENV LD_PRELOAD /usr/local/lib/preloadable_libiconv.so

