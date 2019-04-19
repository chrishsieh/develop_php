FROM nginx:alpine
MAINTAINER ChurchCRM
RUN mkdir -p /var/www/code/src \
    && cd /var/www \
    && rm -rf /var/www/html \
    && ln -s /var/www/code/src html
