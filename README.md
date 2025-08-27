---

# 🛠 Ansible Playbook Collection

Сборник Ansible-плейбуков для автоматизации настройки серверов: от NFS, VPN, FreeIPA, до логирования, PXE и PostgreSQL.

---

## ⚙️ Перед запуском

Убедитесь, что вы:

* Распространили SSH-ключ на нужный хост
* Или используете параметры `-u USER` (имя пользователя), `-k` (пароль), `-K` (become-пароль)

Пример команды:

```bash
ansible-playbook -i "IP_ХОСТА," nfs-server.yaml \
  -e "nfs_server_export=[{'path': '/mnt/nfs-share', 'allowed_servers': '*.home.lcl', 'allowed_parametrs': 'rw,sync,no_subtree_check,no_root_squash'}]" \
  -u root -k
```

В появившемся диалоге введите пароль:
`SSH password: <ваш_пароль>`

---

## ✅ Протестированные роли

* `nfs-server`
* `nfs-mount`
* `nginx`

Запуск:

```bash
ansible-playbook -i "IP_ХОСТА," <ФАЙЛ>.yaml
```

---

## 📁 Переменные

Все переменные находятся в папке `vars/` внутри каждой роли.

---

## 🚀 Запуск ролей

### NFS Server

```bash
ansible-playbook -i "IP," nfs-server.yaml \
  -e "nfs_server_export=[{'path': '/mnt/nfs-share', 'allowed_servers': '*.home.lcl', 'allowed_parametrs': 'rw,sync,no_subtree_check,no_root_squash'}]"
```

### NGINX

```bash
ansible-playbook -i "10.10.10.56," nginx.yaml
ansible-playbook -i "10.10.10.56," nginx.yaml -e "nginx_server_port=9090"
```

### NFS Mount

```bash
ansible-playbook -i "10.10.10.56," nfs-mount.yaml
```

### mdadm

```bash
ansible-playbook -i "10.10.10.56," mdadm.yaml
```

---

## 📦 Содержание репозитория

### `firstlogon/`

Пакет первого входа в систему
Мини-инструкция внутри директории `repository/`

---

## 🧠 Прочие роли

### ZFS

Скрипт и мини-хелпер в соответствующей директории.

---

### GRUB

* Изменение параметров ядра
* Переименование LVM-томов

---

### SYSTEMD

* Сервис, мониторящий лог-файл раз в 30 секунд на ключевое слово (указывается в `/etc/default`)
* `spawn-fcgi`: создан `systemd`-юнит из [init-скрипта](https://gist.github.com/cea2k/1318020)
* Расширен юнит Nginx для запуска нескольких экземпляров с разными конфигами

Запуск:

```bash
ansible-playbook -i "10.10.10.58," systemd.yaml
```

---

### PS\_AX

```bash
bash ps_ax/ps_ax.sh
```

---

### Mail (bash)

* Раскомментируйте строку с отправкой и укажите почту
* Скрипт выводит данные в консоль

Запуск:

```bash
bash mail_mail/ip3.sh
# или через cron:
crontab -e
0 * * * * ~/mail_mail/ip3.sh
```

---

### Пользователи и группы

```bash
ansible-playbook -i "IP," create_group.yaml -u root -k
ansible-playbook -i "IP," create_user.yaml -u root -k
ansible-playbook -i "IP," script_cron.yaml -u root -k
ansible-playbook -i "IP," add_in_file.yaml -u root -k
```

---

## 📝 Сбор и хранение логов

```bash
ansible-playbook -i "IP," rsyslog_server.yaml -u root -k
ansible-playbook -i "IP," rsyslog_client.yaml -u root -k
```

---

## 🔐 BORG Backup

1. На хосте: создайте ключ и добавьте в роль `borgbackup_server`

```bash
ansible-playbook -i "10.10.5.24," borgbackup.yaml
ansible-playbook -i "10.10.5.19," borgbackup_server.yaml
```

---

## 🔐 VPN

### OpenVPN

**Сервер:**

```bash
ansible-playbook -i "10.10.5.24," openvpn_server.yaml
```

**Клиент:**

```bash
ansible-playbook -i "10.10.5.19," openvpn_client.yaml
```

### OpenConnect (ocserv)

Docker-файлы и конфигурация в `openconnect_VPN/`

---

## 👤 FreeIPA

Первичная настройка (без создания пользователей):

```bash
ansible-playbook -i "10.10.5.24," freeipa_server.yaml
ansible-playbook -i "10.10.5.19," freeipa_client.yaml
```

---

## 📡 PXE

Настраивает Apache2 и TFTP-сервер.
На DHCP-сервере укажите IP PXE-сервера.
Редактируйте шаблон: `template/user-data.cfg.j2`

```bash
ansible-playbook -i "10.10.5.24," pxe.yaml
```

Образы автоматически скачиваются, распаковываются и добавляются в PXE-меню.
По умолчанию используется Ubuntu 25.10.

---

## 🌐 DNS

```bash
ansible-playbook -i "10.10.5.24," dns-server.yaml
ansible-playbook -i "10.10.5.24," dns-client.yaml
```

---

## 🔗 Bonding и VLAN

### Bond

```bash
ansible-playbook -i "10.10.5.24," bond.yaml
```

### VLAN

```bash
ansible-playbook -i "10.10.5.24," vlan.yaml
```

---

## 🐘 PostgreSQL

```bash
ansible-playbook -i inventory.yaml postgres_install.yaml
ansible-playbook -i inventory.yaml postgres_replica.yaml
ansible-playbook -i inventory.yaml postgres_barman.yaml
```

---
## Docker web
```bash

ansible-playbook -i inventory.yaml web_docker.yaml

```

---
## Knockd port + forward
```bash

  children:

    routers:
      hosts:
        inetRouter:
          ansible_host: 10.10.5.26
        inetRouter2:
          ansible_host: 10.10.5.25
    servers:
      hosts:
        centralServer:
          ansible_host: 10.10.5.25
    clients:
      hosts:
        centralRouter:
          ansible_host: 10.10.5.25



ansible-playbook -i inventory/prod.yml site.yml

Сделал локальный перебос

Проверка 
sudo iptables -t nat -L PREROUTING -n --line-numbers | grep 8080
sudo iptables -t nat -L OUTPUT     -n --line-numbers | grep 8080

knokd открвает для всех 
```

