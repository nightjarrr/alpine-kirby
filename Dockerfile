# based on Alpine 3.8
FROM alpine:3.8

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN addgroup -g ${GROUP_ID} apache
RUN adduser -S -u ${USER_ID} -G apache -h /var/www apache

# add php 7 and apache
RUN apk add --no-cache \
  apache2 \
  php7-apache2 \
  php7-session \
  php7-gd \
  php7-simplexml \
  php7-zlib \
  php7-mbstring \
  php7-json

# copy over some basic config
COPY ./apache/localhost.conf /etc/apache2/conf.d/localhost.conf

# make the run directory
RUN mkdir -p /run/apache2/

# route logs to stdout and stderr
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

# set working directory
WORKDIR /var/www/localhost/htdocs/

# copy kirby
COPY ./kirby-starterkit /var/www/localhost/htdocs/

# create thumbs folder and set permissions for kirby
RUN chown -R apache:apache /var/www/localhost/htdocs/ \
&& chmod -R 755 /var/www/localhost/htdocs/thumbs

# run apache in foreground
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
