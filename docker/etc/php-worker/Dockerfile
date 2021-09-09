ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

USER root

COPY shared/scripts/install_software.sh /usr/bin/install_software
COPY shared/scripts/install_php_extensions.sh /usr/bin/install_php_extensions
COPY shared/scripts/install_aliases.sh /usr/bin/install_aliases

RUN chmod +x /usr/bin/install_software && install_software
RUN chmod +x /usr/bin/install_php_extensions && install_php_extensions
RUN chmod +x /usr/bin/install_aliases && install_aliases

COPY shared/configs/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY shared/configs/ssh/insecure_id_rsa.pub /root/insecure_id_rsa.pub

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
   apt-get install -y libpq-dev php-pgsql && \
   docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
       && docker-php-ext-install pgsql pdo_pgsql \
;fi

ARG INSTALL_NODE=false
RUN if [ ${INSTALL_NODE} = true ]; then \
   # Install NodeJS using NVM
   curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.38.0/install.sh | bash > /dev/null && \
   export NVM_DIR="$HOME/.nvm" > /dev/null && \
   [ -s "$NVM_DIR/nvm.sh" ] > /dev/null && . "$NVM_DIR/nvm.sh" > /dev/null && \
   nvm install 14 && \
   nvm use node \
   nvm install node-sass; \
   npm rebuild node-sass \
;fi

ARG INSTALL_NPM=true
RUN if [ ${INSTALL_NPM} = true ]; then \
   apt-get -y -qq update && \
      apt-get install -qq -y gnupg build-essential yarn npm \
;fi

ARG INSTALL_GULP=false
RUN if [ ${INSTALL_GULP} = true ]; then \
   npm install -g gulp  \
;fi

ARG INSTALL_BOWER=false
RUN if [ ${INSTALL_BOWER} = true ]; then \
   npm install -g bower  \
;fi

ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
   pecl install xdebug \
       && docker-php-ext-enable xdebug \
;fi

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --2

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
    && wget https://github.com/h4cc/wkhtmltoimage-amd64/blob/master/bin/wkhtmltoimage-amd64?raw=true -O /usr/local/bin/wkhtmltoimage \
    && chmod +x /usr/local/bin/wkhtmltopdf \
    && chmod +x /usr/local/bin/wkhtmltoimage \
;fi

ARG INSTALL_FAKETIME=false
RUN if [ ${INSTALL_FAKETIME} = true ]; then \
    apt-get install -y libfaketime \
;fi

ARG INSTALL_FFMPEG=false
RUN if [ ${INSTALL_FFMPEG} = true ]; then \
    apt-get update -yqq && apt-get install -yqq ffmpeg \
;fi

ARG ADDITIONAL_LOCALES
RUN apt-get install -yqq locales   \
    && echo '' >> /usr/share/locale/locale.alias \
    && temp="${ADDITIONAL_LOCALES%\"}" \
    && temp="${temp#\"}" \
    && for i in ${temp}; do sed -i "/$i/s/^#//g" /etc/locale.gen; done \
    && locale-gen

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

COPY shared/configs/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

RUN php -d memory_limit=-1 /usr/local/bin/composer global require phpunit/phpunit --dev
RUN php -d memory_limit=-1 /usr/local/bin/composer global require friendsofphp/php-cs-fixer --dev
RUN php -d memory_limit=-1 /usr/local/bin/composer global require "squizlabs/php_codesniffer=*" --dev

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

RUN export PATH="./vendor/bin:$PATH"

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisord.d/* /etc/supervisor/conf.d/

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/supervisord.conf"]
WORKDIR /etc/supervisor/conf.d/
