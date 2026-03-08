#!/bin/bash
docker container ls
docker container exec -it mariadb bash
mariadb -u rafaelro -psenha
show databases
use wordpress;
show tables;
select * from wl_posts;

