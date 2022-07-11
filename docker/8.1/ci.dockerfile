FROM ubuntu:20.04
# LABEL maintainer="Taylor Otwell"

# ARG NODE_VERSION=16
# ARG POSTGRES_VERSION=14

WORKDIR /var/www/html

ARG DEBIAN_FRONTEND=noninteractive
# ENV TZ=UTC

RUN apt-get update && apt-get install -y software-properties-common
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update \
    && apt-get install -y  \
#        gnupg  \
#        gosu  \
        curl  \
        ca-certificates  \
        zip  \
        unzip  \
        git  \
#        supervisor  \
        sqlite3  \
        libcap2-bin  \
        libpng-dev  \
        python2 \
        mysql-client \
#    && mkdir -p ~/.gnupg \
#    && chmod 600 ~/.gnupg \
#    && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
#    && echo "keyserver hkp://keyserver.ubuntu.com:80" >> ~/.gnupg/dirmngr.conf \
#    && gpg --recv-key 0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c \
#    && gpg --export 0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c > /usr/share/keyrings/ppa_ondrej_php.gpg \
#    && echo "deb [signed-by=/usr/share/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
#    && apt-get update \
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
  #  && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
  #  && curl -sLS https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
  #  && apt-get install -y nodejs \
  #  && npm install -g npm \
  #  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarn.gpg >/dev/null \
  #  && echo "deb [signed-by=/usr/share/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  #  && curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /usr/share/keyrings/pgdg.gpg >/dev/null \
  #  && echo "deb [signed-by=/usr/share/keyrings/pgdg.gpg] http://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  #  && apt-get update \
 #   && apt-get install -y yarn \
#    && apt-get install -y mysql-client \
  #  && apt-get install -y postgresql-client-$POSTGRES_VERSION \
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


RUN setcap "cap_net_bind_service=+ep" /usr/bin/php8.1

COPY php.ini /etc/php/8.1/cli/conf.d/99-laravel.ini

EXPOSE 8000

ENTRYPOINT ["php","artisan","serve","--host=0.0.0.0","--port=80"]
