FROM php:8.1.5-apache
 
# Configure apache2 and php
RUN a2enmod headers
RUN a2enmod rewrite
COPY vhost.conf /etc/apache2/sites-enabled/000-default.conf
COPY php.ini /usr/local/etc/php/php.ini
 
RUN apt update && apt upgrade -y
RUN apt install wget git curl -y
 
# Install php extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd xdebug calendar redis zip sockets bz2 mysqli pdo_mysql intl
 
#Install node
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs
 
#Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
#RUN chmod +x /usr/local/bin/composer
 
# Localizations
RUN apt update && apt install locales -y
RUN sed -i -e \
  's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen \
   && locale-gen
# ENV LANG ru_RU.UTF-8
# ENV LANGUAGE ru_RU:ru
# ENV LC_LANG ru_RU.UTF-8
# ENV LC_ALL ru_RU.UTF-8