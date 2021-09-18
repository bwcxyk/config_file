#!/usr/bin/env bash

# author YaoKun
# date 2021年3月1日13:14:36

. /etc/init.d/functions

# 测试输出
#cat hosts.txt | \
#while read ipaddr port user passwd;
#do
#echo ${passwd}
#echo ${user}
#echo ${ipaddr}
#echo ${port};
#done

# 分发公钥
cat hosts.txt | \
while read ipaddr port user passwd
do
sshpass -p ${passwd} \
ssh-copy-id ${user}@${ipaddr} \
-p ${port} \
-i ~/.ssh/id_rsa.pub \
-o StrictHostKeyChecking=no; \
&>/dev/null

# 判断是否成功
if [ $? -eq 0 ]
then
action "${ipaddr} " /bin/true
echo ""
else
action "${ipaddr} " /bin/false
echo ""
fi

done
