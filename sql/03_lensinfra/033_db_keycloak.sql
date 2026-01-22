drop database IF EXISTS keycloak;
CREATE DATABASE keycloak character set utf8 collate utf8_general_ci;
GRANT ALL PRIVILEGES ON `keycloak`.* TO 'lens'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;