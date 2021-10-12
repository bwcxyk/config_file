#!/usr/bin/env bash
# @Date   :2021/4/14 16:13
# @Author :YaoKun
# @Email  :yaokun@bwcxtech.com
# @File   :openssh_upgrade.sh
# @Desc   :升级openssh版本至8.4p1

# 如果非root可能存在权限问题，使用如下命令执行
# sudo su - root<<EOF
# sh openssh_upgrade.sh
# EOF

# 下载软件包
function download_package() {
    mkdir -p /tmp/openssh
	cd /tmp/openssh
	echo -e "\033[34;1m 开始下载软件包openssh-8.4p1-1.el7.centos.x86_64.rpm \033[0m"
	wget https://gitee.com/yuanfusc/packages/attach_files/671314/download/openssh-8.4p1-1.el7.centos.x86_64.rpm
    if [ $? -ne 0 ]; then
        echo "openssh-8.4p1-1.el7.centos.x86_64.rpm下载失败...请检查网络环境或版本是否存在"
        exit 2
    fi
	echo -e "\033[34;1m 开始下载软件包openssh-server-8.4p1-1.el7.centos.x86_64.rpm \033[0m"
	wget https://gitee.com/yuanfusc/packages/attach_files/671313/download/openssh-server-8.4p1-1.el7.centos.x86_64.rpm
    if [ $? -ne 0 ]; then
        echo "openssh-server-8.4p1-1.el7.centos.x86_64.rpm下载失败...请检查网络环境是否正常"
        exit 2
	fi
	echo -e "\033[34;1m 开始下载软件包openssh-clients-8.4p1-1.el7.centos.x86_64.rpm \033[0m"
	wget https://gitee.com/yuanfusc/packages/attach_files/671316/download/openssh-clients-8.4p1-1.el7.centos.x86_64.rpm
	if [ $? -ne 0 ]; then
		echo "openssh-8.4p1-1.el7.centos.x86_64.rpm下载失败...请检查网络环境或版本是否存在"
		exit 2
	fi
}

# 备份配置
function bakup() {
	cp /etc/pam.d/{sshd,sshd.bak}
	cp /etc/ssh/{sshd_config,sshd_config.bak}
}

# 升级
function update() {
	yum update ./openssh* -y
    if [ $? -eq 0 ]; then
        echo -e "\033[34;1m 安装成功 \033[0m"
    else
        echo -e "\033[33;1m 安装失败 \033[0m"
    fi
}

# 还原配置
function reduction_and_restart() {
	\mv /etc/pam.d/sshd.bak /etc/pam.d/sshd
	\mv /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
	chmod 600 /etc/ssh/*
	sed -i "s|.*PermitRootLogin.*|PermitRootLogin yes|g" /etc/ssh/sshd_config
	sed -i 's|.*PasswordAuthentication.*|PasswordAuthentication yes|g' /etc/ssh/sshd_config
	systemctl restart sshd
    if [ $? -eq 0 ]; then
        echo -e "\033[34;1m openssh重启成功 \033[0m"
    else
        echo -e "\033[33;1m openssh重启失败 \033[0m"
    fi
}

# 删除软件包
function remove_files() {
	cd /tmp
	rm -rf openssh
}

function main() {
    download_package
    bakup
    update
	reduction_and_restart
	remove_files
}
main
