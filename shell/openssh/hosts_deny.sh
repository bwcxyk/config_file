#!/bin/env bash

# 把Failed 和Invalid超过5次的写到/etc/hosts.deny中

#cat /var/log/secure|awk '/Invalid/{print $NF} /Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2":"$1}' > blacklist
cat /var/log/secure|awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2":"$1}' > blacklist

for line in `cat blacklist`;do
        ip=`echo $line|cut -d: -f1`
        num=`echo $line|cut -d: -f2`

        if [ "$num" -gt 5 ];then
                grep $ip /etc/hosts.deny &> /dev/null
                if [ $? -gt 0 ];then
                        echo sshd:$ip:$num:deny >> hosts.deny
                fi
        fi
done
