FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
	apt install -y ca-certificates \
	php7.4-mbstring \
	php-tokenizer \
	php7.4-xml \
	php7.4-mysql \
	php7.4-zip \
	php7.4-fpm \
	php7.4-curl \
	php7.4-fileinfo \
	curl \
	wget \
	unzip
	
ARG DB_HOST
ARG DB_USER
ARG DB_PASSWORD
ARG WP_DB_NAME
ARG WP_TABLE_PREFIX
ARG WP_SITE_TITLE
ARG WP_ADMIN_USER
ARG WP_ADMIN_PASSWORD
ARG WP_ADMIN_EMAIL
ARG WP_USER
ARG WP_PASSWORD
ARG WP_EMAIL


WORKDIR /var/www

RUN curl -O https://wordpress.org/wordpress-6.7.1.zip \
	&& unzip wordpress-6.7.1.zip \
	&& mv wordpress/* . \
	&& rm -rf wordpress wordpress-6.7.1.zip
	
RUN curl -O https://github.com/wp-cli/wp-cli/releases/download/v2.11.0/wp-cli-2.11.0.phar \
	&& chmod +x wp-cli-2.11.0.phar \
	&& mv wp-cli-2.11.0.phar /usr/local/bin/wp


COPY ./www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN chmod 777 /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir -p /run/php

COPY ./config.sh /config.sh

RUN chmod +x /config.sh && chmod -R 0777 wp-content/

CMD ["/bin/sh", "-c", "/config.sh && php-fpm7.4 	"]

