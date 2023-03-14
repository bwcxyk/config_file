#!/bin/bash

set -ex

# 设置日志文件存放目录
logs_path="/usr/local/nginx/logs"
backup_path="/usr/local/nginx/logs"
# 设置pid文件
pid_path="/usr/local/nginx/logs/nginx.pid"

# 重命名日志文件
mv ${logs_path}/access.log ${backup_path}/access_$(date -d "yesterday" +"%Y%m%d").log
mv ${logs_path}/error.log ${backup_path}/error_$(date -d "yesterday" +"%Y%m%d").log

# 向nginx主进程发信号重新打开日志
kill -USR1 `cat ${pid_path}`

# 压缩
gzip ${backup_path}/access_$(date -d "yesterday" +"%Y%m%d").log
gzip ${backup_path}/error_$(date -d "yesterday" +"%Y%m%d").log

# 删除超过指定时间的日志文件，单位：天
find  $backup_path -name "*.gz" -type f -mtime +30 -exec rm -rf {} \;
