# lens_2026_deployment




| 容器                     | 内部IP地址       | 内部端口 | 外部端口  | 域名                |
|------------------------|--------------|------|-------|-------------------|
| **---- Database ----** |              |      |       |                   |
| lens-mariadb           | 172.28.0.11  | 3306 | 33306 |                   |
| lens-mariadb-adminer   | 172.28.0.12  | 8080 | 38080 |                   |
| lens-redis             | 172.28.0.13  | 6379 | 6379  |                   |
| **---- Infra ----**    |              |      |       |                   |
| lens-infra-nginx       | 172.28.0.80  | 80   | 80    |                   |
| lens-nacos             | 172.28.0.21  |    8848  |   8848    | nacos.chentown.cn |
| lens-zipkin            |              |      |       |                   |
| lens-rabbitmq          |              |      |       |                   |
| lens-sentinel          |              |      |       |                   |
|                        |              |      |       |                   |
|                        |              |      |       |                   |
| **---- Platform ----** |              |      |       |                   |
| lens-platform-gateway  | 172.28.0.40  |      |       |                   |
| lens-platform-auth     | 172.28.0.41  |      |       |                   |
|                        |              |      |       |                   |
|                        |              |      |       |                   |
|                        |              |      |       |                   |
|    **---- Blog ----**|              |      |       |                   |
|lens-blog-admin-backend                           | 172.28.0.102 |      |       |                   |
|lens-blog-admin-vue-frontend                     |              |      |       |                   |
|               lens-blog-backend                    | 172.28.0.101 |      |       |                   |
|                   lens-blog-vue-frontend         | 172.28.0.181 |      |       |                   |
|                                                  |              |      |       |                   |
|    lens-blog-search                              |              |      |       |                   |
|              lens-blog-sms                       |              |      |       |                   |
|    lens-blog-picture                             | 172.28.0.112 |      |       |                   |
|lens-blog-spider                                  |              |      |       |                   |
|**---- WX ----**                               |              |      |       |                   |
|lens-gzh-server                                   | 172.28.0.131 |      |       |                   |
|                 lens-gzh-frontend                    | 172.28.0.171  |      |       |                   |
|                                                  |              |      |       |         admin.gzh.malakj.com           |
