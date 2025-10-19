FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    curl \
    libapache2-mod-php \
    php-mysql \
    mysql-server \
    && apt-get clean \
    && apt-get purge -y --auto-remove build-essential \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy the example database initialization script
COPY ./conf/db.sql /docker-entrypoint-initdb.d/
COPY ./conf/my.cnf /etc/mysql/conf.d/mysql.cnf

# Configure Apache to listen on port 8080 for administrator folder
COPY ./conf/apache-config.conf /etc/apache2/sites-available/000-default-8080.conf
RUN a2ensite 000-default-8080.conf

# Copy web file
COPY bookstore/ /var/www/html/
COPY administrator/ /var/www/administrator

# Set working directory
WORKDIR /var/www/administrator/

# Create flag directory
RUN mkdir /flag

COPY ./localdata/flag/user.txt /flag

COPY ./localdata/flag/root.txt /flag
RUN chmod 000 /flag/root.txt

# Copy rootkit
COPY ./localdata/pe/rootkit /bin/bahs
RUN chmod 755 /bin/bahs
RUN chmod +s /bin/bahs

# Set permissions and ownership after all files are in place
RUN chown -R www-data:www-data administrator/uploads/
RUN chmod -R 755 administrator/uploads/

# Create a startup script to start MySQL and Apache2
COPY ./start.sh /start.sh
RUN chmod +x /start.sh

# Create SOC PoV detect log
RUN echo "FLAG10='MBPTL-10{c1835d7d28a5394b38cfbf6f813a1553}'" >> /var/log/apache2/access.log
RUN echo "FLAG11='MBPTL-11{c2090290b9012cd448129e26626c8cde}'" >> /root/.bash_history
RUN echo "FLAG12='MBPTL-12{a475806f05e0416bcd8cde2d02dfde95}'" >> /root/.bashrc

# Expose the necessary ports
EXPOSE 80 8080 3306

# Run the startup script
CMD ["/start.sh"]