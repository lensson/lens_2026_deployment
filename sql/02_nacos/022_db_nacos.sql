drop database IF EXISTS nacos;
CREATE DATABASE nacos character set utf8 collate utf8_general_ci;
GRANT ALL PRIVILEGES ON `nacos`.* TO 'nacos'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `nacos`.* TO 'lens'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;