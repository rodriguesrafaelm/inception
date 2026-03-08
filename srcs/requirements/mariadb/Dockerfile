FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

ARG WP_DB_NAME
ARG DB_USER
ARG DB_PASSWORD


RUN apt update -y \
    && apt upgrade -y \
    && apt install -y mariadb-server mariadb-client


EXPOSE 3306

RUN mkdir /var/run/mysqld
RUN chmod 777 /var/run/mysqld

COPY ./my.cnf /etc/mysql/my.cnf

COPY ./setup.sh .
RUN chmod 777 ./setup.sh

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

RUN ./setup.sh

CMD ["mysqld"]
