drop database plumemo;
CREATE DATABASE plumemo character set utf8 collate utf8_general_ci;
GRANT ALL PRIVILEGES ON `plumemo`.* TO 'lens'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;