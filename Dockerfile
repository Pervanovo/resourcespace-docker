FROM alpine:latest

LABEL org.opencontainers.image.authors="Montala Ltd"

ENV DEBIAN_FRONTEND="noninteractive"

RUN apk add --no-cache \
    openrc \
    busybox-openrc \
    vim \
    less \
    imagemagick \
    apache2 \
    subversion \
    ghostscript \
    antiword \
    poppler-utils \
    postfix \
    wget \
    mysql-client \
    exiftool \
    ffmpeg \
    python3 \
    py3-pip
#perl-image-exiftool
RUN apk add --no-cache \
    php83 \
    php83-apcu \
    php83-curl \
    php83-dev \
    php83-gd \
    php83-intl \
    php83-iconv \
    php83-mysqlnd \
    php83-mysqli \
    php83-mbstring \
    php83-zip \
    php83-apache2 \
    php83-ctype \
    php83-dom \
    php83-xml

# fix work iconv library with alphine
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN apk --no-cache add shadow && \
    groupmod --gid 33 www-data && \
    usermod --uid 33 --gid 33 apache && \
    apk del shadow

WORKDIR /var/www/html

RUN rm -f index.html \
 && svn co -q https://svn.resourcespace.com/svn/rs/releases/10.6 . \
 && mkdir -p filestore \
 && chmod 777 filestore \
 && chmod -R 777 include/

RUN chown -R apache:apache /var/www/html

RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php83/php.ini \
 && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php83/php.ini \
 && sed -i -e "s/max_execution_time\s*=\s*30/max_execution_time = 300/g" /etc/php83/php.ini \
 && sed -i -e "s/memory_limit\s*=\s*128M/memory_limit = 1G/g" /etc/php83/php.ini

RUN printf '<Directory /var/www/>\n\
\tOptions -Indexes +FollowSymLinks\n\
</Directory>\n'\
>> /etc/apache2/conf.d/default.conf

RUN sed -i -e "s/\/var\/www\/localhost\/htdocs/\/var\/www\/html/g" /etc/apache2/httpd.conf
RUN sed -i -e "s/Options Indexes FollowSymLinks/Options -Indexes +FollowSymLinks/g" /etc/apache2/httpd.conf

ADD cronjob /etc/periodic/daily/resourcespace
RUN chmod +x /etc/periodic/daily/resourcespace

ADD config.php /var/www/html/include/config.php

# FIXME old version, but stdout option has been broken ever since...
ENV DOCKERIZE_VERSION v0.6.1
RUN wget -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin

# add slideshow image to be copied by the entrypoint
ADD 1.jpg /tmp

# Copy custom entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN touch /var/log/apache2/access.log /var/log/apache2/error.log

# Start both cron and Apache
CMD dockerize -stdout /var/log/apache2/access.log -stderr /var/log/apache2/error.log -poll /entrypoint.sh

EXPOSE 80
