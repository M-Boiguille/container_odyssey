FROM debian:buster-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /run/php/ && \
	mkdir -p /var/www/wordpress && \
	chmod -R 755 /var/www/wordpress

RUN apt update && apt upgrade -y && apt install -y \
	wget php7.3 php7.3-fpm php7.3-mysql curl mariadb-client tini && \
	apt-get clean && \
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp-cli.phar

COPY /conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

COPY conf/configure-wordpress.sh usr/local/bin/configure-wordpress.sh

RUN chmod +x usr/local/bin/configure-wordpress.sh

EXPOSE 3306

ENTRYPOINT ["configure-wordpress.sh"]
