#!/bin/sh

# Install WP-CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Setup WordPress
mkdir -p /var/www/html/wordpress
cd /var/www/html/wordpress

chown -R nobody:nobody /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress
php -d memory_limit=512M /usr/local/bin/wp --allow-root core download --force

# Configure WordPress
mv wp-config-sample.php wp-config.php

sed -i "s/'database_name_here'/'$DB_NAME'/g" wp-config.php
sed -i "s/'username_here'/'$DB_USER'/g" wp-config.php
sed -i "s/'password_here'/'$DB_PASS'/g" wp-config.php
sed -i "s/'localhost'/'mariadb'/g" wp-config.php

# Configure PHP-FPM
sed -i "s|listen = 127.0.0.1:9000|listen = 0.0.0.0:9000|g" /etc/php83/php-fpm.d/www.conf
echo 'listen.owner = nobody' >> /etc/php83/php-fpm.d/www.conf
echo 'listen.group = nobody' >> /etc/php83/php-fpm.d/www.conf

chown -R nobody:nobody /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# Install WordPress and create users
wp --allow-root --path=/var/www/html/wordpress core install \
    --url='http://localhost' --title='WordPress' \
    --skip-email --admin_email="$WP_EMAIL" \
    --admin_user="$WP_USER" \
    --admin_password="$WP_PASS"

wp --allow-root --path=/var/www/html/wordpress user create \
    $WP_USER2 $WP_EMAIL2 --role=subscriber \
    --user_pass="$WP_PASS2"

# Start PHP-FPM
if [ -f /var/www/html/wordpress/wp-config.php ]; then
    php-fpm83 --nodaemonize
fi

