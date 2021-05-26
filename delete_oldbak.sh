#!/bin/bash
# author yao
# for delete oldbak
#set -x

olddate=$(date -d '-7 months 1 day' +%Y%m)
FileDir=/data/ossfs/tms
FileDir2=/data/ossfs/wms
FileDir3=/data/ossfs/oms

#循环子目录列表
for element in `ls ${FileDir}`
do
    # 拼接成完成目录 （父目录路径/子目录名）
    old_file=${FileDir}/${element}/${olddate}
    echo  ${element} "Delete file:"${old_file}
    rm -rf ${old_file}
    let "FileNum--"
done

#循环子目录列表
for element in `ls ${FileDir2}`
do
    # 拼接成完成目录 （父目录路径/子目录名）
    old_file2=${FileDir2}/${element}/${olddate}
    echo  ${element} "Delete file:"${old_file2}
    rm -rf ${old_file2}
    let "FileNum--"
done

# 拼接成完成目录 （父目录路径/子目录名）
old_file3=${FileDir3}/${olddate}
echo  ${element} "Delete file:"${old_file3}
rm -rf ${old_file3}
let "FileNum--"
