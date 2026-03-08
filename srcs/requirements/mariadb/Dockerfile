FROM debian:bullseye

ENV WP_DB_NAME=test
ENV DB_USER=user1
ENV DB_PASSWORD=password
ENV DEBIAN_FRONTEND=noninteractive


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
