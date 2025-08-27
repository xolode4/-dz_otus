#!/bin/bash
set -e

MASTER_HOST="mysql-master"
MASTER_USER_PASSWORD="master_password"  # пароль для root на mysql-master
SLAVE_ROOT_PASSWORD="slave_password"    # пароль для root на mysql-slave
MASTER_USER_REPLICA="replica_user"
MASTER_PASSWORD_REPLICA="replica_password"
MASTER_USER="master"
# Подождите, пока master не станет доступен
until mysql -h"$MASTER_HOST" -u"$MASTER_USER" -p"$MASTER_USER_PASSWORD" -e "SHOW DATABASES;"; do
  >&2 echo "MySQL master is unavailable - sleeping"
  sleep 15
done

# Установка server_id на слейве
mysql -uroot -p"$SLAVE_ROOT_PASSWORD" -e "SET GLOBAL server_id = 2;"

# Настройка реплики
#mysql -uroot -p"$SLAVE_ROOT_PASSWORD" -e "CHANGE REPLICATION SOURCE TO SOURCE_HOST='$MASTER_HOST', SOURCE_USER='$MASTER_USER_REPLICA', SOURCE_PASSWORD='$MASTER_PASSWORD_REPLICA', SOURCE_AUTO_POSITION = 1, GET_SOURCE_PUBLIC_KEY = 1;"
#mysql -uroot -p"$SLAVE_ROOT_PASSWORD" -e "CHANGE REPLICATION SOURCE TO SOURCE_HOST='$MASTER_HOST', SOURCE_USER='replica_user', SOURCE_PASSWORD='replica_password', SOURCE_AUTO_POSITION = 1, GET_SOURCE_PUBLIC_KEY = 1;"
#CHANGE REPLICATION SOURCE TO SOURCE_HOST='mysql-master', SOURCE_USER='replica_user', SOURCE_PASSWORD='replica_password', SOURCE_AUTO_POSITION = 1,  GET_SOURCE_PUBLIC_KEY = 1;

# Запуск слейва
mysql -uroot -p"$SLAVE_ROOT_PASSWORD" -e "START REPLICA;"


CHANGE REPLICATION SOURCE TO SOURCE_HOST='mysql-master', SOURCE_AUTO_POSITION=1,    GET_SOURCE_PUBLIC_KEY=1;
START REPLICA USER='replica_user' PASSWORD='replica_password';
