#!/bin/bash
# centos docker install
# auther YaoKun

#set -x
# install docker
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache

yum install -y docker-ce-19.03.9-3.el7

mkdir /etc/docker
cat << EOF > /etc/docker/daemon.json
{
    "data-root": "/data/docker",
    "registry-mirrors": ["https://ojtwovh1.mirror.aliyuncs.com"],
    "log-driver":"json-file",
    "log-opts": {"max-size":"500m", "max-file":"5"}
}
EOF
# start docker
systemctl start docker

if [ $? = 0 ] ; then
   echo -e "\033[32m docker启动成功 \033[0m"
else
   echo -e "\033[31m docker启动失败 \033[0m"
   exit 1
fi

systemctl enable docker
