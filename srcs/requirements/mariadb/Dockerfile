FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

ARG WP_DB_NAME
ARG DB_USER
ARG DB_PASSWORD

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y mariadb-server mariadb-client


EXPOSE 3306

RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 755 /var/run/mysqld

COPY ./my.cnf /etc/mysql/my.cnf

COPY ./setup.sh /setup.sh
RUN chmod 755 /setup.sh

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

RUN ./setup.sh
USER mysql

CMD ["mysqld"]
