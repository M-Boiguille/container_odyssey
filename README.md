# Container Odyssey

Container Odyssey est mon premier projet Docker visant à explorer la création d'une architecture en microservices, en mettant l'accent sur la configuration manuelle, la mise en réseau, et la persistance des données.

Ce projet utilise des images Debian Slim comme base pour MariaDB, WordPress et Nginx, afin d'expérimenter les problèmes réels d'installation, de configuration, et d'interconnexion entre ces services.

## Objectifs du projet
- Comprendre les bases de Docker et la gestion des conteneurs.
- Configurer manuellement une base de données MariaDB et une instance WordPress.
- Éviter les pratiques anti-pattern comme l'utilisation de `tail -f` pour maintenir les conteneurs actifs.
- Implémenter une architecture avec des volumes persistants pour MariaDB et WordPress.
- Expérimenter la configuration SSL avec Nginx.
- Utiliser un fichier `.env` pour gérer les variables sensibles et les paramètres dynamiques.

## Architecture du projet

### Services inclus
- **MariaDB** : Fournit la base de données pour WordPress. Configuré avec un script d’initialisation personnalisé.
- **WordPress** : CMS populaire, configuré via WP-CLI pour une personnalisation automatisée.
- **Nginx** : Serveur web, configuré avec SSL auto-signé pour garantir une connexion sécurisée.

### Points Clés de la Configuration
1. **Utilisation de Debian Slim** :
   - J'ai choisi des images Debian Slim au lieu des images Docker préconstruites pour explorer les défis liés à l'installation, à la mise en réseau, et à la gestion des dépendances.
   - Cela m'a permis d’étudier comment chaque composant fonctionne, depuis l’installation des paquets jusqu’à la configuration finale.

2. **Scripts d'Initialisation** :
   - MariaDB est initialisé via un script Bash qui :
     - Configure une base de données personnalisée.
     - Crée un utilisateur avec des privilèges spécifiques.
     - S'assure que les mots de passe et privilèges sont correctement définis.
   - WordPress est configuré avec WP-CLI pour automatiser :
     - Le téléchargement et l’installation du core WordPress.
     - La création d'utilisateurs et de pages par défaut.

3. **Makefile** :
   - Le projet utilise un **Makefile** pour simplifier les opérations courantes comme la construction, le démarrage et l’arrêt des services.
   - Commandes principales :
     - `make build` : Construit les images Docker.
     - `make up` : Lance les services en mode attaché.
     - `make upd` : Lance les services en mode détaché.
     - `make clean` : Nettoie les images inutilisées.
     - `make fclean` : Supprime les volumes persistants pour repartir de zéro.

4. **Gestion des Conteneurs Sans `tail -f`** :
   - Les scripts d’initialisation des conteneurs sont conçus pour éviter d’utiliser `tail -f` ou des équivalents pour maintenir les conteneurs actifs.
   - Les conteneurs restent en exécution grâce à des processus principaux correctement configurés (par ex. `mysqld` ou `php-fpm`).

5. **Volumes Persistants** :
   - Les données de MariaDB et WordPress sont stockées dans des volumes Docker, liés à des répertoires locaux pour garantir leur persistance.

6. **Fichier `.env`** :
   - Les paramètres sensibles (comme les mots de passe, noms de base de données, etc.) sont stockés dans un fichier `.env` pour améliorer la sécurité et permettre une configuration flexible.

7. **SSL avec Nginx** :
   - Un certificat SSL auto-signé est généré au moment de la construction du conteneur Nginx.
   - La configuration est incluse pour gérer les connexions HTTPS.

## Structure du Projet
```
.
├── Makefile
├── srcs
│   ├── docker-compose.yml
│   ├── requirements
│   │   ├── mariadb
│   │   │   ├── Dockerfile
│   │   │   ├── conf
│   │   │   │   ├── cnf_modifier.sh
│   │   │   │   ├── db_init.sh
│   │   ├── wordpress
│   │   │   ├── Dockerfile
│   │   │   ├── conf
│   │   │   │   ├── www.conf
│   │   │   │   ├── configure-wordpress.sh
│   │   ├── nginx
│   │   │   ├── Dockerfile
│   │   │   ├── conf
│   │   │   │   ├── nginx.conf
├── .env
```

## Prérequis
- **Docker** : Assurez-vous que Docker est installé sur votre système.
- **Docker Compose** : Requis pour utiliser le fichier `docker-compose.yml`.
- **Make** : Utilisé pour exécuter les commandes du Makefile.

## Instructions d'Installation
1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/votre-repo/container-odyssey.git
   cd container-odyssey
   ```
2. Créez un fichier `.env` à la racine du dossier 'srcs/' en suivant cet exemple :
   ```env
   SQL_DB=my_database
   SQL_USER=my_user
   SQL_PASS=my_password
   SQL_RPASS=root_password
   WP_USER=admin
   WP_PASS=admin_password
   DOMAIN_NAME=localhost
   ```
3. Construisez les images Docker :
   ```bash
   make build
   ```
4. Lancez les services :
   ```bash
   make up
   ```
   en version détachée :
   ```bash
   make upd
   ```

## Utilisation
- Accédez à votre site WordPress à l’adresse : `https://localhost`.
- Pour arrêter les services :
  ```bash
  make down
  ```
- Pour visualiser les journaux :
  ```bash
  make logs
  ```

## Améliorations Futures
- Intégration de tests automatisés pour vérifier l’état des services.
- Utilisation de certificats SSL émis par Let's Encrypt.
- Ajout d'un conteneur de monitoring pour suivre les performances (ex. Prometheus + Grafana).

## Remerciements
Ce projet est une exploration personnelle de Docker et des microservices. Toute suggestion ou contribution est la bienvenue !

