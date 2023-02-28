#!/bin/bash
# archive and migrate
set -e
set -x
#archive
date=$(date +'%Y%m%d')
date2=$(date +'%Y%m')
db="yfbi"
backup_dir="/data/backup/db_backup/${db}"
archive_dir="/data/ossfs/tms/${db}/${date2}"

# 进行tar归档备份文件
function pack_to_tar() {
    if ls "${backup_dir}"/"${db}"_"${date}"*.sql.gz 1> /dev/null 2>&1;then
        echo "文件存在，开始归档"
        cd "${backup_dir}" || exit
        tar cf "${db}"_"${date}".tar "${db}"_"${date}"*.sql.gz
        echo "归档完成"
    else
        echo "No such directory"
        exit 1 
    fi
}

# 创建oss中相应文件夹
function mkdir_to_oss() {
    if [ ! -d "${archive_dir}" ];then
        echo "No such directory"
        mkdir "${archive_dir}"
    else
        echo "Directory exists"
    fi
}

# 传输到oss存储
# function trans_to_oss {
# 	cp ${db}_${date}.tar ${archive_dir}/
#     if [ $? -eq 0 ]; then
#         echo "====move ok!===="
#     else
#         echo "====move failed!===="
#         exit 1
#     fi
# }

function trans_to_oss {
    if ! cp "${db}"_"${date}".tar "${archive_dir}"/
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
    rm -f "${db}"_"${date}"*
}

function main() {
    pack_to_tar
    mkdir_to_oss
    trans_to_oss
    delete_files
}
main