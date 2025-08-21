#!/bin/ash

# Start cron service
rc-service crond start

# Start Apache in the foreground (keeps the container alive)
#apachectl -D FOREGROUND

mkdir -p /var/www/html/filestore/system/slideshow
chmod 777 /var/www/html/filestore/system/slideshow
cp /tmp/1.jpg /var/www/html/filestore/system/slideshow

httpd -DFOREGROUND
