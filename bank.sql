CREATE DATABASE IF NOT EXISTS `cashmanager`;

USE `cashmanager`;

CREATE TABLE IF NOT EXISTS `BankAccount` (
  `id` bigint(20) NOT NULL,
  `LastName` varchar(255) DEFAULT NULL,
  `balance` double DEFAULT NULL,
  `cardId` varchar(255) DEFAULT NULL,
  `firstName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `Locality` (
  `id` bigint(20) NOT NULL,
  `login` varchar(255) DEFAULT NULL,
  `pwdHash` varchar(255) DEFAULT NULL,
  `bankAccount_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK643w7xnhvwc16ae9h2yf3uovd` (`bankAccount_id`),
  CONSTRAINT `FK643w7xnhvwc16ae9h2yf3uovd` FOREIGN KEY (`bankAccount_id`) REFERENCES `BankAccount` (`id`)
);

CREATE TABLE IF NOT EXISTS `hibernate_sequence` (
  `next_val` bigint(20) DEFAULT NULL
);

INSERT INTO `BankAccount` (`id`, `lastName`, `balance`, `cardId`, `firstName`)
VALUES
(1, 'market', 100, '0be08d08-e1aa-42c8-b5b9-0ce4460f24f1', 'market'),
(2, 'client', 100, 'd01c199e-2c21-4f24-adc1-0d4c042ac1e3', 'client');

INSERT INTO `Locality` (`id`, `login`, `pwdHash`, `bankAccount_id`)
VALUES
(1, 'market@gmail.com', '$2a$10$obUGwkMajjbFhQr3Wof9IeuHfMBQGu45gDjsmR8RztpS0786hwaQG', 1),
(2, 'client@gmail.com', '$2a$10$obUGwkMajjbFhQr3Wof9IeuHfMBQGu45gDjsmR8RztpS0786hwaQG', 2);
