#!/bin/bash

FileDir=/data2/eprint/downlowd

for element in `ls ${FileDir}`
do
    # 拼接成完成目录 （父目录路径/子目录名）
    old_file=${FileDir}/${element}
    cd ${old_file}
    rm -rf *
done
