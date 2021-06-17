#!/bin/bash
set -e
#set -x

source /home/oracle/.bash_profile

DATE=`date +%Y%m%d%H`
rman target / <<EOF
run{
crosscheck archivelog all;
delete noprompt expired archivelog all;
delete noprompt archivelog all completed before 'sysdate-7'; 
}
exit;
EOF
exit
