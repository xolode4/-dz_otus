#!/bin/bash
set -e

MYSQL_ROOT_PASSWORD="master_password"

# Настройка мастера для репликации
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER 'replica_user'@'%' IDENTIFIED BY 'replica_password';"
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "GRANT REPLICATION SLAVE ON *.* TO 'replica_user'@'%';"
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

####
BACKUP_DIR="/mnt/otus/mysql-backup"
DB_NAME="my_database"
SQL_USER="root"
SQL_PASSWORD="master_password"
INIT_TABLE="products"
INIT_FILE="${BACKUP_DIR}/latest_backup.sql"

# Проверка наличия файлов SQL в папке бэкапов
if [ -n "$(ls -A $BACKUP_DIR/*.sql 2>/dev/null)" ]; then
    echo "Backup file found. Restoring the database..."
    mysql -u$SQL_USER -p$SQL_PASSWORD < $INIT_FILE
    echo "Database restored from backup: $INIT_FILE"
else
    echo "No backup found. Creating a new database with initial data..."

    # Создание новой базы данных
    mysql -u$SQL_USER -p$SQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
    
    # Добавление простой таблицы с данными
    mysql -u$SQL_USER -p$SQL_PASSWORD $DB_NAME <<EOF
CREATE TABLE IF NOT EXISTS $INIT_TABLE (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);

INSERT INTO $INIT_TABLE (name, quantity) VALUES
('Product1', 10),
('Product2', 20),
('Product3', 30);
EOF

    echo "New database '$DB_NAME' created and table '$INIT_TABLE' populated."
fi

echo "Script execution complete."
