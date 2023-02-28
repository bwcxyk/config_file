#!/bin/bash
# archive and migrate
# author yaokun

#set -ex

date=$(date +'%Y%m%d')
date2=$(date +'%Y%m')
backup_dir="/data/orabak/tmsdata"
archive_dir="/data/ossfs/tms/oracle/${date2}"
schema="task"

# 进行tar归档备份文件
# 1>/dev/null redirect stdout to , so the standard out is not shown/dev/null
# 2>&1 redirect stderr to stdout. Here, stdout is redirected to , so everything is redirected to /dev/null/dev/null
function pack_to_tar() {
    if ls ${backup_dir}/"${schema}"_"${date}"*.dmp 1> /dev/null 2>&1;
    then
        echo "文件存在，开始归档"
        cd "${backup_dir}" || exit
        tar cf "${schema}"_"${date}".tar "${schema}"_"${date}"*.dmp
        echo "归档完成"
    else
        echo "No such directory"
        exit 1 
    fi
}

# 创建oss中相应文件夹
function mkdir_to_oss() {
    if [ ! -d "${archive_dir}" ];
    then
        echo "No such directory"
        mkdir "${archive_dir}"
    else
        echo "Directory exists"
    fi
}

# 传输到oss存储
# function trans_to_oss {
#     cp tms_"${date}".tar "${archive_dir}"/
#     if [ $? -eq 0 ]; then
#         echo "====move ok!===="
#     else
#         echo "====move failed!===="
#         exit 1
#     fi
# }

function trans_to_oss {
    if ! cp "${schema}"_"${date}".tar "${archive_dir}"/;
    then
        echo "====move failed!===="
        exit 1
    else
        echo "====move ok!===="
    fi
}

# 清理文件
function delete_files() {
    echo "delete files"
    rm -f "${schema}"_"${date}"*
}

function main() {
    pack_to_tar
    mkdir_to_oss
    trans_to_oss
    delete_files
}
main