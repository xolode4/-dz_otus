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
