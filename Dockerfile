FROM alpine:3.9 

# Add repos
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories


# Add basics first
RUN apk update && apk upgrade && apk add \
	bash apache2 php7-apache2 curl ca-certificates openssl openssh git php7 tzdata openntpd vim

# Setup apache and php
RUN apk add \
	php7-mcrypt \
	php7-mbstring \
	php7-pdo \
	php7-zip \
	php7-mysqli \
	php7-bcmath \
	php7-pdo_mysql \
	php7-pdo_dblib \
	php7-curl \
        php7-apache2 \
        php7-cgi \
        php7-json \
       	php7-session \
	php7-ctype 

RUN cp /usr/bin/php7 /usr/bin/php \
    && rm -f /var/cache/apk/*

# Add apache to run and configure
RUN mkdir /var/www/html/
RUN sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ deflate_module/LoadModule\ deflate_module/" /etc/apache2/httpd.conf \
    && sed -i "s#^DocumentRoot \".*#DocumentRoot \"/var/www/html\"#g" /etc/apache2/httpd.conf \
    && sed -i "s#/var/www/localhost/htdocs#/var/www/html#" /etc/apache2/httpd.conf \
    && printf "\n<Directory \"/var/www/html\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf


# add temp file in container
RUN mkdir /var/www/etsis_tmp \
  ; mkdir /var/www/etsis_tmp/www /var/www/etsis_tmp/www/nodes /var/www/etsis_tmp/www/nodes/etsis \
  ; mkdir /var/www/etsis_tmp/www/ /var/www/etsis_tmp/www/files /var/www/etsis_tmp/www/files/cache \
  ; chown -R apache:apache /var/www/etsis_tmp
# mkdir /var/www/etsis_tmp/www/files/cache/option \

EXPOSE 80

# copy script to configure stuff
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD /usr/sbin/httpd -D FOREGROUND
