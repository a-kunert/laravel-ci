FROM php:8.1-fpm-alpine3.16 as base

ARG DEBIAN_FRONTEND=noninteractive

ARG NGINX_VERSION=1.22.0
ARG NJS_VERSION=0.7.6
ARG PKG_RELEASE=1
ARG SHA512_KEY="e7fa8303923d9b95db37a77ad46c68fd4755ff935d0a534d26eba83de193c76166c68bfe7f65471bf8881004ef4aa6df3e34689c305662750c0172fca5d8552a *stdin"


ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions  \
    bcmath  \
    gd  \
    igbinary  \
    imagick  \
    imap  \
    intl  \
    ldap  \
    memcached  \
    msgpack \
    mysqli \
    pcntl \
    pdo_mysql \
    pgsql \
    redis  \
    soap  \
    swoole  \
    zip

# RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN apk update && apk add --no-cache \
    zip \
    unzip \
    dos2unix \
    supervisor \
    libpng-dev \
    libzip-dev \
    freetype-dev \
    $PHPIZE_DEPS
   # libjpg-turbo-dev


RUN apk add --no-cache openssl ca-certificates \
    && set -x \
    && nginxPackages="  \
            nginx=${NGINX_VERSION}-r${PKG_RELEASE}  \
            nginx-module-xslt=${NGINX_VERSION}-r${PKG_RELEASE}  \
            nginx-module-geoip=${NGINX_VERSION}-r${PKG_RELEASE} \
            nginx-module-image-filter=${NGINX_VERSION}-r${PKG_RELEASE} \
            nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-r${PKG_RELEASE} \
            " \
    && wget -O /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
    && if [ "$(openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout | openssl sha512 -r)" = "$SHA512_KEY" ]; \
    then \
      echo "key verification succeeded!"; \
      mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/; \
    else \
      echo "key verification failed!"; \
      exit 1; \
    fi \
    && apk add -X "https://nginx.org/packages/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main"  --no-cache $nginxPackages

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord","-n","-c", "/etc/supervisord.conf"]


