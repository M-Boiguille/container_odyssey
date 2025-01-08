DC_FILE = ./srcs/docker-compose.yml
DC = docker compose

build:
	mkdir -p ~/data ~/data/mariadb ~/data/wordpress
	$(DC) -f $(DC_FILE) build --progress=plain

rebuild: fclean
	mkdir -p ~/data ~/data/mariadb ~/data/wordpress
	$(DC) -f $(DC_FILE) build --progress=plain --no-cache

up:
	mkdir -p ~/data ~/data/mariadb ~/data/wordpress
	$(DC) -f $(DC_FILE) up --remove-orphans

upd:
	mkdir -p ~/data ~/data/mariadb ~/data/wordpress
	$(DC) -f $(DC_FILE) up -d

down:
	$(DC) -f $(DC_FILE) down

ps:
	$(DC) -f $(DC_FILE) ps

start_eval:
	-@docker stop $$(docker ps -qa)
	-@docker rm $$(docker ps -qa)
	-@docker rmi -f $$(docker images -qa)
	-@docker volume rm $$(docker volume ls -q)
	-@docker network rm $$(docker network ls -q) 2> /dev/null

clean:
	docker image prune -a -f

fclean: down clean
	sudo rm -rf ~/data/mariadb/* ~/data/wordpress

re: down build up
red: down build upd

logs:
	$(DC) -f $(DC_FILE) logs -f mariadb
	$(DC) -f $(DC_FILE) logs -f wordpress
