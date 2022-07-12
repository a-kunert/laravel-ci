FROM ubuntu:20.04

WORKDIR /var/www/html

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update \
    && apt-get install -y  \
        curl  \
        unzip  \
        git  \
        mysql-client \
    && apt-get install -y \
        php8.1-cli \
        php8.1-gd \
        php8.1-ldap \
        php8.1-mbstring \
        php8.1-mysql \
        php8.1-pgsql \
        php8.1-sqlite3 \
        php8.1-xml \
        php8.1-xsl \
        php8.1-zip \
        php8.1-curl \
        php8.1-soap \
        php8.1-gmp \
        php8.1-bcmath \
        php8.1-intl \
        php8.1-imap \
        php8.1-phpdbg \
        php8.1-bz2 \
        php8.1-redis \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV COMPOSER_HOME=/composer
ENV PATH=./vendor/bin:/composer/vendor/bin:/root/.yarn/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g yarn


# RUN setcap "cap_net_bind_service=+ep" /usr/bin/php8.1

COPY php.ini /etc/php/8.1/cli/conf.d/99-laravel.ini

# EXPOSE 8000

ENTRYPOINT ["php","artisan","serve","--host=0.0.0.0","--port=80"]
