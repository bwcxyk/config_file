#!/bin/bash
# archive and migrate
set -e
#set -x
#archive
date=$(date +'%Y%m%d')
date2=$(date +'%Y%m')
dir="/databasebak/yfbidata"
bakdir="/data/ossfs/tms/yfbi/${date2}"

cd ${dir}
tar cf yfbi_bak_${date}.tar yfbi_bak_${date}*.sql.gz
sleep 2
#migrate
if [ ! -d "${bakdir}" ];then
    echo "No such directory"
    mkdir ${bakdir}
else
    echo "Directory exists"
fi

cp yfbi_bak_${date}.tar ${bakdir}/
echo $?
if [ $? -eq 0 ]; then
    echo "====move ok!===="
    echo "delete files"
    rm -f yfbi_bak_${date}*
else
    echo "====move failed!===="
    exit 1
fi
#rm -f yfbi_bak_${date}*
