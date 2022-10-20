#!/bin/bash
# set -ex

tmpdir="/data/tmpfile"

# find ${tmpdir} -type f -mtime +15 -print -exec rm -rf {} \;
# find ${tmpdir} -type d -ctime +15 | xargs rm -rf

# 循环子目录列表
# for element in `ls "${tmpdir}"`
# do
#     # 拼接成完成目录 （父目录路径/子目录名）
#     old_file="${tmpdir}"/"${element}"
#     echo "${element}" 'Delete file:'"${old_file}"
#     # find "${old_file}" -mindepth 1 -type d
#     # find "${old_file}" -mindepth 1 -type d -mtime +15 -print -exec rm -rf {} \;
#     find "${old_file}" -mindepth 1 -type d -mtime +15 | xargs rm -rf
# done

find "${tmpdir}" -mindepth 2 -type d -mtime +15 -print0 | xargs -0 rm -rf

echo "删除结束"
