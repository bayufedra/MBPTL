FROM php:7.3-apache 

RUN apt-get update
RUN docker-php-ext-install mysqli

COPY ./www /var/www/html/

WORKDIR /var/www/html/administrator/
RUN chmod -R 777 uploads
RUN chown -R www-data:www-data uploads

RUN mkdir /flag

COPY ./localdata/flag/user.txt /flag

COPY ./localdata/flag/root.txt /flag
RUN chmod 000 /flag/root.txt

COPY ./localdata/pe/rootkit /bin/bahs
RUN chmod 777 /bin/bahs
RUN chmod +s /bin/bahs
