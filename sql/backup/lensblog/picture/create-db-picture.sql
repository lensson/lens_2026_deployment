drop database lens_blog_picture;
CREATE DATABASE lens_blog_picture character set utf8 collate utf8_general_ci;
GRANT ALL PRIVILEGES ON `lens_blog_picture`.* TO 'lens'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;