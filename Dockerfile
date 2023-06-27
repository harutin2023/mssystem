FROM php:8.1-fpm as base

RUN apt update \
    && apt install -y zlib1g-dev g++ git libicu-dev zip libzip-dev zip libpq-dev npm python3 \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install intl opcache pdo pdo_pgsql \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip 
	
# php8-dev
RUN update-ca-certificates
# install php composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN git clone https://github.com/harutin2023/msbackend.git core
RUN git clone https://github.com/harutin2023/msfront.git manager

FROM base as core
WORKDIR ./core/
RUN composer install \
    php -S localhost:8080 -t public public/index.php

FROM base as manager
WORKDIR ./manager/	
RUN npm install --production
