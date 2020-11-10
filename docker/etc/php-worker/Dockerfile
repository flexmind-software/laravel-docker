ARG PHP_VERSION

FROM php:${PHP_VERSION}

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

RUN set -xe; \
    apt-get update -o Acquire::Check-Valid-Until=false -yqq && apt-get install -yqq \
    curl \
    dnsutils \
    gdb \
    mc \
    git \
    htop \
    iputils-ping \
    ltrace \
    make \
    procps \
    strace \
    sudo \
    sysstat \
    unzip \
    vim \
    wget \
    apt-transport-https \
    supervisor \
;

# always run apt update when start and after add new source list, then clean up at end.
RUN set -xe; \
    apt-get update -yqq \
    && pecl channel-update pecl.php.net \
    && apt-get install -yqqqq apt-utils libzip-dev zip unzip wget \
    && docker-php-ext-configure zip --with-libzip  \
    && docker-php-ext-install zip && php -m | grep -q 'zip'

USER root

RUN rm /etc/apt/preferences.d/no-debian-php  \
    && apt-get -y install libxml2-dev php-soap  \
    && docker-php-ext-install soap

RUN apt-get -y install libxslt-dev
RUN docker-php-ext-install xsl

RUN docker-php-ext-install bcmath
RUN apt-get install -yqq libgmp-dev
RUN docker-php-ext-install gmp
RUN docker-php-ext-install exif

RUN docker-php-ext-install opcache
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

RUN apt-get install -yqq zlib1g-dev libicu-dev g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

USER root
RUN apt-get install -yqq jpegoptim optipng pngquant gifsicle

USER root
RUN apt-get install -yqq libmagickwand-dev imagemagick \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN apt-get install -y libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-xpm-dir=/usr/include/ --with-webp-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN apt-get install -yqq libc-client-dev libkrb5-dev \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

RUN pecl install apcu   \
    && pecl install apcu_bc   \
    && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini   \
    && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini

USER root
RUN apt-get update -yqq && apt-get install libyaml-dev -yqq \
    && pecl install yaml  \
    && docker-php-ext-enable yaml

ARG ADDITIONAL_LOCALES
RUN apt-get install -yqq locales   \
    && echo '' >> /usr/share/locale/locale.alias \
    && temp="${ADDITIONAL_LOCALES%\"}" \
    && temp="${temp#\"}" \
    && for i in ${temp}; do sed -i "/$i/s/^#//g" /etc/locale.gen; done \
    && locale-gen

USER root
RUN apt-get -yqq update \
    && apt-get -yqq install php-zmq

#--------------------------------------------------------------------------
# Optional Software's Installation
#--------------------------------------------------------------------------

ARG INSTALL_MONGODB=false
RUN if [ ${INSTALL_MONGODB} = true ]; then \
    pecl install mongodb \
        && docker-php-ext-enable mongodb \
;fi

ARG INSTALL_MYSQL=false
RUN if [ ${INSTALL_MYSQL} = true ]; then \
   docker-php-ext-install pdo pdo_mysql \
       && docker-php-ext-install mysqli \
;fi

ARG INSTALL_POSTGRESQL=false
RUN if [ ${INSTALL_POSTGRESQL} = true ]; then \
   docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
       && docker-php-ext-install pgsql pdo_pgsql  \
;fi

ARG INSTALL_GULP=false
ARG INSTALL_BOWER=false
ARG NPM_REGISTRY=false
ARG NODE_VERSION=node
ENV NODE_VERSION ${NODE_VERSION}
ARG INSTALL_NODE=false
ENV NVM_DIR /home/docker/.nvm

RUN if [ ${INSTALL_NODE} = true ]; then \
    # Install nvm (A Node Version Manager)
    mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
        && . $NVM_DIR/nvm.sh \
        && nvm install ${NODE_VERSION} \
        && nvm use ${NODE_VERSION} \
        && nvm alias ${NODE_VERSION} \
        && if [ ${NPM_REGISTRY} ]; then \
        npm config set registry ${NPM_REGISTRY} \
        ;fi \
        && if [ ${INSTALL_NPM_GULP} = true ]; then \
        npm install -g gulp \
        ;fi \
        && if [ ${INSTALL_NPM_BOWER} = true ]; then \
        npm install -g bower \
        ;fi \
        && ln -s `npm bin --global` /home/docker/.node-bin \
;fi

ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
   pecl install xdebug \
       && docker-php-ext-enable xdebug \
;fi

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN set -xe; php -v | head -n 1 | grep -q "PHP ${PHP_VERSION}."

ARG INSTALL_WKHTMLTOPDF=false
RUN if [ ${INSTALL_WKHTMLTOPDF} = true ]; then \
    # Install all dependencies
    apt-get install -y \
    libxrender1 \
    libfontconfig1 \
    libx11-dev \
    libjpeg62 \
    libxtst6 \
    wget \
    && wget https://github.com/h4cc/wkhtmltopdf-amd64/blob/master/bin/wkhtmltopdf-amd64?raw=true -O /usr/local/bin/wkhtmltopdf \
    && chmod +x /usr/local/bin/wkhtmltopdf \
;fi

USER root
ARG INSTALL_FAKETIME=false
RUN if [ ${INSTALL_FAKETIME} = true ]; then \
    apt-get install -y libfaketime \
;fi

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

USER root
RUN php -d memory_limit=-1 /usr/local/bin/composer global require phpunit/phpunit --dev
RUN php -d memory_limit=-1 /usr/local/bin/composer global require edgedesign/phpqa --dev
RUN php -d memory_limit=-1 /usr/local/bin/composer global require friendsofphp/php-cs-fixer --dev
RUN php -d memory_limit=-1 /usr/local/bin/composer global require phpstan/phpstan --dev
#RUN php -d memory_limit=-1 /usr/local/bin/composer global require vimeo/psalm --dev
RUN php -d memory_limit=-1 /usr/local/bin/composer global require sensiolabs/security-checker --dev
RUN php -d memory_limit=-1 /usr/local/bin/composer global require jakub-onderka/php-parallel-lint --dev
RUN php -d memory_limit=-1 /usr/local/bin/composer global require nette/neon --dev
RUN php -d memory_limit=-1 /usr/local/bin/composer global require "squizlabs/php_codesniffer=*" --dev

RUN apt-get update -yqq && apt-get install -yqq php-codesniffer

COPY ./scripts/ /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

RUN apt-get update -yqq && apt-get install -yq git-flow

# Clean up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm /var/log/lastlog /var/log/faillog

RUN usermod -u 1000 www-data

WORKDIR /var/www/html

# Adding the faketime library to the preload file needs to be done last
# otherwise it will preload it for all commands that follow in this file
RUN if [ ${INSTALL_FAKETIME} = true ]; then \
    echo "/usr/lib/x86_64-linux-gnu/faketime/libfaketime.so.1" > /etc/ld.so.preload \
;fi

COPY supervisord.conf /etc/supervisord.conf
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]

RUN php -v | head -n 1 | grep -q "PHP ${PHP_VERSION}."

# Clean up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm /var/log/lastlog /var/log/faillog

WORKDIR /etc/supervisor/conf.d/
