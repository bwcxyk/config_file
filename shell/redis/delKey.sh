#!/bin/bash

db_ip=127.0.0.1
db_port=6379
password=123456

# info keyspace
# keys key总数
# expires 带有过期时间的key总数
# avg_ttl 平均存活时间
./redis-cli info keyspace

# 统计某个key总数
./redis-cli -h $db_ip -p $db_port -a $password keys "prefix_*" | wc -l

# 给某些key设置过期时间
./redis-cli -h $db_ip -p $db_port -a $password keys "prefix_*" | xargs -i ./redis-cli -h $db_ip -p $db_port -a $password expire {} $time

# 删除某些key
# ./redis-cli -h $db_ip -p $db_port -a $password keys "prefix_*" | xargs -i ./redis-cli -h $db_ip -p $db_port -a $password del {}
