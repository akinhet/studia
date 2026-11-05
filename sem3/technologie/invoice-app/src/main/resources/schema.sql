CREATE DATABASE IF NOT EXISTS invoice_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE invoice_db;

CREATE TABLE IF NOT EXISTS clients (
    nip VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS articles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS invoices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_nip VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    CONSTRAINT fk_invoice_client FOREIGN KEY (client_nip) REFERENCES clients(nip) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS invoice_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT fk_item_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role ENUM('ADMIN', 'ACCOUNTANT', 'SALESMAN', 'WAREHOUSEMAN') NOT NULL
);

INSERT INTO roles (role) VALUES ('ADMIN'), ('ACCOUNTANT'), ('SALESMAN'), ('WAREHOUSEMAN');

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(30) NOT NULL,
    hash CHAR(60) NOT NULL,
    role_id INT NOT NULL,
    CONSTRAINT fk_users FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

INSERT INTO users (username, hash, role_id) VALUES ('admin', '$2a$12$pW2nWaG5MR0ts6T52wvkNOSHqkM/ytn4RSGZWqiDH0YIHG9iYC6rC', 1);

create user if not exists 'auth'@'localhost' identified by 'superduperpassword';
grant select on invoice_db.users to 'auth'@'localhost';
grant select on invoice_db.roles to 'auth'@'localhost';

create user if not exists 'app'@'localhost' identified by 'safetythird';
grant select, insert, update, delete on invoice_db.clients to 'app'@'localhost';
grant select, insert, update, delete on invoice_db.articles to 'app'@'localhost';
grant select, insert, update, delete on invoice_db.invoices to 'app'@'localhost';
grant select, insert, update, delete on invoice_db.invoice_items to 'app'@'localhost';
grant select, insert, update, delete on invoice_db.users to 'app'@'localhost';
grant select on invoice_db.users to 'app'@'localhost';
