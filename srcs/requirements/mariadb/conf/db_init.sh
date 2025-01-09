#!/bin/bash
set -e

wait_for_mysqld() {
	echo "Attente du demarrage de MariaDB"
	until mysqladmin ping --silent; do
		sleep 1
	done
}

if [ -d "/var/lib/mysql/${SQL_DB}" ]; then
	echo "'${SQL_DB}' existante, pas d'init."
else
	echo "Init db '${SQL_DB}'..."

	mysqld --skip-networking --socket=/var/run/mysqld/mysqld.sock &
	sleep 2

	wait_for_mysqld

	mysql -u root <<-EOSQL
		DELETE FROM mysql.user WHERE User = '';
		DROP DATABASE IF EXISTS test;

		CREATE DATABASE IF NOT EXISTS \`${SQL_DB}\`;
		CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASS}';
		GRANT ALL PRIVILEGES ON \`${SQL_DB}\`.* TO '${SQL_USER}'@'%';

		-- Definir mdp root
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_RPASS}';

		FLUSH PRIVILEGES;
	EOSQL

	echo "Arret du mysqld temporaire..."
	mysqladmin -u root --password="${SQL_RPASS}" shutdown || true
fi

echo "Demarrage definitif de MariaDB..."
exec "$@"
