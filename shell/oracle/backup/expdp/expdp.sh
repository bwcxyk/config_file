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
EXCLUDE=statistics \
EXCLUDE=TABLE:\"LIKE\ \'SYSTEM_LOG%\'\" \
EXCLUDE=TABLE:\"LIKE\ \'API_REQUEST_LOG%\'\" \
EXCLUDE=TABLE:\"LIKE\ \'API_GEO_LOG%\'\" \
EXCLUDE=TABLE:\"LIKE\ \'WCPTOPEN_API_LOG%\'\" \
filesize=2048M \
parallel=4 \
dumpfile=tmsbak_${date}_%U.dmp \
compression=all
