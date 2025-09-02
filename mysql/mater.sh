#!/bin/bash
set -euo pipefail

# Параметры
ROOT_PASS="NykArNq1"
REPL_USER="repl"
REPL_PASS="Slave#2023"
DUMP_FILE="/root/bet.dmp"

# Установка MySQL и XtraBackup
apt update
apt install -y curl mysql-server-8.0 gnupg2 lsb-release

#curl -O https://repo.percona.com/apt/percona-release_latest.generic_all.deb

#apt install -y ./percona-release_latest.generic_all.deb

#percona-release setup pxb-80

#apt install percona-xtrabackup-80 -y


# Создаём конфиг для GTID
cat <<EOF > /etc/mysql/mysql.conf.d/mysqld.cnf
[mysqld]
server-id               = 1
log-bin                 = mysql-bin
binlog_format           = ROW
gtid_mode               = ON
enforce_gtid_consistency = ON
log_replica_updates     = 1
EOF

# Перезапускаем MySQL
systemctl restart mysql

# Задаём root-пароль
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$ROOT_PASS'; FLUSH PRIVILEGES;"

# Импортируем дамп
mysql -p"$ROOT_PASS" < bet.dmp 

# Создаём пользователя репликации
mysql -p"$ROOT_PASS" -e "
CREATE USER '$REPL_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$REPL_PASS';
GRANT REPLICATION SLAVE ON *.* TO '$REPL_USER'@'%';
FLUSH PRIVILEGES;
"

# Проверяем, что таблицы есть
mysql -p"$ROOT_PASS" -e "USE bet_odds; SHOW TABLES;" | tee /tmp/master_show_tables.log

# Проверяем GTID
mysql -p"$ROOT_PASS" -e "SELECT @@gtid_mode, @@server_id;" | tee /tmp/master_gtid_check.log