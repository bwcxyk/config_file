#!/bin/bash
#食用方法:sh push2.sh ${REGISTRY_URL} ${TAG_VERSION}


REGISTRY_URL="192.168.0.2" #镜像仓库url
NAME_SPACE="yuanfu-tms" #命名空间
DATE=$(date +"%Y%m%d%H%M%S")
TAG_VERSION=${DATE} #镜像的版本
# service
TAG_NAME="node-tms"

if [ "$1" != "" ];
    then
    REGISTRY_URL="$1"
fi

if [ "$2" != "" ];
    then
    TAG_VERSION="$2"
fi

# build_push_tag
set -e
# push node-tms
cd $WORKSPACE
docker build -t ${REGISTRY_URL}/${NAME_SPACE}/${TAG_NAME}:${TAG_VERSION} .
docker push ${REGISTRY_URL}/${NAME_SPACE}/${TAG_NAME}:${TAG_VERSION}
docker rmi ${REGISTRY_URL}/${NAME_SPACE}/${TAG_NAME}:${TAG_VERSION}
