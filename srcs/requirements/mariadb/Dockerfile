FROM debian:buster-slim

RUN apt-get update && \
	apt-get install -y mariadb-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld && \
	chown -R mysql:mysql /var/run/mysqld && \
	chmod 777 /var/run/mysqld

COPY conf/cnf_modifier.sh /tmp/cnf_modifier.sh
COPY conf/db_init.sh /usr/local/bin/db_init.sh

RUN chmod +x /usr/local/bin/db_init.sh /tmp/cnf_modifier.sh \
	&& /tmp/cnf_modifier.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/db_init.sh"]

CMD ["mysqld", "--bind-address=0.0.0.0"]
