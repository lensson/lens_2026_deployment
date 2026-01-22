INSERT INTO nacos.config_info (id, data_id, group_id, content, md5, gmt_create, gmt_modified, src_user, src_ip, app_name, tenant_id, c_desc, c_use, effect, type, c_schema) VALUES (1, 'lens-auth.yaml', 'DEFAULT_GROUP', 'spring:
  jackson:
    date-format: yyyy-MM-dd HH:mm:ss
  redis:
    database: 0
    port: 6379
    host: ${lens-redis:localhost}
management:
  endpoints:
    web:
      exposure:
        include: "*"
# 日志配置
logging:
  level:
    com.lens: debug
    org.springframework: info', 'b18dab4961e232bdb29edd6e6effe539', '2020-10-29 01:22:26', '2020-11-20 07:37:16', null, '172.21.0.1', '', '', '', '', '', 'yaml', '');
INSERT INTO nacos.config_info (id, data_id, group_id, content, md5, gmt_create, gmt_modified, src_user, src_ip, app_name, tenant_id, c_desc, c_use, effect, type, c_schema) VALUES (2, 'lens-gateway.yaml', 'DEFAULT_GROUP', 'spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          jwk-set-uri: ''http://localhost:8850/rsa/publicKey''
  redis:
    database: 0
    host: ${lens-redis:localhost}
    port: 6379
  cloud:
    gateway:
      discovery:
        locator:
          enabled: true
        lowerCaseServiceId: true
      routes:
        - id: gzh
          uri: lb://gzh
          predicates:
            - Path=/api/v1/wx/gzh/**
          filters:
            - StripPrefix=4
        - id: lens-auth
          uri: lb://lens-auth
          predicates:
            - Path=/api/v1/auth/**
          filters:
            - StripPrefix=3
        - id: lens-blog-admin-backend
          uri: lb://lens-blog-admin-backend
          predicates:
            - Path=/api/v1/blog/admin/**
          filters:
            - StripPrefix=4
        - id: lens-blog-backend
          uri: lb://lens-blog-backend
          predicates:
            - Path=/api/v1/blog/web/**
          filters:
            - StripPrefix=4
        - id: lens-blog-picture
          uri: lb://lens-blog-picture
          predicates:
            - Path=/api/v1/blog/picture/**
          filters:
            - StripPrefix=4
        - id: lens-blog-search
          uri: lb://lens-blog-search
          predicates:
            - Path=/api/v1/blog/search/**
          filters:
            - StripPrefix=4
secure:
  ignore:
    urls:
      - "/actuator/**"
      - "/api/v1/auth/oauth/token"
      - "/api/v1/blog/admin/**"
      - "/api/v1/blog/web/**"

# 日志配置
logging:
  level:
    com.lens: debug
    org.springframework: debug', '98e96d413366a5867cda0a459ef63eb2', '2020-11-09 05:04:34', '2020-12-07 09:03:05', null, '172.28.0.1', '', '', '', '', '', 'yaml', '');
INSERT INTO nacos.config_info (id, data_id, group_id, content, md5, gmt_create, gmt_modified, src_user, src_ip, app_name, tenant_id, c_desc, c_use, effect, type, c_schema) VALUES (79, 'lens-blog-admin-backend.yaml', 'DEFAULT_GROUP', 'server:
  port: 9002

#阿里大于
templateCode: SMS_XXXXXX #短信模板编号
signName: 麻辣博客
#项目名称
PROJECT_NAME: 麻辣博客

file:
  upload:
    path: ${user.home}/containers/${spring.application.name}/data/files
# 邮箱验证
lensBlog:
  email: lensson_chen@sina.com

# 麻辣博客登录默认密码
DEFAULE_PWD: lens


#博客相关配置
BLOG:
  HOT_COUNT: 5 #热门博客数量
  NEW_COUNT: 15 #最新博客数据
  FIRST_COUNT: 5 #一级推荐
  SECOND_COUNT: 2 #二级推荐
  THIRD_COUNT: 3 #三级推荐
  FOURTH_COUNT: 5 #四级推荐

#spring
spring:
  jackson:
    serialization:
      INDENT_OUTPUT: true
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: Asia/Shanghai
  jmx:
    default-domain: lens_blog_admin_backend
  thymeleaf:
    cache: true   #关闭缓存
  application:
    name: lens-blog-admin-backend
  security:
    user:
      name: lens
      password: lens

  # sleuth 配置
  sleuth:
    web:
      client:
        enabled: true
    sampler:
      probability: 1.0 # 采样比例为: 0.1(即10%),设置的值介于0.0到1.0之间，1.0则表示全部采集。
  # zipkin 配置
  zipkin:
    base-url: http://${lens-zipkin:localhost}:9411  # 指定了Zipkin服务器的地址

  # DATABASE CONFIG
  datasource:
    username: lens
    password: lens
    url: jdbc:mysql://${lens-mariadb:localhost}:33306/lens_blog?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&transformedBitIsBoolean=true&useSSL=false&serverTimezone=Asia/Shanghai
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.alibaba.druid.pool.DruidDataSource
    # 初始化大小，最小，最大
    initialSize: 20
    minIdle: 5
    maxActive: 200
    #连接等待超时时间
    maxWait: 60000
    #配置隔多久进行一次检测(检测可以关闭的空闲连接)
    timeBetweenEvictionRunsMillis: 60000
    #配置连接在池中的最小生存时间
    minEvictableIdleTimeMillis: 300000
    validationQuery: SELECT 1 FROM DUAL
    dbcp:
      remove-abandoned: true
      #泄露的连接可以被删除的超时时间（秒），该值应设置为应用程序查询可能执行的最长时间
      remove-abandoned-timeout: 180
    testWhileIdle: true
    testOnBorrow: false
    testOnReturn: false
    poolPreparedStatements: true
    #配置监控统计拦截的filters，去掉后监控界面sql无法统计，''wall''用于防火墙
    filters: stat,wall,log4j
    maxPoolPreparedStatementPerConnectionSize: 20
    useGlobalDataSourceStat: true
    connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=500

  #redis
  redis:
    host: ${lens-redis:localhost}
    port: 6379

  rabbitmq:
    host: ${lens-rabbitmq:localhost} #rabbitmq的主机ip
    port: 5672
    username: lens
    password: lens

  boot:
    admin:
      client:
        enabled: true
        url: http://${lens-blog-monitor:localhost}:9020
        username: lens
        password: lens
        instance:
          service-base-url: http://${lens-blog-admin-backend:localhost}:9002

# 或者：
feign.hystrix.enabled: false #索性禁用feign的hystrix支持

management:
  endpoints:
    web:
      exposure:
        include: "*"
  endpoint:
    health:
      show-details: always

#mybatis
mybatis-plus:
  mapper-locations: classpath:/mapper/*Mapper.xml
  #实体扫描，多个package用逗号或者分号分隔
  typeAliasesPackage: com.lens.blog.common.entity
  global-config:
    # 数据库相关配置
    db-config:
      #主键类型  0:"数据库ID自增", 1:"用户输入ID",2:"全局唯一ID (数字类型唯一ID)", 3:"全局唯一ID UUID";
      id-type: UUID
      #字段策略 IGNORED:"忽略判断",NOT_NULL:"非 NULL 判断"),NOT_EMPTY:"非空判断"
      field-strategy: NOT_EMPTY
      #驼峰下划线转换
      column-underline: true
      #数据库大写下划线转换
      #capital-mode: true
      #逻辑删除配置
      logic-delete-value: 0
      logic-not-delete-value: 1
      db-type: mysql
    #刷新mapper 调试神器
    refresh: true
  # 原生配置
  configuration:
    map-underscore-to-camel-case: true
    cache-enabled: false

##jwt配置
tokenHead: bearer_
tokenHeader: Authorization
isRememberMeExpiresSecond: 259200 #记住账号为3天有效
audience:
  clientId: 098f6bcd4621d373cade4e832627b4f6
  base64Secret: MDk4ZjZiY2Q0NjIxZDM3M2NhZGU0ZTgzMjYyN2I0ZjY=
  name: lensblog
  expiresSecond: 3600  #1个小时 3600
  refreshSecond: 300 # 刷新token的时间 5分钟', '67bd93c42cb9a43a44efcccf4c60c806', '2020-11-12 00:47:37', '2020-11-20 07:17:36', null, '172.21.0.1', '', '', '', '', '', 'yaml', '');
INSERT INTO nacos.config_info (id, data_id, group_id, content, md5, gmt_create, gmt_modified, src_user, src_ip, app_name, tenant_id, c_desc, c_use, effect, type, c_schema) VALUES (90, 'lens-blog-backend.yaml', 'DEFAULT_GROUP', 'server:
  port: 9001
#阿里大于
templateCode: SMS_XXXXXX #短信模板编号

signName: 麻辣博客
# 项目英文名
PROJECT_NAME_EN: lensBlog
#项目名称
PROJECT_NAME: 麻辣博客

data:
  # 门户页面
  webSite:
    url: http://${lens-gateway:localhost}:8849/#/
  # mogu_web网址，用于第三方登录回调
  web:
    url: http://${lens-blog-backend:localhost}:9001

file:
  upload:
    path: ${user.home}/containers/${spring.application.name}/data/files

# 麻辣博客登录默认密码
DEFAULE_PWD: lens

#请求限制参数
request-limit:
  start: false # 是否开启请求限制，默认关闭
  amount: 100 # 100次
  time: 60000 # 1分钟

#博客相关配置
BLOG:
  HOT_COUNT: 5 #热门博客数量
  HOT_TAG_COUNT: 20 #热门标签数量
  FRIENDLY_LINK_COUNT: 20 #友情链接数
  NEW_COUNT: 15 #最新博客数据
  FIRST_COUNT: 5 #一级推荐
  SECOND_COUNT: 2 #二级推荐
  THIRD_COUNT: 3 #三级推荐
  FOURTH_COUNT: 5 #四级推荐
  USER_TOKEN_SURVIVAL_TIME: 168 # toekn令牌存活时间, 7天  168 = 7*24
  # 原创模板
  ORIGINAL_TEMPLATE: 本文为麻辣博客原创文章，转载无需和我联系，但请注明来自麻辣博客 http://www.moguit.cn
  # 转载模板
  REPRINTED_TEMPLATE: 本着开源共享、共同学习的精神，本文转载自 %S ，版权归 %S 所有，如果侵权之处，请联系博主进行删除，谢谢~
spring:
  jmx:
    default-domain: lens_blog_backend
  # freemarker相关配置
  freemarker:
    charset: utf-8
    suffix: .ftl
    content-type: text/html
    template-loader-path: classpath:/templates
  # jackson配置响应时间格式、时区
  jackson:
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: Asia/Shanghai
  application:
    name: lens-blog-backend
  security:
    user:
      name: lens
      password: lens

  # DATABASE CONFIG
  datasource:
    username: lens
    password: lens
    url: jdbc:mysql://${lens-mariadb:localhost}:33306/lens_blog?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&transformedBitIsBoolean=true&useSSL=false&serverTimezone=Asia/Shanghai
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.alibaba.druid.pool.DruidDataSource
    # 初始化大小，最小，最大
    initialSize: 5
    minIdle: 5
    maxActive: 50
    #连接等待超时时间
    maxWait: 60000
    #配置隔多久进行一次检测(检测可以关闭的空闲连接)
    timeBetweenEvictionRunsMillis: 60000
    #配置连接在池中的最小生存时间
    minEvictableIdleTimeMillis: 300000
    dbcp:
      remove-abandoned: true
      #泄露的连接可以被删除的超时时间（秒），该值应设置为应用程序查询可能执行的最长时间
      remove-abandoned-timeout: 180
    testWhileIdle: true
    testOnBorrow: false
    testOnReturn: false
    poolPreparedStatements: true
    #配置监控统计拦截的filters，去掉后监控界面sql无法统计，''wall''用于防火墙
    filters: stat,wall,log4j
    maxPoolPreparedStatementPerConnectionSize: 20
    useGlobalDataSourceStat: true
    connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=500

  #Solr配置信息
  data:
    solr:
      host: http://{lens-solr:localhost}:8983/solr
      core: collection1
      repositories:
        enabled: true
  #redis
  redis:
    host: ${lens-redis:localhost} #redis的主机ip
    port: 6379
    #password: mogu2018  # 客户端没有设置密码，服务器中redis默认密码为 mogu2018

  rabbitmq:
    host: ${lens-rabbitmq:localhost} #rabbitmq的主机ip
    port: 5672
    username: lens
    password: lens

  boot:
    admin:
      client:
        enabled: true
        url: http://${lens-blog-monitor:localhost}:9020
        username: lens
        password: lens
        instance:
          service-base-url: http://${lens-blog-backend:localhost}:9001

  # sleuth 配置
  sleuth:
    web:
      client:
        enabled: true
    sampler:
      probability: 1.0 # 采样比例为: 0.1(即10%),设置的值介于0.0到1.0之间，1.0则表示全部采集。
  # zipkin 配置
  zipkin:
    base-url: http://${lens-zipkin:localhost}:9411  # 指定了Zipkin服务器的地址



# 或者：
feign.hystrix.enabled: false # 索性禁用feign的hystrix支持
# 设置feign调用超时时间
ribbon:
  ReadTimeout: 20000
  ConnectTimeout: 20000

management:
  endpoints:
    web:
      exposure:
        include: "*"
  endpoint:
    health:
      show-details: always

#mybatis
mybatis-plus:
  mapper-locations: classpath:/mapper/*Mapper.xml
  #实体扫描，多个package用逗号或者分号分隔
  typeAliasesPackage: com.lens.blog.common.entity
  global-config:
    # 数据库相关配置
    db-config:
      #主键类型  0:"数据库ID自增", 1:"用户输入ID",2:"全局唯一ID (数字类型唯一ID)", 3:"全局唯一ID UUID";
      id-type: UUID
      #字段策略 IGNORED:"忽略判断",NOT_NULL:"非 NULL 判断"),NOT_EMPTY:"非空判断"
      field-strategy: NOT_EMPTY
      #驼峰下划线转换
      column-underline: true
      #数据库大写下划线转换
      #capital-mode: true
      #逻辑删除配置
      logic-delete-value: 0
      logic-not-delete-value: 1
      db-type: mysql
    #刷新mapper 调试神器
    refresh: true
  # 原生配置
  configuration:
    map-underscore-to-camel-case: true
    cache-enabled: false

# 第三方登录，参考 http://moguit.cn/#/info?blogUid=fe9e352eb95205a08288f21ec3cc69e0
justAuth:
  clientId:
    gitee: ec2dba332701caa209935512c69fc7962530b8619acd9b6cb03106a7c13c1c5e
    github: c99bfe31f8774ec8e242
    qq: XXXXXXXXXXXXXXX  # 改成自己的
  clientSecret:
    gitee: 993930de16b61b8146f7d30c693afd328b4d42116cf2da748f275077e4ef5e47
    github: ec088d14ab8076e2beed58fcb95e37a0fc586618
    qq: XXXXXXXXXXXXXXXXXX # 改成自己的

# uniapp相关配置
uniapp:
  qq:
    appid: 1110769790
    secret: zWZBLzBcekMUTP60
    grant_type: authorization_code', '17cebacfd61e5f2be4deb4fcc8908888', '2020-11-12 05:02:58', '2020-11-20 07:20:24', null, '172.21.0.1', '', '', '', '', '', 'yaml', '');
INSERT INTO nacos.config_info (id, data_id, group_id, content, md5, gmt_create, gmt_modified, src_user, src_ip, app_name, tenant_id, c_desc, c_use, effect, type, c_schema) VALUES (101, 'lens-blog-sms.yaml', 'DEFAULT_GROUP', '#app
server:
  port: 9011

#阿里大于
accessKeyId: XXXXXXXXXXXXXXXXXXXXX #修改成自己的
accessKeySecret: XXXXXXXXXXXXXXXXXXXXXXX #修改成自己的

#spring
spring:
  jmx:
    default-domain: lens_blog_sms
  thymeleaf:
    cache: true   #关闭缓存
  application:
    name: lens-blog-sms
  security:
    user:
      name: lens
      password: lens
  #redis
  redis:
    host: ${lens-redis:localhost} #redis的主机ip
    port: 6379

  #RabbitMq
  rabbitmq:
    host: ${lens-rabbitmq:localhost} #rabbitmq的主机ip
    port: 5672
    username: lens
    password: lens
  #mail
  mail:
    username: lensson_chen@sina.com
    password: lensson1 #授权码开启SMTP服务里设置
    host: smtp.sina.com
    default-encoding: UTF-8
    properties:
      mail:
        smtp:
          ssl:
            enable: true
          socketFactory:
            port: 465
            class: javax.net.ssl.SSLSocketFactory
          auth: true
          starttls:
            enable: false
          timeout: 600000
          connectiontimeout: 600000
  boot:
    admin:
      client:
        enabled: true
        url: http://${lens-blog-monitor:localhost}:9020
        username: lens
        password: lens
        instance:
          service-base-url: http://${lens-blog-sms:localhost}:9011

  # sleuth 配置
  sleuth:
    web:
      client:
        enabled: true
    sampler:
      probability: 1.0 # 采样比例为: 0.1(即10%),设置的值介于0.0到1.0之间，1.0则表示全部采集。
  # zipkin 配置
  zipkin:
    base-url: http://${lens-zipkin:localhost}:9411  # 指定了Zipkin服务器的地址

management:
  endpoints:
    web:
      exposure:
        include: "*"
  endpoint:
    health:
      show-details: always', '853407740ae07113b5e9ee1bbe215ea4', '2020-11-13 00:31:21', '2020-11-19 01:45:08', null, '172.21.0.1', '', '', '', '', '', 'yaml', '');
INSERT INTO nacos.config_info (id, data_id, group_id, content, md5, gmt_create, gmt_modified, src_user, src_ip, app_name, tenant_id, c_desc, c_use, effect, type, c_schema) VALUES (109, 'lens-blog-picture.yaml', 'DEFAULT_GROUP', '#app
server:
  port: 9012

file:
  upload:
    path: ${user.home}/containers/${spring.application.name}/data/files

#spring
spring:
  servlet:
    multipart:
      enabled: true
      max-file-size: 100MB # 修改单次文件上传文件大小不能超过100MB
      max-request-size: 500MB # 设置单次文件请求总大小不能超过500MB

  jmx:
    default-domain: lens_blog_picture
  thymeleaf:
    cache: true   #关闭缓存
  application:
    name: lens-blog-picture
  security:
    user:
      name: lens
      password: lens
  boot:
    admin:
      client:
        enabled: true
        url: http://${lens-blog-monitor:localhost}:9020
        username: lens
        password: lens
        instance:
          service-base-url: http://${lens-blog-picture:localhost}:9012

  #redis
  redis:
    host: ${lens-redis:localhost} #redis的主机ip
    port: 6379
    #password: mogu2018  # 客户端没有设置密码，服务器中redis默认密码为 mogu2018

  # sleuth 配置
  sleuth:
    web:
      client:
        enabled: true
    sampler:
      probability: 1.0 # 采样比例为: 0.1(即10%),设置的值介于0.0到1.0之间，1.0则表示全部采集。
  # zipkin 配置
  zipkin:
    base-url: http://${lens-zipkin:localhost}:9411  # 指定了Zipkin服务器的地址

  # DATABASE CONFIG
  datasource:
    username: lens
    password: lens
    url: jdbc:mysql://${lens-mariadb:localhost}:33306/lens_blog_picture?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&transformedBitIsBoolean=true&useSSL=false&serverTimezone=GMT%2B8
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.alibaba.druid.pool.DruidDataSource

    initialSize: 5
    minIdle: 5
    maxActive: 20
    maxWait: 60000
    timeBetweenEvictionRunsMillis: 60000
    minEvictableIdleTimeMillis: 300000
    testWhileIdle: true
    testOnBorrow: false
    testOnReturn: false
    poolPreparedStatements: true

    #配置监控统计拦截的filters，去掉后监控界面sql无法统计，''wall''用于防火墙
    filters: stat,wall,log4j
    maxPoolPreparedStatementPerConnectionSize: 20
    useGlobalDataSourceStat: true
    connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=500
  mvc:
    static-path-pattern: /upload/**
  resources:
    static-locations: classpath:/static/upload

management:
  endpoints:
    web:
      exposure:
        include: "*"
  endpoint:
    health:
      show-details: always

#mybatis
mybatis-plus:
  mapper-locations: classpath:/mapper/*Mapper.xml
  #实体扫描，多个package用逗号或者分号分隔
  typeAliasesPackage: com.lens.blog.picture.entity
  global-config:
    # 数据库相关配置
    db-config:
      #主键类型  0:"数据库ID自增", 1:"用户输入ID",2:"全局唯一ID (数字类型唯一ID)", 3:"全局唯一ID UUID";
      id-type: UUID
      #字段策略 IGNORED:"忽略判断",NOT_NULL:"非 NULL 判断"),NOT_EMPTY:"非空判断"
      field-strategy: NOT_EMPTY
      #驼峰下划线转换
      column-underline: true
      #数据库大写下划线转换
      #capital-mode: true
      #逻辑删除配置
      logic-delete-value: 0
      logic-not-delete-value: 1
      db-type: mysql
    #刷新mapper 调试神器
    refresh: true
  # 原生配置
  configuration:
    map-underscore-to-camel-case: true
    cache-enabled: false', '4e172528fe7a7e8e2bf4bf45d086ea83', '2020-11-13 08:17:49', '2020-11-23 02:29:03', null, '172.24.0.1', '', '', '', '', '', 'yaml', '');
INSERT INTO nacos.config_info (id, data_id, group_id, content, md5, gmt_create, gmt_modified, src_user, src_ip, app_name, tenant_id, c_desc, c_use, effect, type, c_schema) VALUES (111, 'lens-blog-monitor.yaml', 'DEFAULT_GROUP', 'server:
  port: 9020

spring:
  application:
    name: lens-blog-monitor
  security:
    user:
      name: lens
      password: lens
  boot:
    admin:
      ui:
        title: 麻辣博客监控中心
        brand: 麻辣博客监控中心
      notify:
        mail:
          enabled: false
          # 服务上下线会自动发送邮件
          #from: lensson_chen@sina.com
          #to: lensson_chen@sina.com
  redis:
    host: ${lens-redis:localhost} #redis的主机ip
    port: 6379

  #mail
  mail:
    username: lensson_chen@sina.com
    password: lensson1 #授权码开启SMTP服务里设置
    host: smtp.sina.com
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: true
          ssl:
            enable: true', '8def38472f879e2fa344e11351aff068', '2020-11-16 02:09:58', '2020-11-23 05:26:34', null, '172.24.0.1', '', '', '', '', '', 'yaml', '');
INSERT INTO nacos.config_info (id, data_id, group_id, content, md5, gmt_create, gmt_modified, src_user, src_ip, app_name, tenant_id, c_desc, c_use, effect, type, c_schema) VALUES (124, 'lens-blog-search.yaml', 'DEFAULT_GROUP', 'server:
  port: 9013
spring:
  application:
    name: lens-blog-search
  jmx:
    default-domain: lens_blog_search
  security:
    user:
      name: lens
      password: lens
  data:
    elasticsearch:
      cluster-name: elasticsearch
      cluster-nodes: ${lens-elasticsearch:localhost}:9200
    solr:
      host: http://${lens-solr:localhost}:8983/solr
      core: collection1
      repositories:
      enabled: true

  redis:
    host: ${lens-redis:localhost} #redis的主机ip
    port: 6379

  rabbitmq:
    host: ${lens-rabbitmq:localhost} #rabbitmq的主机ip
    port: 5672
    username: lens
    password: lens

  boot:
    admin:
      client:
        enabled: true
        url: http://${lens-blog-monitor:localhost}:9020
        username: lens
        password: lens
        instance:
          service-base-url: http://${lens-blog-search:localhost}:9013

  # sleuth 配置
  sleuth:
    web:
      client:
        enabled: true
    sampler:
      probability: 1.0 # 采样比例为: 0.1(即10%),设置的值介于0.0到1.0之间，1.0则表示全部采集。
  # zipkin 配置
  zipkin:
    base-url: http://${lens-zipkin:localhost}:9411  # 指定了Zipkin服务器的地址



management:
  endpoints:
    web:
      exposure:
        include: "*"
  endpoint:
    health:
      show-details: always', '8a169096cacc07796a3c55bf9c7a2391', '2020-11-16 08:39:10', '2020-11-30 05:27:04', null, '10.243.26.25', '', '', '', '', '', 'yaml', '');
INSERT INTO nacos.config_info (id, data_id, group_id, content, md5, gmt_create, gmt_modified, src_user, src_ip, app_name, tenant_id, c_desc, c_use, effect, type, c_schema) VALUES (146, 'lens-blog-spider.yaml', 'DEFAULT_GROUP', '#app
server:
  port: 9014

#spring
spring:
  jmx:
    default-domain: lens_blog_spider
  thymeleaf:
    cache: true   #关闭缓存
  application:
    name: lens-blog-spider
  security:
    user:
      name: lens
      password: lens
  boot:
    admin:
      client:
        enabled: true
        url: http://${lens-blog-monitor:localhost}:9020
        username: lens
        password: lens
        instance:
          service-base-url: http://${lens-blog-spider:localhost}:9014

  #redis
  redis:
    host: ${lens-redis:localhost}  #redis的主机ip
    port: 6379

  # sleuth 配置
  sleuth:
    web:
      client:
        enabled: true
    sampler:
      probability: 1.0 # 采样比例为: 0.1(即10%),设置的值介于0.0到1.0之间，1.0则表示全部采集。
  # zipkin 配置
  zipkin:
    base-url: http://${lens-zipkin:localhost}:9411  # 指定了Zipkin服务器的地址

  # DATABASE CONFIG
  datasource:
    username: root
    password: root
    url: jdbc:mysql://${lens-madiadb:localhost}:33306/lens_blog?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&transformedBitIsBoolean=true&useSSL=false&serverTimezone=GMT%2B8
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.alibaba.druid.pool.DruidDataSource

    initialSize: 5
    minIdle: 5
    maxActive: 20
    maxWait: 60000
    timeBetweenEvictionRunsMillis: 60000
    minEvictableIdleTimeMillis: 300000
    testWhileIdle: true
    testOnBorrow: false
    testOnReturn: false
    poolPreparedStatements: true

    #配置监控统计拦截的filters，去掉后监控界面sql无法统计，''wall''用于防火墙
    filters: stat,wall,log4j
    maxPoolPreparedStatementPerConnectionSize: 20
    useGlobalDataSourceStat: true
    connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=500


management:
  endpoints:
    web:
      exposure:
        include: "*"
  endpoint:
    health:
      show-details: always

#mybatis
mybatis-plus:
  mapper-locations: classpath:/mapper/*Mapper.xml
  #实体扫描，多个package用逗号或者分号分隔
  typeAliasesPackage: com.lens.blog.spider.entity
  global-config:
    # 数据库相关配置
    db-config:
      #主键类型  0:"数据库ID自增", 1:"用户输入ID",2:"全局唯一ID (数字类型唯一ID)", 3:"全局唯一ID UUID";
      id-type: UUID
      #字段策略 IGNORED:"忽略判断",NOT_NULL:"非 NULL 判断"),NOT_EMPTY:"非空判断"
      field-strategy: NOT_EMPTY
      #驼峰下划线转换
      column-underline: true
      #数据库大写下划线转换
      #capital-mode: true
      #逻辑删除配置
      logic-delete-value: 0
      logic-not-delete-value: 1
      db-type: mysql
    #刷新mapper 调试神器
    refresh: true
  # 原生配置
  configuration:
    map-underscore-to-camel-case: true
    cache-enabled: false', '7a3b7426fcfa370d9c29cf4b9bbe27bf', '2020-11-20 07:14:32', '2020-11-20 07:14:32', null, '172.21.0.1', '', '', null, null, null, 'yaml', null);