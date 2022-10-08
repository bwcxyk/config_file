#!/bin/bash

db_ip=127.0.0.1
db_port=6379
password=123456
cursor=0
cnt=100
new_cursor=0
exec_time=$(date +%Y%m%d)

#创建目录
function mkdirs(){
    filedir=./redis_modify_key
    if [ ! -d "$filedir" ]; then
        mkdir -p $filedir
    fi
}

#给Redis永久Key设置过期时间
function modifyKeyTime(){

    #使用Redis中的scan命令，以非阻塞的方式实现key值的分页查找
    ./redis-cli -h $db_ip -p $db_port -a $password scan $cursor count $cnt > scan_tmp_result
    #获取第一行，scan返回游标值
    new_cursor=`sed -n '1p' scan_tmp_result`
    #获取第二行到最后一行，100行key数据
    sed -n '2,$p' scan_tmp_result > scan_result
    cat scan_result |while read line
    do
        ttl_result=`./redis-cli -h $db_ip -p $db_port -a $password ttl $line`
        if [[ $ttl_result == -1 ]];then
            echo 'key:'$line >> ./redis_modify_key/modify_key_$exec_time.log
            #获取5位不为0开始的随机数，避免设置同一过期时间，引起缓存雪崩
            time=`tr -cd '1-9' </dev/urandom | head -c 5`
            value=`./redis-cli -h $db_ip -p $db_port -a $password get $line`
            result=`./redis-cli -h $db_ip -p $db_port -a $password expire $line $time`
            echo 'value:'$value >> ./redis_modify_key/modify_key_$exec_time.log
            echo 'expire:'$time >> ./redis_modify_key/modify_key_$exec_time.log
            echo 'result:'$result >> ./redis_modify_key/modify_key_$exec_time.log		
        fi
    done

    #以 0 作为游标开始一次新的迭代， 一直调用 SCAN 命令， 直到命令返回游标 0 ，遍历完毕
    while [ $cursor -ne $new_cursor ]
    do
        ./redis-cli -h $db_ip -p $db_port -a $password scan $new_cursor count $cnt > scan_tmp_result
        new_cursor=`sed -n '1p' scan_tmp_result`
        sed -n '2,$p' scan_tmp_result > scan_result
        cat scan_result |while read line
        do
            ttl_result=`./redis-cli -h $db_ip -p $db_port -a $password ttl $line`
            if [[ $ttl_result == -1 ]];then
                echo 'key:'$line >> ./redis_modify_key/modify_key_$exec_time.log
                #获取5位不为0开始的随机数，避免设置同一过期时间，引起缓存雪崩
                time=`tr -cd '1-9' </dev/urandom | head -c 5`
                value=`./redis-cli -h $db_ip -p $db_port -a $password get $line`
                result=`./redis-cli -h $db_ip -p $db_port -a $password expire $line $time`
                echo 'value:'$value >> ./redis_modify_key/modify_key_$exec_time.log
                echo 'expire:'$time >> ./redis_modify_key/modify_key_$exec_time.log
                echo 'result:'$result >> ./redis_modify_key/modify_key_$exec_time.log	
            fi
        done
    done
    rm -rf scan_tmp_result
    rm -rf scan_result
}

#脚本主函数（入口）
function main(){
    echo "[$(date "+%Y-%m-%d %H:%M:%S")]  start..."
    echo "脚本作用说明：给Redis永久Key设置过期时间"
    
    mkdirs
    modifyKeyTime
    
    echo "[$(date "+%Y-%m-%d %H:%M:%S")]  done!"
}

main
