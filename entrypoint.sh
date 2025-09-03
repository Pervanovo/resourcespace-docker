#!/bin/ash

# Start cron service
rc-service crond start

# Start Apache in the foreground (keeps the container alive)
#apachectl -D FOREGROUND

mkdir -p /var/www/html/filestore/system/slideshow
chown -R apache:apache /var/www/html/filestore/system
chmod -R 777 /var/www/html/filestore/system
cp /tmp/1.jpg /var/www/html/filestore/system/slideshow
chown apache:apache /var/www/html/filestore/system/slideshow/1.jpg

#<IfModule mpm_prefork_module>
#    StartServers             5
#    MinSpareServers          5
#    MaxSpareServers         10
#    MaxRequestWorkers      250
#    MaxConnectionsPerChild   0
#</IfModule>


SS="${HTTPD_START_SERVERS:-5}"
sed -i -e "s/StartServers\s\+\d\+/StartServers ${SS}/g" /etc/apache2/conf.d/mpm.conf
MIN_SS="${HTTPD_MIN_SPARE_SERVERS:-5}"
sed -i -e "s/MinSpareServers\s\+\d\+/MinSpareServers ${MIN_SS}/g" /etc/apache2/conf.d/mpm.conf
MAX_SS="${HTTPD_MAX_SPARE_SERVERS:-10}"
sed -i -e "s/MaxSpareServers\s\+\d\+/MaxSpareServers ${MAX_SS}/g" /etc/apache2/conf.d/mpm.conf
MAX_RW="${HTTPD_MAX_REQUEST_WORKERS:-250}"
sed -i -e "s/MaxRequestWorkers\s\+\d\+/MaxRequestWorkers ${MAX_RW}/g" /etc/apache2/conf.d/mpm.conf

cat /etc/apache2/conf.d/mpm.conf

if [[ ! -z "${ULIMIT}" ]]; then
  ulimit -m ${ULIMIT}
  ulimit -a
fi

httpd -DFOREGROUND
