FROM php:7.4.30-apache-buster

ENV TZ "Europe/Berlin"
ENV ACCEPT_EULA=Y
ARG DEBIAN_FRONTEND=noninteractive
ARG S6=3.1.0.1

# Update
RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get --no-install-recommends install -y apt-utils curl gnupg gnupg1 gnupg2 && \
    rm -rf /var/lib/apt/lists/*

# Add Custom APT Repo
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install useful tools and install important libaries
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install nano wget tzdata msmtp cron dialog libsqlite3-dev libsqlite3-0 locales apt-transport-https libldap2-dev && \
    apt-get -y --no-install-recommends install default-mysql-client zlib1g-dev libzip-dev libicu-dev && \
    apt-get -y --no-install-recommends install --fix-missing apt-utils build-essential git curl libonig-dev && \
    apt-get -y --no-install-recommends install --fix-missing libcurl4 libcurl4-openssl-dev zip openssl imagemagick libmagickwand-dev unixodbc-dev msodbcsql17 && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Update timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install S6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v$S6/s6-overlay-x86_64.tar.xz /tmp/
RUN tar xvJf /tmp/s6-overlay-x86_64.tar.xz -C / && rm /tmp/s6-overlay-x86_64.tar.xz

# Install xdebug
#RUN pecl install xdebug-stable && \
#    docker-php-ext-enable xdebug

# Install MSSQL
RUN docker-php-ext-install mbstring pdo pdo_mysql \
    && pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

# Install redis
RUN pecl install redis-stable && \
    docker-php-ext-enable redis

# Install Freetype
RUN apt-get -y update && \
    apt-get --no-install-recommends install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# ImageMagick
RUN pecl install imagick-stable && \
    docker-php-ext-enable imagick

# LDAP
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap

# Other PHP7 Extensions
RUN docker-php-ext-install pdo_mysql && \
    docker-php-ext-install pdo_sqlite && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install curl && \
    docker-php-ext-install tokenizer && \
    docker-php-ext-install json && \
    docker-php-ext-install zip && \
    docker-php-ext-install -j$(nproc) intl && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install gettext

# Enable opcache (path is dynamic depending on PHP API version)
RUN printf "zend_extension=%s\n" /usr/local/lib/php/extensions/no-debug-non-zts-*/opcache.so > "$PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini"

# Enable PHP Sendmmail with mSMTP and add timezone
RUN echo "sendmail_path = "/usr/bin/msmtp -t"" > "$PHP_INI_DIR/conf.d/docker-php-ext-sendmail.ini" && \
    echo date.timezone = "$TZ" > "$PHP_INI_DIR/conf.d/docker-php-ext-timezone.ini"

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Enable apache modules
RUN a2enmod rewrite headers expires

# Cleanup
RUN rm -rf /usr/src/*

COPY rootfs/ /

# Start S6 init
ENTRYPOINT ["/init"]