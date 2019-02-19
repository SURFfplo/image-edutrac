FROM php:7.3.2-fpm-alpine3.9
# FROM alpine:3.9
LABEL image="edutrac sis php"
LABEL versie="0.3 v 6.3.4"
LABEL datum="2019 02 19"

FROM php:7.3.2-fpm-alpine3.9
RUN apk update; \
    apk upgrade;
RUN docker-php-ext-install mysqli

# set timezone
RUN cp /usr/share/zoneinfo/Europe/Amsterdam /etc/timezone
RUN rm /etc/localtime; ln -s /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
