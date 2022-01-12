#!/bin/bash
# rman_database_full_level0
# sh rman_database.sh > /dev/null 2>&1

#set -ex

source /home/oracle/.bash_profile
# 定义选项1：备份路径
BACKUP_PATH=/data/backup

# 取当前日期
BACKUP_DATE=`date +%Y%m%d`
# 取当前星期几，0为周日，星期一到星期六分别对应1-6
WEEK_DAILY=`date +%w`

# 判断当前用户是不是oracle账户
if [ $USER = "oracle" ]
then
    echo "当前用户是oracle，可以继续！"
else
    echo "---------------当前用户不是oracle，请使用oracle用户执行本备份脚本，程序将退出。"
    exit
fi

# 备份级别
if [ ${WEEK_DAILY} -eq 0 ]
then
    BACKUP_LEVEL=0
else
    BACKUP_LEVEL=1
fi

# 设置备份level为全局变量，使其可以在以下的的ramn脚本里引用。
export BACKUP_LEVEL=${BACKUP_LEVEL}

echo "今天是星期$BACKUP_LEVEL"

# 不指定log默认打印在控制台
# log加append追加文件
rman target / log=${BACKUP_PATH}/logs/${BACKUP_DATE}.log << EOF
run {
# 分配通道
allocate channel ch1 type disk maxpiecesize 2g rate 100m format '${BACKUP_PATH}/database_full_%T_%s_%U.bak';
allocate channel ch2 type disk maxpiecesize 2g rate 100m format '${BACKUP_PATH}/database_full_%T_%s_%U.bak';

# 备份全库及控制文件、服务器参数文件
backup as compressed backupset incremental level=${BACKUP_LEVEL} tag=db_inc_${BACKUP_LEVEL} database filesperset=3;

# 核对所有备份集
crosscheck backup;

# 释放通道
release channel ch1;
release channel ch2;
}
EOF
echo "执行状态：$?"
echo
echo "Backup Complete!"
echo
