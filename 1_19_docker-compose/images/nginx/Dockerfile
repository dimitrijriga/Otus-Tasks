FROM alpine:latest
RUN apk update && apk add nginx \
#    && adduser -D -g 'www' www \
#    && mkdir /var/www \
#    && chown -R www:www /var/lib/nginx \
#    && chown -R www:www /var/www \
    && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig

COPY nginx.conf /etc/nginx/nginx.conf 
#COPY index.html /var/www/
ENTRYPOINT ["nginx", "-g", "daemon off;"]

