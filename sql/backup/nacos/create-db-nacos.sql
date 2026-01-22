drop database IF EXISTS nacos;
CREATE DATABASE nacos character set utf8 collate utf8_general_ci;
GRANT ALL PRIVILEGES ON `nacos`.* TO 'nacos'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;