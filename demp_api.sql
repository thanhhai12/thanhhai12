CREATE DATABASE IF NOT EXISTS demo_api;
USE demo_api;

CREATE TABLE IF NOT EXISTS person (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    age INT
);
