-- Протестированы роли nfs-server и nginx --
ansible-playbook -i "IPхоста," ФАЙЛ.yaml 

Переменные в папке var в каждой роли 

-- Запуск -- 
ansible-playbook -i "IPхоста," nfs-server.yaml -e "nfs_server_export=[{'path': 'ЧТО ООТДАЕМ ', 'allowed_servers': 'КОМУ ', 'allowed_parametrs': 'ПАРАМЕТРЫ'}]"


ansible-playbook -i "IPхоста," nfs-server.yaml -e "nfs_server_export=[{'path': '/mnt/nfs-share', 'allowed_servers': '*.home.lcl', 'allowed_parametrs': 'rw,sync,no_subtree_check,no_root_squash'}]"

-----------------------
ansible-playbook -i "10.10.10.56," nginx.yaml

ansible-playbook -i "10.10.10.56," nginx.yaml -e "nginx_server_port=9090"     



переменные пока что лежат в самой роли 