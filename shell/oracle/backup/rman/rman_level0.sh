#!/bin/bash
# rman_database_full_level0
# two_channel

#set -ex

source /home/oracle/.bash_profile
# 定义选项1：备份路径
BACKUP_PATH=/data/backup

# 取当前日期
BACKUP_DATE=`date +%Y%m%d`

# 判断当前用户是不是oracle账户
if [ $USER = "oracle" ]
then
    echo "当前用户是oracle，可以继续！"
else
    echo "---------------当前用户不是oracle，请使用oracle用户执行本备份脚本，程序将退出。"
    exit
fi

# 不指定log默认打印在控制台
# log加append追加文件
rman target / log=${BACKUP_PATH}/logs/${BACKUP_DATE}.log << EOF
run {
# 分配通道
allocate channel ch1 type disk maxpiecesize 2g rate 100m format '${BACKUP_PATH}/database_full_%T_%s_%U.bak';
allocate channel ch2 type disk maxpiecesize 2g rate 100m format '${BACKUP_PATH}/database_full_%T_%s_%U.bak';
# 备份全库及控制文件、服务器参数文件
backup incremental level=0 as compressed backupset tag=db_inc_0 database filesperset=3;
# 释放通道
release channel ch1;
release channel ch2;
}
EOF