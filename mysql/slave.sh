#!/bin/bash
set -euo pipefail

# Параметры
ROOT_PASS="NykArNq1"
REPL_USER="repl"
REPL_PASS="Slave#2023"
MASTER_IP="10.10.5.27"

# Установка MySQL и XtraBackup
apt update
apt install -y mysql-server-8.0 percona-xtrabackup-80

# Задаём root-пароль
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$ROOT_PASS'; FLUSH PRIVILEGES;"

# Создаём конфиг для GTID
cat <<EOF > /etc/mysql/mysql.conf.d/mysqld.cnf
[mysqld]
server-id               = 2
log-bin                 = mysql-bin
binlog_format           = ROW
gtid_mode               = ON
enforce_gtid_consistency = ON
log_replica_updates     = 1
relay-log               = relay-log
read_only               = 1
replicate-do-table=bet_odds.bookmaker
replicate-do-table=bet_odds.competition
replicate-do-table=bet_odds.market
replicate-do-table=bet_odds.odds
replicate-do-table=bet_odds.outcome
EOF

# Перезапускаем MySQL
systemctl restart mysql

# Подключаем слейв к мастеру
mysql -p"$ROOT_PASS" -e "
STOP REPLICA;
RESET REPLICA ALL;
CHANGE REPLICATION SOURCE TO
  SOURCE_HOST='$MASTER_IP',
  SOURCE_USER='$REPL_USER',
  SOURCE_PASSWORD='$REPL_PASS',
  SOURCE_AUTO_POSITION=1,
  GET_SOURCE_PUBLIC_KEY=1;
START REPLICA;
"

# Проверяем статус репликации
mysql -p"$ROOT_PASS" -e "SHOW REPLICA STATUS\G" | grep -E 'Replica_IO_Running|Replica_SQL_Running|Last_IO_Error' | tee /tmp/slave_status.log

# Проверяем, что таблицы есть
mysql -p"$ROOT_PASS" -e "USE bet_odds; SHOW TABLES;" | tee /tmp/slave_show_tables.log