#!/usr/bin/env bash

apt-get update -yqq && apt-get install -yqq \
    apt-utils \
    libzip-dev \
    zip \
    unzip \
    wget \
    curl \
    dnsutils \
    gdb \
    mc \
    git \
    git-flow \
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
    jpegoptim optipng pngquant gifsicle

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ncomposer global require phpunit/phpunit --dev
ncomposer global require friendsofphp/php-cs-fixer --dev
ncomposer global require "squizlabs/php_codesniffer=*" --dev

mkdir -p /root/.ssh \
  && cat /root/insecure_id_rsa.pub >> /root/.ssh/authorized_keys \
  && rm -rf /root/insecure_id_rsa.pub

export PATH="/root/.composer/vendor/bin:$PATH"
