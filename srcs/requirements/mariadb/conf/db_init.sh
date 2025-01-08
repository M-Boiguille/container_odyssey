#!/bin/bash

service mysql start

while ! mysqladmin ping -h "localhost" -u "root" -p"$SQL_PASS" --silent; do
	echo "Attente du démarrage de MariaDB..."
	sleep 1
done

if ! mysql -u "root" -p"$SQL_PASS" -h "localhost" -e "USE $SQL_DB;" &>/dev/null; then
	echo "initialisation de la db"
	cat <<EOF >/tmp/init_db.sql
DELETE FROM mysql.user WHERE User = '';
DROP DATABASE IF EXISTS test;
CREATE DATABASE $SQL_DB;
CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASS';
GRANT ALL PRIVILEGES ON $SQL_DB.* TO '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASS';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$SQL_RPASS';
FLUSH PRIVILEGES;
EOF

	if [ -f /tmp/init_db.sql ]; then
		mysqld --init-file=/tmp/init_db.sql &
		service mysql restart
	fi

else
	echo "db existante"
fi

rm -f /tmp/init_db.sql
exec mysqld
