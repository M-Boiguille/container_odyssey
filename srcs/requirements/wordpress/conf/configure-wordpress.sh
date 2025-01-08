#!/bin/bash

wait_for_mariadb() {
	while ! mysqladmin ping -h "mariadb" -u"root" -p"$SQL_RPASS"; do
		sleep 5
	done
}
wait_for_mariadb
echo "===WordPress Script==="

if wp-cli.phar core is-installed --path="${WP_PATH}" --allow-root --quiet; then
	echo "WordPress is already configured."
else
	echo "Starting WordPress setup."

	wp-cli.phar core download --path="${WP_PATH}" --allow-root
	wp-cli.phar config create --dbname="${SQL_DB}" --dbuser="${SQL_USER}" \
		--dbhost="mariadb" --dbpass="${SQL_PASS}" \
		--path="${WP_PATH}" --allow-root
	wp-cli.phar core install --url="${DOMAIN_NAME}" --title="Container Odyssey" \
		--admin_user="${WP_USER}" --admin_password="${WP_PASS}" \
		--admin_email="${EMAIL1}" --path="${WP_PATH}" --allow-root
	echo "Plugin list."
	wp-cli.phar plugin list --path="${WP_PATH}" --allow-root

	echo "Create users."
	wp-cli.phar user create "${WP_USER2}" "${EMAIL2}" \
		--role=subscriber --user_pass="${WP_PASS2}" \
		--path="${WP_PATH}" --allow-root

	echo "Delete posts."
	wp-cli.phar post delete --path="${WP_PATH}" --force 1 2 3 4 5 6 --allow-root
	echo "Creating pages for Container Odyssey..."
	wp-cli.phar post create --path="${WP_PATH}" --post_type=page --post_title="Accueil" \
		--post_content="Bienvenue sur Container Odyssey, un projet dédié à l'automatisation avec Docker. Découvrez nos objectifs : créer une architecture en microservices et intégrer Nginx, MariaDB et WordPress." \
		--post_status=publish --allow-root

	wp-cli.phar post create --path="${WP_PATH}" --post_type=page --post_title="À propos" \
		--post_content="**Les étapes de développement du projet Container Odyssey** :
        
1. Création d'une architecture Docker.
2. Configuration des conteneurs Nginx, MariaDB et WordPress.
3. Automatisation via des scripts Bash.

**Technologies utilisées** : Docker, Nginx, MariaDB, WordPress." \
		--post_status=publish --allow-root

	echo "Adding blog articles..."
	wp-cli.phar post create --path="${WP_PATH}" --post_type=post --post_title="Bienvenue sur Container Odyssey" \
		--post_content="Ceci est le premier article de notre projet. Découvrez comment nous avons automatisé le déploiement d'une architecture web complète grâce à Docker !" \
		--post_status=publish --allow-root

	wp-cli.phar post create --path="${WP_PATH}" --post_type=post --post_title="Étape 1 : Configuration des conteneurs" \
		--post_content="Cette étape couvre la configuration de MariaDB, Nginx et WordPress avec des scripts Bash pour simplifier leur intégration dans des conteneurs Docker." \
		--post_status=publish --allow-root

	echo "Setting up navigation menu..."
	wp-cli.phar menu create --path="${WP_PATH}" "Menu principal" --allow-root
	wp-cli.phar menu item add-post --path="${WP_PATH}" "Menu principal" 4 --allow-root
	wp-cli.phar menu item add-post --path="${WP_PATH}" "Menu principal" 5 --allow-root
	wp-cli.phar menu location assign "Menu principal" primary --allow-root
fi

chown -R www-data:www-data /var/www/wordpress

echo "===WordPress is now configured==="

php-fpm7.3 --nodaemonize
