#!/bin/bash

if [ ! -f "/var/www/wp-config.php" ]; then
	sleep 3
	cd /var/www/
	wp config create --dbname="${WP_DB_NAME}" --dbuser="${DB_USER}" --dbpass"${DB_PASSWORD}" \
		--dbhost="${DB_HOST}":"3306" --force --allow-root
	wp config set FS_METHOD 'direct' --allow-root
	
	wp core install --url="https://${WP_HOST}" --title="${WP_SITE_TITLE}" --admin_user="${WP_ADMIN_USER}" \
		--admin_email="${WP_ADMIN_EMAIL"} -- allow-root
	wp user create "${WP_USER}" "${WP_EMAIL}" --role="editor" --user_pass="${WP_PASSWORD}" --allow-root
else
	echo "Its already done"
fi
