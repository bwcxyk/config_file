#!/bin/bash
# use for expdp
#set -x
source /home/oracle/.bash_profile
date=`date +'%Y%m%d%H%M'`
user="user"
passwd="passwd"

expdp ${user}/${passwd} \
DIRECTORY=tmsbackup \
SCHEMAS=${user} \
EXCLUDE=TABLE:\"IN\(\'SYSTEM_LOG\',\'WCPTOPEN_API_LOG\'\,\'API_REQUEST_LOG\'\,\'API_GEO_LOG_20201126\'\)\" \
DUMPFILE=tmsbackup_${date}.dmp \
compression=all
