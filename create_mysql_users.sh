#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

PASS=${MYSQL_ADMIN_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MYSQL_ADMIN_PASS} ] && echo "preset" || echo "random" )

mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

mysql -uroot -e " GRANT ALL PRIVILEGES ON phpmyadmin.* TO  'pma'@'localhost' IDENTIFIED BY ''"

CREATE_MYSQL_USER=false

if [ -n "$CREATE_MYSQL_BASIC_USER_AND_DB" ] || \
   [ -n "$MYSQL_USER_NAME" ] || \
   [ -n "$MYSQL_USER_DB" ] || \
   [ -n "$MYSQL_USER_PASS" ]; then
      CREATE_MYSQL_USER=true
fi

if [ "$CREATE_MYSQL_USER" = true ]; then
    _user=${MYSQL_USER_NAME:-user}
    _userdb=${MYSQL_USER_DB:-db}
    _userpass=${MYSQL_USER_PASS:-password}

    mysql -uroot -e "CREATE USER '${_user}'@'%' IDENTIFIED BY  '${_userpass}'"
    mysql -uroot -e "GRANT USAGE ON *.* TO  '${_user}'@'%' IDENTIFIED BY '${_userpass}'"
    mysql -uroot -e "CREATE DATABASE IF NOT EXISTS ${_userdb}"
    mysql -uroot -e "GRANT ALL PRIVILEGES ON ${_userdb}.* TO '${_user}'@'%'"
fi

mysqladmin -uroot shutdown
