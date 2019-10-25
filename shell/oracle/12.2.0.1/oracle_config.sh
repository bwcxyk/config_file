#!/bin/sh
set -e

oracle_version=12.2.0.1
centos_version=7.x
oracle_home=/u01/app/oracle

if [ ! -n "$1" ] ;then
    echo ""
else
    oracle_home=$1
fi

suppurt_lib="
binutils
compat-libstdc++-33
elfutils-libelf-devel
gcc
gcc-c++
ksh
libaio
libaio-devel
numactl-devel
sysstat
"

echo "CentOS Version is:  ${centos_version}"
echo "Oracle Version is:  ${oracle_version}"
echo "Oracle Home is:  $oracle_home"
echo 
echo "Step 1 : install gcc glibc...etc"

for suppurt_lib in $suppurt_lib ; do
      echo "install ${suppurt_lib} ..."
      yum install -y ${suppurt_lib}
done

echo "Step 1 : Successed~!"


echo 
echo 
echo "Step 2 : Add user and group for oracle..."
groupadd oinstall
groupadd dba
useradd -g oinstall -G dba oracle
echo "Step 2 : Successed~!"


echo 
echo 
echo "Step 3 : Add config in /etc/sysctl.conf for oracle..."

#/etc/sysctl.conf updated to /usr/lib/sysctl.d/50-default.conf
cat >> /usr/lib/sysctl.d/50-default.conf << EOF

#for oracle
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048586
EOF
echo "Step 3 : Successed~!"


echo 
echo 
echo "Step 4 : Config limits in /etc/security/limits.conf for oracle..."

#/etc/security/limits.conf updated to /etc/security/limits.d/20-nproc.conf
cat >> /etc/security/limits.d/20-nproc.conf << EOF

#for oracle
oracle           soft    nproc   2047
oracle           hard    nproc   16384
oracle           soft    nofile  1024
oracle           hard    nofile  65536
EOF
echo "Step 4 : Successed~!"

echo 
echo 
echo "Step 5 : Config pam_limits in /etc/pam.d/login for oracle..."

cat >> /etc/pam.d/login << EOF

# for oracle
session    required     pam_limits.so
EOF
echo "Step 5 : Successed~!"


echo 
echo 
echo "Step 6 : Config profile in /etc/profile for oracle..."

cat >> /etc/profile << EOF

#------FOR ORACLE
if [ $USER = "oracle" ]; then
        if [ $SHELL = "/bin/ksh" ]; then
              ulimit -p 16384
              ulimit -n 65536
        else
              ulimit -u 16384 -n 65536
        fi
fi
EOF
echo "Step 6 : Successed~!"

echo 
echo 
echo "Step 7 : Create install path for oracle..."
mkdir -p $oracle_home
chown -R oracle:oinstall $oracle_home
chmod -R 775 $oracle_home
echo "Step 7 : Successed~!"

echo 
echo 
echo "Step 8 : Config bashrc in /u01/app/oracle/.bashrc for oracle..."

cat >> /home/oracle/.bashrc << EOF
export ORACLE_BASE=$oracle_home
export ORACLE_HOME=\$ORACLE_BASE/product/11.2.0/db_1
export ORACLE_SID=orcl
export PATH=\$ORACLE_HOME/bin:/usr/sbin:\$PATH
export LD_LIBRARY_PATH=\$ORACLE_HOME/lib64:/lib64:/usr/lib64
export LANG=en_US.UTF-8
export PATH
EOF
echo "Step 8 : Successed~!"