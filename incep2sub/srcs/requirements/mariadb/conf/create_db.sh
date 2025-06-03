#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then

        chown -R mysql:mysql /var/lib/mysql

        # init database
        mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

        tfile=`mktemp`
        if [ ! -f "$tfile" ]; then
                return 1
        fi
fi

echo "bind-address = 0.0.0.0" >> /etc/my.cnf.d/mariadb-server.cnf
echo "port = 3306" >> /etc/my.cnf.d/mariadb-server.cnf
sed -i 's/^\s*skip-networking/# skip-networking/' /etc/my.cnf.d/mariadb-server.cnf


if [ ! -d "/var/lib/mysql/wordpress" ]; then

        cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM     mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASS}';
GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
#         # run init.sql
    # Run the SQL script in bootstrap mode
    /usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < /tmp/create_db.sql

fi

# Start the server normally after initialization (this line depends on your container entrypoint)
exec /usr/bin/mysqld --user=mysql