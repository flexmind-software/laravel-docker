#!/bin/bash

apt-get update -yqq && apt-get install -yq git-flow
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --2

while test $# -gt 0; do
  case "$1" in
  -mongo)
    shift
    if test "$1" = "true"; then
      echo "Install Mongo"
      install-php-extensions mongodb
    fi
    shift
    ;;
  -mysql)
    shift
    if test "$1" = "true"; then
      echo "Install MySQL"
      docker-php-ext-install pdo pdo_mysql && docker-php-ext-install mysqli
    fi
    shift
    ;;
  -psql)
    shift
    if test "$1" = "true"; then
      echo "Install Postgresql"
      apt-get install -y libpq-dev php-pgsql &&
        docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql &&
        docker-php-ext-install pgsql pdo_pgsql
    fi
    shift
    ;;
  -node)
    shift
    if test "$1" = "true"; then
      echo "Install Node"
      curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.38.0/install.sh | bash >/dev/null &&
        export NVM_DIR="$HOME/.nvm" >/dev/null &&
        [ -s "$NVM_DIR/nvm.sh" ] >/dev/null && . "$NVM_DIR/nvm.sh" >/dev/null
      nvm install 14
      nvm use node
      nvm install node-sass
      npm rebuild node-sass
    fi
    shift
    ;;
  -npm)
    shift
    if test "$1" = "true"; then
      echo "Install Npm"
      apt-get -y -qq update && apt-get install -qq -y gnupg build-essential yarn npm
    fi
    shift
    ;;
  -xdebug)
    shift
    if test "$1" = "true"; then
      echo "Install XDEBUG"
      install-php-extensions xdebug
    fi
    shift
    ;;
  -wkhtml)
    shift
    if test "$1" = "true"; then
      echo "Install wkhtml"
      apt-get install -yqq \
        libxrender1 \
        libfontconfig1 \
        libx11-dev \
        libjpeg62 \
        libxtst6 \
        wget &&
        wget https://github.com/h4cc/wkhtmltopdf-amd64/blob/master/bin/wkhtmltopdf-amd64?raw=true -O /usr/local/bin/wkhtmltopdf &&
        wget https://github.com/h4cc/wkhtmltoimage-amd64/blob/master/bin/wkhtmltoimage-amd64?raw=true -O /usr/local/bin/wkhtmltoimage &&
        chmod +x /usr/local/bin/wkhtmltopdf &&
        chmod +x /usr/local/bin/wkhtmltoimage
    fi
    shift
    ;;
  -faketime)
    shift
    if test "$1" = "true"; then
      echo "Install faketime"
      apt-get install -y libfaketime \
        echo "/usr/lib/x86_64-linux-gnu/faketime/libfaketime.so.1" >/etc/ld.so.preload
    fi
    shift
    ;;
  -ffmpeg)
    shift
    if test "$1" = "true"; then
      echo "Install ffmpeg"
      apt-get update -yqq && apt-get install -yqq ffmpeg
    fi
    shift
    ;;
  *)
    echo "$1 is not a recognized flag!"
    return 1
    ;;
  esac
done

export PATH="./vendor/bin:$PATH"
apt-get update -yqq && apt-get install -yqq openssh-server iputils-ping netcat && mkdir /var/run/sshd
export PATH="$(composer global config bin-dir --absolute --quiet):$PATH"
