#!/bin/sh

sed -i -e "s/<APC_SHM_SIZE>/$APC_SHM_SIZE/g" /php/conf.d/apcu.ini \
       -e "s/<OPCACHE_MEM_SIZE>/$OPCACHE_MEM_SIZE/g" /php/conf.d/opcache.ini \
       -e "s/<CRON_MEMORY_LIMIT>/$CRON_MEMORY_LIMIT/g" /etc/s6.d/cron/run \
       -e "s/<CRON_PERIOD>/$CRON_PERIOD/g" /etc/s6.d/cron/run \
       -e "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /usr/local/bin/occ \
       -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /nginx/conf/nginx.conf /php/etc/php-fpm.conf \
       -e "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /php/etc/php-fpm.conf \
       -e "s/<PHP_MAX_CHILDREN>/$PHP_MAX_CHILDREN/g" /php/etc/php-fpm.conf \
       -e "s/<PHP_START_SERVERS>/$PHP_START_SERVERS/g" /php/etc/php-fpm.conf \
       -e "s/<PHP_MIN_SPARE_SERVERS>/$PHP_MIN_SPARE_SERVERS/g" /php/etc/php-fpm.conf \
       -e "s/<PHP_MAX_SPARE_SERVERS>/$PHP_MAX_SPARE_SERVERS/g" /php/etc/php-fpm.conf

# Put the configuration and apps into volumes
ln -sf /config/config.php /nextcloud/config/config.php &>/dev/null
ln -sf /apps2 /nextcloud &>/dev/null
chown -h $UID:$GID /nextcloud/config/config.php /nextcloud/apps2

# Create folder for php sessions if not exists
if [ ! -d /data/session ]; then
  mkdir -p /data/session;
fi

echo "Updating permissions..."
for dir in /nextcloud /data /config /apps2 /var/log /php /nginx /tmp /etc/s6.d; do
  if [ "$dir" = "/data" ] && [ "$CHECK_PERMISSIONS" = "0" ]; then
    echo "WARNING: Skip checking permissions for /data"
    continue
  fi
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    echo "Updating permissions in $dir..."
    chown -R $UID:$GID $dir
#    chown -R 700 /nextcloud
  else
    echo "Permissions in $dir are correct."
  fi
done
echo "Done updating permissions."

if [ "$(find "/etc/ssl/private" -mindepth 1 -print -quit 2>/dev/null)" ]; then
	echo "Installing custom CA certificates for LDAPS..."
	cp /etc/ssl/private/* /etc/ssl/certs/
	update-ca-certificates
else
    echo "no custom CA certificates found..."
fi

if [ ! -f /config/config.php ]; then
    # New installation, run the setup
    /usr/local/bin/setup.sh
else
    occ upgrade
fi

exec su-exec $UID:$GID /usr/bin/s6-svscan /etc/s6.d
