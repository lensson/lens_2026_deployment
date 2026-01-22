drop database lens_blog;
CREATE DATABASE lens_blog character set utf8 collate utf8_general_ci;
GRANT ALL PRIVILEGES ON `lens_blog`.* TO 'lens'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;