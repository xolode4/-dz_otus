#!/bin/bash

set -e

# Устанавливаем ZFS
apt update && apt install -y zfsutils-linux

# Проверяем загрузку модуля ZFS
lsmod | grep zfs || modprobe zfs

# Отображаем информацию о дисках
lsblk

# Создаём пул ZFS с кэшем
zpool create -f \
  -o ashift=12 \
  -O compression=lz4 \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O relatime=on \
  -O mountpoint=/opt \
  zpool_opt /dev/sdb \
  cache /dev/sdc

# Проверяем статус пула
zpool status

# Проверяем, что каталог /opt примонтирован
if df -h | grep -q /opt; then
  echo "/opt успешно создан на ZFS"
else
  echo "Ошибка: /opt не примонтирован" >&2
  exit 1
fi

# Настраиваем автоматическое создание снапшотов
CRON_JOB="0 * * * * root zfs snapshot zpool_opt@$(date +\%Y-\%m-\%d_\%H-\%M)"
echo "$CRON_JOB" | tee /etc/cron.d/zfs-snapshots

# Проверяем список снапшотов
zfs list -t snapshot

# Создаём тестовый снапшот
zfs snapshot zpool_opt@backup-$(date +%Y-%m-%d_%H-%M)
zfs list -t snapshot

# Удаляем тестовый снапшот
TEST_SNAPSHOT="backup-$(date +%Y-%m-%d_%H-%M)"
zfs destroy zpool_opt@$TEST_SNAPSHOT
zfs list -t snapshot

echo "ZFS успешно настроен на /opt с кэшем и снапшотами!"
