FROM nginx:alpine

ARG PHP_UPSTREAM_CONTAINER=php-fpm
ARG PHP_UPSTREAM_PORT=9000

COPY ./nginx.conf /etc/nginx/

RUN apk update \
    && apk upgrade \
    && apk --update add logrotate \
    && apk add --no-cache openssl \
    && apk add --no-cache bash

RUN apk update \
    && apk upgrade \
    && apk add --no-cache curl \
    && apk add --no-cache gdb \
    && apk add --no-cache git \
    && apk add --no-cache htop \
    && apk add --no-cache mc \
    && apk add --no-cache ltrace \
    && apk add --no-cache make \
    && apk add --no-cache procps \
    && apk add --no-cache sudo \
    && apk add --no-cache sysstat \
    && apk add --no-cache unzip \
    && apk add --no-cache vim \
    && apk add --no-cache wget

RUN set -x ; \
    addgroup -g 82 -S www-data ; \
    adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

# Create 'messages' file used from 'logrotate'
RUN touch /var/log/messages

# Copy 'logrotate' config file
COPY logrotate/nginx /etc/logrotate.d/

# entrypoint
RUN mkdir -p /bin/docker-entrypoint/
COPY /scripts/resolve-docker-host-ip.sh ./bin/docker-entrypoint/resolve-docker-host-ip.sh
RUN chmod +x -R /bin/docker-entrypoint/

RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf
RUN rm /etc/nginx/conf.d/default.conf

RUN mkdir -p /bin/docker-entrypoint/
COPY ./sites-available/* /etc/nginx/sites-available/

RUN mkdir -p /var/www/{upload/{public,private},html}

ADD ./scripts/startup.sh /opt/startup.sh
RUN sed -i 's/\r//g' /opt/startup.sh
CMD ["nginx"]

EXPOSE 80 443 3030
