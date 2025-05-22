Перед запуском распространяем ключ и подключаемся к пользователю с привелигированными правами
иначе добавляем -u USER(root или другой юзер ) -k (пароль) -K(become пароль ) 

ansible-playbook -i "IPхоста," nfs-server.yaml -e "nfs_server_export=[{'path': 'ЧТО ООТДАЕМ ', 'allowed_servers': 'КОМУ ', 'allowed_parametrs': 'ПАРАМЕТРЫ'}]" -u root -k 

В диалоговом окне " SSH password: " Ввести пароль

-- Протестированы роли nfs-server и nginx nfs-mount  --
ansible-playbook -i "IPхоста," ФАЙЛ.yaml 

Переменные в папке var в каждой роли 

-- Запуск -- 

NFS-SERVER

ansible-playbook -i "IPхоста," nfs-server.yaml -e "nfs_server_export=[{'path': 'ЧТО ООТДАЕМ ', 'allowed_servers': 'КОМУ ', 'allowed_parametrs': 'ПАРАМЕТРЫ'}]"


ansible-playbook -i "IPхоста," nfs-server.yaml -e "nfs_server_export=[{'path': '/mnt/nfs-share', 'allowed_servers': '*.home.lcl', 'allowed_parametrs': 'rw,sync,no_subtree_check,no_root_squash'}]"

NGINX


ansible-playbook -i "10.10.10.56," nginx.yaml

ansible-playbook -i "10.10.10.56," nginx.yaml -e "nginx_server_port=9090"     


NFS-MOUNT

ansible-playbook -i "10.10.10.56," nfs-mount.yaml  


mdadm

ansible-playbook -i "10.10.10.56," mdadm.yaml  


свой репозиторий :
пакет находится в firstlogon
мини инструкция в repository

ZFS 
скрипт и мини хелпер в соответствующей дирректории 

GRUB
Изменение параметров ядра и переименовывает LVM

SYSTEMD

Создает service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/default).

Установлен spawn-fcgi и создан  unit-файл (spawn-fcgi.sevice) с помощью переделки init-скрипта (https://gist.github.com/cea2k/1318020).

Доработан unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными файлами одновременно.

Запуск ansible-playbook -i "10.10.10.58," systemd.yml


PS_AX 
Запуск bash ps_ax/ps_ax.sh


Bash mail
Раскомментировать строчку с отправкой и внести почту
Скрипт просто выводит полученные данные в консоль 
запуск bash mail_mail/ip3.sh или  crontab -e        0 * * * * ~/mail_mail/ip3.sh


Пользователи и группы. Авторизация и аутентификация_РАМ

ansible-playbook -i "IP," create_group.yaml -u root -k
ansible-playbook -i "IP," create_user.yaml -u root -k
ansible-playbook -i "IP," script_cron.yaml -u root -k
ansible-playbook -i "IP," add_in_file.yaml -u root -k

Основы сбора и хранения логов 
ansible-playbook -i "IP," rsyslog_server.yaml -u root -k
ansible-playbook -i "IP," rsyslog_client.yaml -u root -k