 CREATE TABLE IF NOT EXISTS users (
     id INT AUTO_INCREMENT PRIMARY KEY,
     username VARCHAR(50) NOT NULL,
     password VARCHAR(255) NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

INSERT INTO users (username, password) VALUES ('test_user', 'password123');
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO products (name, price) VALUES ('Product 1', 19.99);
INSERT INTO products (name, price) VALUES ('Product 2', 29.99);
INSERT INTO products (name, price) VALUES ('Product 2', 39.99);
ALTER USER 'root'@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'master_password';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
CREATE USER 'master'@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'master_password';
GRANT REPLICATION SLAVE ON *.* TO 'master'@'%';
CREATE USER 'replica_user'@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'replica_password';
GRANT REPLICATION SLAVE ON *.* TO 'replica_user'@'%';
FLUSH PRIVILEGES;