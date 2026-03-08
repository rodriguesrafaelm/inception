FROM debian:bookworm

ARG WP_HOST

RUN apt update -y \
    && apt install -y openssl nginx

EXPOSE 443

COPY ./conf/certgen.sh /certgen.sh
RUN chmod 777 /certgen.sh
RUN /bin/sh /certgen.sh

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
    
