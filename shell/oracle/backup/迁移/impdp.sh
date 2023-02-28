#!/bin/bash
#with impdp
#set -e
set -x
source /home/oracle/.bash_profile
dbuser="user"
dbpasswd="pass"
date=`date +'%Y%m%d'`
files="bak_${date}0300*.dmp"
dumpfile="bak_${date}0300_%U.dmp"
bakdir="/data/oracle/admin/orcl/dpdump"

# 从备份机器复制数据文件
function download() {
    cd ${bakdir}
    scp oracle@172.19.180.0:/data/oracle/admin/orcl/dpdump/${files} .
    if [ $? -eq 0 ]; then
        echo -e "\033[34;1m下载成功  \033[0m"
        echo
        echo -e "\033[33;1m文件存放路径：${bakdir} \033[0m" && ls ${bakdir}/
    else
        echo -e "\033[33;1m下载失败，请根据报错信息进行解决，再重试 \033[0m"
        exit
    fi
}

# 导入操作
function data_import() {
    impdp ${dbuser}/${dbpasswd} \
    DIRECTORY=DATA_PUMP_DIR \
    parallel=2 \
    dumpfile=${dumpfile} \
    remap_tablespace=tablespace1:tablespace2 \
    remap_schema=user1:user2 \
    table_exists_action=replace \
    transform=segment_attributes:n
}

# 清理临时文件
function delete() {
    rm -f ${files}
}

function main() {
    download
    data_import
    delete
}
main
