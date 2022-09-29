#!/bin/bash
#mysql数据库改名，官方没有直接修改数据库名称的命令
#只有通过修改表名方式实现

source /etc/profile        #加载系统环境变量
source ~/.bash_profile    #加载用户环境变量
set -o nounset             #引用未初始化变量时退出

mysqlconn="mysql -h localhost -uroot -p"

#需要修改的数据库名
olddb="YFBI"
#修改后的数据库名
newdb="yfbi"

#创建新数据库
$mysqlconn -e "drop database if exists ${newdb};create database ${newdb};"

#获取所有表名
tables=$($mysqlconn -N -e "select table_name from information_schema.tables where table_schema='${olddb}'")

#修改表名
for name in $tables;do
    $mysqlconn -e "rename table ${olddb}.${name} to ${newdb}.${name}"
done

#删除老的空库
#$mysqlconn -e "drop database ${olddb}"
