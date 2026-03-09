all: up

build: prepdir
	docker compose -f ./srcs/docker-compose.yml build

prepdir:
	mkdir $(HOME)/data -p && mkdir $(HOME)/data/mariadb -p && mkdir $(HOME)/data/wordpress -p

up: build
	docker compose -f ./srcs/docker-compose.yml up

detach: build
	docker compose -f ./srcs/docker-compose.yml up -d

down:
	docker compose -f ./srcs/docker-compose.yml down --remove-orphans

clean: down
	sudo rm -rf $(HOME)/data/mariadb
	sudo rm -rf $(HOME)/data/wordpress

fclean: down
	sudo rm -rf $(HOME)/data

re: fclean all
