#!/bin/bash  
set -e
set -x
date=`date +'%Y%m%d%H%M'`
project="oms-web"
workdir="/usr/local/${project}"
bakdir="/data/file/history"

# bak
echo "baking..."
cd ${workdir}/webapps
cp ${project}.war ${bakdir}/${project}_${date}.war
# stop
echo "stoping..."
cd ${workdir}
./bin/shutdown.sh

# update
cp /data/file/${project}.war ${workdir}/webapps/

echo "starting..."
cd ${workdir}
./bin/startup.sh