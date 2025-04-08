#!/bin/bash

# Настройки
BACKUP_DIR="/mnt/otus/mysql-backup"
DATE=$(date +%F)
MYSQLSLAVEHOST="10.10.10.114"
# Настройки Gotify
GOTIFY_URL="https://gotify.home.lcl/message"
GOTIFY_TOKEN="Axy3gyG_JCNAkmq"

# Функция для отправки уведомления в Gotify
send_gotify_message() {
    local TITLE=$1
    local MESSAGE=$2
    local PRIORITY=$3

    curl -X POST "${GOTIFY_URL}" \
        -F "title=${TITLE}" \
        -F "message=${MESSAGE}" \
        -F "priority=${PRIORITY}" \
        -H "X-Gotify-Key: ${GOTIFY_TOKEN}"

    if [ $? -eq 0 ]; then
        echo "Сообщение отправлено в Gotify." > $BACKUP_DIR/complete${DATE}.log 
    else
        echo "Ошибка при отправке сообщения в Gotify." >> $BACKUP_DIR/error${DATE}.log
    fi
}

# Проверка подключения к MySQL
if ! mysql -h $MYSQLSLAVEHOST -P 3307 -e "SELECT 1;" > /dev/null 2>&1; then
    send_gotify_message "Ошибка подключения" "Не удалось подключиться к серверу MySQL." 10
    exit 1
fi

# Функция для бэкапа отдельной таблицы
backup_table() {
    DB_NAME=$1
    TABLE_NAME=$2
    BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TABLE_NAME}_${DATE}.sql"

    # Создание бэкапа с информацией о бинарном логе
    mysqldump -h $MYSQLSLAVEHOST -P 3307 --triggers --routines --events --single-transaction --source-data=2 $DB_NAME $TABLE_NAME > $BACKUP_FILE

    if [ $? -eq 0 ]; then
        send_gotify_message "Бэкап успешен" "Таблица ${TABLE_NAME} из базы данных ${DB_NAME} успешно сохранена." 5
    else
        send_gotify_message "Ошибка бэкапа" "Ошибка при создании бэкапа для таблицы ${TABLE_NAME} из базы данных ${DB_NAME}." 10
    fi
}

# Получаем список всех баз данных, кроме системных
DATABASES=$(mysql -h $MYSQLSLAVEHOST -P 3307 -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

# Выполняем бэкап для каждой базы данных и её таблиц
for DB in $DATABASES; do
    TABLES=$(mysql -h $MYSQLSLAVEHOST -P 3307 -e "SHOW TABLES IN ${DB};" | tail -n +2)
    for TABLE in $TABLES; do
        backup_table $DB $TABLE
    done
done

send_gotify_message "Бэкап завершен" "Все базы данных успешно сохранены." 5
