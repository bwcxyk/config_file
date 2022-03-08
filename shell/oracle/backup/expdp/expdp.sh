#!/bin/bash
##auth expdp

#set -ex
source /home/oracle/.bash_profile
date=`date +'%Y%m%d%H%M'`
user="user"
passwd="pass"
directory="tmsbak"

expdp ${user}/${passwd} \
directory=${directory} \
schemas=${user} \
exclude=statistics \
exclude=table:\"LIKE\ \'SYSTEM_LOG%\'\" \
exclude=table:\"LIKE\ \'API_REQUEST_LOG%\'\" \
exclude=table:\"LIKE\ \'API_GEO_LOG%\'\" \
exclude=table:\"LIKE\ \'WCPTOPEN_API_LOG%\'\" \
exclude=table:\"like\ \'API%\'\" \
filesize=2048M \
parallel=4 \
dumpfile=tmsbak_${date}_%U.dmp \
compression=all
