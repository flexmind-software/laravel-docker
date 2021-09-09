#!/usr/bin/env sh

# add wget
apt-get update -yqq && apt-get -f install -yyq wget
apt-get update -yqq && pecl channel-update pecl.php.net

# download helper script
# @see https://github.com/mlocati/docker-php-extension-installer/
wget -q -O /usr/local/bin/install-php-extensions https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions \
    || (echo "Failed while downloading php extension installer!"; exit 1)

# install extensions
chmod uga+x /usr/local/bin/install-php-extensions && sync && install-php-extensions \
    @composer \
    zip \
    opcache \
    xdebug \
    soap \
    xsl \
    bcmath \
    gmp \
    exif \
    intl \
    imagick \
    gd \
    imap \
    apcu \
    yaml \
    redis
