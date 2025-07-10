#!/bin/bash
set -e

# Set MySQL password environment variable to suppress warnings
export MYSQL_PWD=${MYSQL_ROOT_PASSWORD:-root}

# Start MySQL service
service mysql start

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
for i in {1..30}; do
    if mysqladmin ping --silent; then
        break
    fi
    sleep 1
done

# Check if the database is already initialized by checking if the users table exists
if ! mysql -uroot -e "USE administrator; DESCRIBE users;" >/dev/null 2>&1; then
    echo "Initializing example database..."

    mysql -uroot <<-EOSQL
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
        ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';
        ALTER USER '${MYSQL_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO 'root'@'localhost';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost';
        FLUSH PRIVILEGES;
EOSQL

    # Import the database schema
    mysql -uroot < /docker-entrypoint-initdb.d/db.sql

    echo "Database initialization completed."
else
    echo "Database already initialized, skipping initialization."
fi

# Delete index.html if it exists
if [ -f /var/www/html/index.html ]; then
    rm /var/www/html/index.html
fi

# Start Apache2 service (will listen on both port 80 and 8080)
echo "Starting Apache..."
apache2ctl -D FOREGROUND