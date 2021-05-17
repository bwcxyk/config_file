#!/bin/bash
set -e
set -x
date=`date +'%Y%m%d%H%M'`
project="oms-api"
workdir="/data/file"

# bak
cd ${workdir}
cp ${project}.jar /data/file/history/${project}_${date}.jar
# kill
process_id=`jps |grep ${project}.jar |awk {print'$1'}`
echo ${process_id}
kill -9 ${process_id}

# update
nohup java -jar -Xms1024m -Xmx1024m /data/file/${project}.jar >/data/logs/${project}.log 2>&1 &