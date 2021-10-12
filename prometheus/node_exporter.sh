#!/bin/bash

if [ -d "/usr/local/node_exporter" ];then
   echo -e "\e[1;31m 目录存在，退出安装 \e[0m"
   exit 1
else
   echo -e "\e[1;32m 目录不存在，开始下载 \e[0m"
   # down
   wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
   # unpack
   if [ $? != 0 ] ; then
      echo -e "\e[1;31m failed \e[0m"
      exit 1
   fi
   tar zxf node_exporter-0.18.1.linux-amd64.tar.gz
   mv node_exporter-0.18.1.linux-amd64 /usr/local/node_exporter
   rm -f node_exporter-0.18.1.linux-amd64.tar.gz
fi



next()
{
# create server
tee /usr/lib/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
ExecStart=/usr/local/node_exporter/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# run server
systemctl enable node_exporter.service
systemctl start node_exporter.service
}

if [ $? != 0 ] ; then
   echo -e "\e[1;31m failed \e[0m"
   exit 1
fi

ls /usr/local/node_exporter
if [ $? = 0 ] ; then
   next
else
   echo -e "\e[1;31m failed \e[0m"
   exit 1
fi
