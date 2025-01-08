FROM debian:buster-slim

RUN apt-get update && apt-get upgrade -y && apt-get install -y openssl nginx-light \
	&& mkdir -p /etc/nginx/ssl
#&& apt-get install --only-upgrade openssl \

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
	-out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
	-subj "/C=FR/ST=IDF/L=Paris/O=WP_auto_deploy/OU=mboiguille/CN=mboiguille"

COPY conf/nginx.conf /etc/nginx/sites-available/default

RUN chmod -R 755 /var/www/html \
	&& chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
