drop database IF EXISTS zipkin;
CREATE DATABASE zipkin character set utf8 collate utf8_general_ci;
GRANT ALL PRIVILEGES ON `zipkin`.* TO 'lens'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;