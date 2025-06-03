FROM alpine:3.16
RUN	apk update && apk upgrade && apk add nginx
EXPOSE 443
COPY ./requirements/tools/ryagoub.42.fr.pem /etc/nginx/certs/
COPY ./requirements/tools/ryagoub.42.fr-key.pem /etc/nginx/certs/
RUN rm /etc/nginx/nginx.conf
COPY ./requirements/nginx/conf/nginx.conf /etc/nginx/nginx.conf
# COPY ./requirements/tools/ /etc/nginx/ssl/÷
CMD ["nginx"]
