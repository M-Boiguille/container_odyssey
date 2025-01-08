FROM debian:buster-slim

RUN apt-get update && \
apt install  -y tini mariadb-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY conf/db_init.sh /tmp/db_init.sh

COPY conf/cnf_modifier.sh /tmp/cnf_modifier.sh

RUN chmod +x /tmp/db_init.sh /tmp/cnf_modifier.sh \
	&& ./tmp/cnf_modifier.sh

EXPOSE 3306

ENTRYPOINT [ "./tmp/db_init.sh" ]
