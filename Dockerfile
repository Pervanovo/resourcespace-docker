FROM alpine:3.24.4 AS iconv-builder

RUN apk add --no-cache \
    php83 \
    php83-dev \
    php83-iconv \
    gnu-libiconv-dev \
    build-base \
    curl

# Prefer GNU libiconv headers
RUN cp /usr/include/gnu-libiconv/iconv.h /usr/include/iconv.h

WORKDIR /tmp

# Download sources matching the installed PHP version
RUN PHPVER="$(php83 -r 'echo PHP_VERSION;')" \
    && curl -fsSL \
       "https://www.php.net/distributions/php-${PHPVER}.tar.gz" \
       -o php.tar.gz \
    && tar xzf php.tar.gz \
    && ln -s "/tmp/php-${PHPVER}/ext/iconv" /tmp/iconv-src

WORKDIR /tmp/iconv-src

RUN phpize83 \
    && LIBS="-liconv" ./configure \
       --with-php-config=/usr/bin/php-config83 \
       --with-iconv=/usr \
    && make -j"$(nproc)" \
    && install -Dm755 modules/iconv.so /out/iconv.so

FROM alpine:3.24.4

RUN apk upgrade --no-cache

LABEL org.opencontainers.image.authors="Montala Ltd"

ENV DEBIAN_FRONTEND="noninteractive"

RUN apk add --no-cache \
    cronie \
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
    moreutils \
    mysql-client \
    exiftool \
    ffmpeg \
    python3 \
    gnu-libiconv-libs \
    py3-pip
#perl-image-exiftool
RUN apk add --no-cache \
    php83 \
    php83-pecl-apcu \
    php83-curl \
    php83-dev \
    php83-gd \
    php83-intl \
    php83-mysqlnd \
    php83-mysqli \
    php83-mbstring \
    php83-zip \
    php83-apache2 \
    php83-ctype \
    php83-dom \
    php83-xml \
    php83-iconv

RUN ln -s /usr/bin/php83 /usr/bin/php

COPY --from=iconv-builder \
    /out/iconv.so \
    /usr/lib/php83/modules/iconv.so

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
RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf

RUN mkdir /etc/periodic/1min && echo -e "*\t*\t*\t*\t*\trun-parts /etc/periodic/1min" >> /var/spool/cron/crontabs/root
RUN mkdir /etc/periodic/5min && echo -e "*/5\t*\t*\t*\t*\trun-parts /etc/periodic/5min" >> /var/spool/cron/crontabs/root

ADD offline_jobs.sh /etc/periodic/1min
RUN chmod +x /etc/periodic/1min/offline_jobs.sh

ADD cronjob /etc/periodic/daily/resourcespace
RUN chmod +x /etc/periodic/daily/resourcespace

ADD config.php /var/www/html/include/config.php

# FIXME old version, but stdout option has been broken ever since...
ENV DOCKERIZE_VERSION="v0.6.1"
RUN wget -q -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin

# add slideshow image to be copied by the entrypoint
ADD 1.jpg /tmp
RUN mkdir /tmp/resourcespace && chown -R apache:apache /tmp/resourcespace

# Copy custom entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN touch \
    /var/log/apache2/access.log \
    /var/log/apache2/error.log \
    /var/log/offline_jobs.log

# Start both cron and Apache
CMD ["dockerize", "-stdout", "/var/log/apache2/access.log", "-stdout", "/var/log/offline_jobs.log", "-stderr", "/var/log/apache2/error.log", "-poll", "/entrypoint.sh"]

EXPOSE 80
