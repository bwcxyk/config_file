#!/bin/bash
#with impdp
#set -ex

# shellcheck source=/dev/null
source /home/oracle/.bash_profile
dbuser="user"
dbpass="pass"
date=$(date +'%Y%m%d')
files="tmsbak_${date}0300*.dmp"
file="tmsbak_${date}0300_%U.dmp"
bakdir="/data/oracle/admin/orcl/dpdump"

function download() {
    cd ${bakdir} || exit
    if scp oracle@172.19.180.0:/data/oracle/admin/orcl/dpdump/"${files}" .;
    then
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
    impdp "${dbuser}"/"${dbpass}" \
    DIRECTORY=DATA_PUMP_DIR \
    parallel=2 \
    dumpfile="${file}" \
    remap_tablespace=tms_d_stand:tms_d_stand \
    remap_schema=tms_user_sc:tms_temp_date_user \
    exclude=SEQUENCE,OBJECT_GRANT,PACKAGE,FUNCTION,PROCEDURE,CONSTRAINT,VIEW,PACKAGE_BODY,TRIGGER,INDEX,PROCOBJ,JOB,DB_LINK \
    exclude=table:\"like\ \'API%\'\" \
    table_exists_action=replace \
    transform=segment_attributes:n
    echo $?
}

# 清理临时文件
function delete() {
    echo "delete files"
    rm -fv "${files}"
}

function main() {
    download
    data_import
    delete
}
main
