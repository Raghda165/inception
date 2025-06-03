FROM alpine:3.20

RUN apk update && apk add php php83 php83-fpm php83-mysqli php83-mbstring php83-gd php83-opcache php83-phar php83-xml mariadb-client wget tar

COPY requirements/wordpress/tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]



