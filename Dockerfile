FROM php:7.3-fpm

WORKDIR /var/www

RUN usermod -u 1000 www-data

RUN apt-get update
RUN apt-get install -y \
    cron \
    supervisor \
    nano \
    curl \
    wget \
    git \
    zip \
    unzip \
    iputils-ping \
    libicu-dev \
    libpq-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    gnupg

# wkhtmltopdf
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN tar -xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN cp wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf
RUN rm wkhtmltox-0.12.4_linux-generic-amd64.tar.xz

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# php extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install gd
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install intl

# php.ini
RUN echo "date.timezone=Europe/Warsaw" >> /usr/local/etc/php/conf.d/docker-php-custom.ini
RUN echo "error_reporting=E_ALL & ~E_DEPRECATED & ~E_STRICT" >> /usr/local/etc/php/conf.d/docker-php-custom.ini
RUN echo "display_errors=Off" >> /usr/local/etc/php/conf.d/docker-php-custom.ini
RUN echo "max_execution_time=300" >> /usr/local/etc/php/conf.d/docker-php-custom.ini
RUN echo "memory_limit = 2048M" >> /usr/local/etc/php/conf.d/docker-php-custom.ini

RUN echo "upload_max_filesize=100M" >> /usr/local/etc/php/conf.d/docker-php-custom.ini
RUN echo "post_max_size=100M" >> /usr/local/etc/php/conf.d/docker-php-custom.ini

RUN echo "opcache.max_accelerated_files = 20000" >> /usr/local/etc/php/conf.d/docker-php-custom.ini
RUN echo "realpath_cache_size = 4096K" >> /usr/local/etc/php/conf.d/docker-php-custom.ini
RUN echo "realpath_cache_ttl = 600" >> /usr/local/etc/php/conf.d/docker-php-custom.ini

#clean
RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
