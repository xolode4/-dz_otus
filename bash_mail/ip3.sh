#!/bin/bash

# Настройки
LOG_FILE="/var/log/apache2/access.log"  # Путь к логу веб-сервера
ERROR_LOG_FILE="/var/log/apache2/error.log"
LOCK_FILE="/var/tmp/log_analyzer.lock"
STATE_FILE="/var/tmp/log_analyzer.state"
EMAIL_TO=""
EMAIL_SUBJECT="Hourly Web Server Report"

# Предотвращение одновременного запуска


exec 200>$LOCK_FILE     # Открываем дескриптор 200 для файла блокировки
flock -n 200 || exit 1  # Проверка блокировки, если не удалось - выходим

LAST_POS=0
if [[ -f $STATE_FILE ]]; then
    LAST_POS=$(cat $STATE_FILE)
fi

# Определяем текущий размер лога
CURRENT_POS=$(stat -c%s "$LOG_FILE")

# Если лог был очищен, начинаем с начала
if [[ $LAST_POS -gt $CURRENT_POS ]]; then
    LAST_POS=0
fi

# Анализируем логи с последнего места
LOG_DATA=$(tail -c +$((LAST_POS+1)) "$LOG_FILE")

# Обновляем сохранённую позицию
echo $CURRENT_POS > $STATE_FILE

# Анализ IP-адресов
TOP_IPS=$(echo "$LOG_DATA" | awk '{print $1}' | sort | uniq -c | sort -nr | head -10)

# Анализ запрашиваемых URL
TOP_URLS=$(echo "$LOG_DATA" | awk '{print $7}' | sort | uniq -c | sort -nr | head -10)

# Ошибки сервера
ERRORS=$(tail -n 50 "$ERROR_LOG_FILE")

# HTTP-коды ответов
HTTP_CODES=$(echo "$LOG_DATA" | awk '{print $9}' | grep -Eo "[0-9]{3}" | sort | uniq -c | sort -nr)

# Формируем письмо
REPORT="Hourly Web Server Report:

Top 10 IPs:
$TOP_IPS

Top 10 URLs:
$TOP_URLS

Errors (last 50 lines):
$ERRORS

HTTP Status Codes:
$HTTP_CODES"

# Отправка письма
#echo -e "$REPORT" | mailx -s "$EMAIL_SUBJECT" "$EMAIL_TO"
echo -e "$REPORT" 
# Освобождение блокировки
trap 'flock -u 200' EXIT
#flock -u 200
