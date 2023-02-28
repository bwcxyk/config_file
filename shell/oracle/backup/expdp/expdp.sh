#!/bin/bash
##auth expdp

#set -ex
source /home/oracle/.bash_profile
date=`date +'%Y%m%d%H%M'`
user="user"
passwd="pass"
directory="DATA_PUMP_DIR"

expdp ${user}/${passwd} \
directory=${directory} \
schemas=${user} \
EXCLUDE=statistics \
exclude=table:\"IN\(\'TMS_ORDER_SHIP_B0923\',\'OMS_TO_TMS_LOG\',\'TMS_REPORT_INCOME_COST2\',\'TMS_TRANS_TRANSPORT_PD_221226\'\)\" \
EXCLUDE=TABLE:\"LIKE\ \'SYSTEM_LOG%\'\" \
EXCLUDE=TABLE:\"LIKE\ \'API_REQUEST_LOG%\'\" \
EXCLUDE=TABLE:\"LIKE\ \'API_GEO_LOG%\'\" \
EXCLUDE=TABLE:\"LIKE\ \'WCPTOPEN_API_LOG%\'\" \
filesize=2048M \
parallel=4 \
dumpfile=tms_${date}_%U.dmp \
compression=all

