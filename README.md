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

BORGbackup 
на хосте создать ключ и поместить в роль с borgbackup_server

ansible-playbook -i "10.10.5.24," borgbackup.yaml     на хосте 

ansible-playbook -i "10.10.5.19," borgbackup_server.yaml  на сервере    



VPN

Создаем сервер
ansible-playbook -i "10.10.5.24," openvpn_server.yaml  
Клиент
ansible-playbook -i "10.10.5.19," openvpn_client.yaml  

Докер файлы и конфигурацией для ocserv в openconnect_VPN

Freeipa
Первичная настройка без создания пользователей 
Создаем сервер
ansible-playbook -i "10.10.5.24," freeipa_server.yaml  
Клиент
ansible-playbook -i "10.10.5.19," freeipa_client.yaml  


PXE
Поднимает серврер apache2 и tftp сервер 
Прописать на DHCP настройки этого сервера 
Поправить под себя файл template/user-data.cfg.j2

ansible-playbook -i "10.10.5.24," pxe.yaml         
Роль скачает и распакует заложенные в пеерменных образа и сразу добавит из в файл Pxeconfig по дефолту будет грузится 25.10

DNS
ansible-playbook -i "10.10.5.24," dns-server.yaml
ansible-playbook -i "10.10.5.24," dns-client.yaml  

bond и vlan

bond.ymal собирает bond из 2 интерфейсов
ansible-playbook -i "10.10.5.24," bond.yaml  
vlan.ymal создает vlan на интерфейс
ansible-playbook -i "10.10.5.24," vlan.yaml  