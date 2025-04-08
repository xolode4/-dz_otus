CREATE USER 'slave'@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'slave_password';
GRANT ALL PRIVILEGES ON *.* TO 'slave'@'%' WITH GRANT OPTION;
CREATE USER 'backup_user_otus'@'%' IDENTIFIED WITH 'caching_sha2_password'  BY 'backup_password_otus';
GRANT SELECT, SHOW VIEW, LOCK TABLES, RELOAD, PROCESS, EVENT, REPLICATION CLIENT ON *.* TO 'backup_user_otus'@'%';
FLUSH PRIVILEGES;
SET GLOBAL server_id = 2;
CHANGE REPLICATION SOURCE TO  SOURCE_HOST='mysql-master',  SOURCE_USER='replica_user',  SOURCE_PASSWORD='replica_password',  SOURCE_AUTO_POSITION=1,  GET_SOURCE_PUBLIC_KEY=1;
START REPLICA;
