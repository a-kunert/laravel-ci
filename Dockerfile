FROM aaronkunert/php-nginx-base:php8.1-nginx1.22.0-alpine3.16 as base


FROM base as composer-dependencies
ENV PATH="/composer/vendor/bin:$PATH"
ARG COMPOSER_ALLOW_SUPERUSER=1
ARG COMPOSER_HOME=/composer
WORKDIR /var/tmp
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer --version --ansi --no-interaction
COPY composer.json composer.lock ./
RUN composer install --no-scripts --ansi --no-interaction --no-autoloader


FROM node:18-alpine3.16 as npm-dependencies
WORKDIR /var/tmp
COPY *.json *.yml *.js ./
COPY ./resources ./resources
COPY --from=composer-dependencies /var/tmp/vendor ./vendor
RUN npm ci
RUN npm run build


FROM composer-dependencies as source
WORKDIR /var/www/app

## PHP-FPM config
ENV FPM_PM_MAX_CHILDREN=20 \
    FPM_PM_START_SERVERS=2 \
    FPM_PM_MIN_SPARE_SERVERS=1 \
    FPM_PM_MAX_SPARE_SERVERS=3
COPY ./docker/production/docker-php-* /usr/local/bin
RUN chmod 774 /usr/local/bin/docker-php-*
RUN dos2unix /usr/local/bin/docker-php-entrypoint

## Nginx-Config
COPY ./docker/production/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/production/default.conf /etc/nginx/conf.d/default.conf

# COPY dependencies
COPY --from=composer-dependencies /var/tmp/vendor ./vendor
COPY --from=npm-dependencies /var/tmp/public/build ./public/build
COPY . .
RUN composer dump-autoload -o  \
    && chown -R :www-data /var/www/app \
    && chmod -R 775 /var/www/app/storage /var/www/app/bootstrap/cache
EXPOSE 80


FROM source as testing
COPY ./docker/testing/.env.ci .env
RUN php artisan key:generate
RUN php artisan config:clear
RUN php artisan config:cache
CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisord.conf"]


FROM source as production
CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisord.conf"]







