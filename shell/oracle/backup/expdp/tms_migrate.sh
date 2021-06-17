#!/bin/bash
# use for archive and migrate
# author yaokun
set -e
#set -x
#compression
date=$(date +'%Y%m%d')
date2=$(date +'%Y%m')
dir="/data/orabak/tmsdata"
bakdir="/data/ossfs/tms/oracle/${date2}"
cd ${dir}
tar zcf tmsbak_${date}.tar.gz tmsbak_${date}*.dmp
sleep 2
#migrate files
#cd ${dir}
if [ ! -d "${bakdir}" ];then
    echo "No such directory"
    mkdir ${bakdir}
else
    echo "Directory exists"
fi
cp tmsbak_${date}.tar.gz ${bakdir}/
echo $?
if [ $? -eq 0 ]; then
    echo "====move ok!===="
    echo "delete files"
    rm -f tmsbak_${date}*
else
    echo "====move failed!===="
    exit 1
fi
#delete files
#rm -f tmsbak_${date}*
