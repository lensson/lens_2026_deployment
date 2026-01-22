#!/bin/bash

user="root"
pass="mysql"

mysql -u "$user" -p"$pass" -h 172.28.0.11 <<EOF

  -- basic
#  source 01_root/011_user_root.sql;
#  source 01_root/012_user_lens.sql;
  -- nacos
#   source 02_nacos/021_user_nacos.sql
#   source 02_nacos/022_db_nacos.sql
#   source 02_nacos/023_table_nacos.sql
  -- infra
#  source 03_lensinfra/031_db_zipkin.sql
#  source 03_lensinfra/032_table_zipkin.sql
#  source 03_lensinfra/033_db_keycloak.sql
  -- platform
#   source 04_platform/041_db_platform.sql
#   source 04_platform/042_table_platform.sql
  -- plumemo
#   source 05_plumemo/051_db_plumemo.sql
  -- lensblog
#   source 06_lensblog/061_nacos_lensblog.sql
#   source 06_lensblog/062_db_lensblog.sql
#   source 06_lensblog/063_lensblog.sql
#   source 06_lensblog/064_db_blog_picture.sql
#   source 06_lensblog/065_blog_picture.sql
EOF