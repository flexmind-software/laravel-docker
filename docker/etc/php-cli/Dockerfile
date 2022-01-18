ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

USER root

COPY shared/scripts/install_software.sh /usr/bin/install_software
COPY shared/scripts/install_php_extensions.sh /usr/bin/install_php_extensions
COPY shared/scripts/install_aliases.sh /usr/bin/install_aliases
COPY shared/scripts/install_modules.sh /usr/bin/install_modules


RUN chmod +x /usr/bin/install_software && install_software
RUN chmod +x /usr/bin/install_php_extensions && install_php_extensions
RUN chmod +x /usr/bin/install_aliases && install_aliases

COPY shared/configs/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY shared/configs/ssh/insecure_id_rsa.pub /root/insecure_id_rsa.pub

ARG INSTALL_MONGODB=false
ARG INSTALL_MYSQL=false
ARG INSTALL_POSTGRESQL=false
ARG INSTALL_NODE=false
ARG INSTALL_NPM=true
ARG INSTALL_XDEBUG=false
ARG INSTALL_WKHTMLTOPDF=false
ARG INSTALL_FAKETIME=false
ARG INSTALL_FFMPEG=false
RUN chmod +x /usr/bin/install_modules && install_modules \
    -mongo ${INSTALL_MONGODB} \
    -mysql ${INSTALL_MYSQL} \
    -psql ${INSTALL_POSTGRESQL} \
    -node ${INSTALL_NODE} \
    -npm ${INSTALL_NPM} \
    -xdebug ${INSTALL_XDEBUG} \
    -wkhtml ${INSTALL_WKHTMLTOPDF} \
    -faketime ${INSTALL_FAKETIME} \
    -ffmpeg ${INSTALL_FFMPEG}

RUN set -xe; php -v | head -n 1 | grep -q "PHP ${PHP_VERSION}."
COPY shared/configs/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

ARG INSTALL_PRODUCTION=false
RUN if [ ${INSTALL_PRODUCTION} = true ]; then \
    RUN php -d memory_limit=-1 /usr/local/bin/composer global require phpunit/phpunit friendsofphp/php-cs-fixer "squizlabs/php_codesniffer=*" edgedesign/phpqa \
;fi

# Clean up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm /var/log/lastlog /var/log/faillog

RUN usermod -u 1000 www-data

WORKDIR /var/www/html

# @see https://docs.docker.com/engine/examples/running_ssh_service/
CMD ["/usr/sbin/sshd", "-D"]
