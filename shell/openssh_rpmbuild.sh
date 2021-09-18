#!/usr/bin/env bash
# @File   :rpmbuild_openssh.sh
# @Desc   :制作openssh rpm软件包，通过tar包build

openssh_version=$1
#判断是否传入正确的软件包
if [ "${openssh_version}" ] ;then
    echo -e "\033[41;37m当前build的openssh版本为: ${openssh_version}\033[0m"
else
    echo "常用版本有：8.0, 8.1, 8.2, 8.3, 8.4"
    echo
    echo -e "   请输入需要build的openssh版本号  示例: \033[36;1m$0 8.4\033[0m"
    exit 1
fi

# 安装依赖
function install_dependency() {
    yum install -y wget rpm-build zlib-devel openssl-devel gcc perl-devel pam-devel unzip libXt-devel imake gtk2-devel openssl-libs >> /dev/null && sleep 3
}

# 下载软件包
function download_package() {
    mkdir -p /root/rpmbuild/{SOURCES,SPECS}
    cd /root/rpmbuild/SOURCES
    echo -e "\033[34;1m开始下载软件包：openssh-${openssh_version}p1.tar.gz  \033[0m"
    wget http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${openssh_version}p1.tar.gz >> /dev/null && echo "openssh-${version}p1.tar.gz下载成功..."
    if [ $? -ne 0 ]; then
        echo "openssh-${openssh_version}p1.tar.gz下载失败...请检查网络环境或版本是否存在"
         exit 2
    else
        echo -e "\033[34;1m开始下载软件包：x11-ssh-askpass-1.2.4.1.tar.gz  \033[0m"
        wget https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz >> /dev/null && echo "x11-ssh-askpass-1.2.4.1.tar.gz下载成功..." && sleep 3
        if [ $? -ne 0 ]; then
            echo "x11-ssh-askpass-1.2.4.1.tar.gz下载失败...请检查网络环境是否正常"
            exit 2
        else
            tar -xf openssh-8.4p1.tar.gz && tar -xf x11-ssh-askpass-1.2.4.1.tar.gz
        fi
    fi
}

# 修改配置文件和build
function config_and_build() {
    cp openssh-8.4p1/contrib/redhat/openssh.spec /root/rpmbuild/SPECS/
    sed -i -e "s/%define no_x11_askpass 0/%define no_x11_askpass 1/g" /root/rpmbuild/SPECS/openssh.spec
    sed -i -e "s/%define no_gnome_askpass 0/%define no_gnome_askpass 1/g" /root/rpmbuild/SPECS/openssh.spec
    sed -i 's/BuildRequires: openssl-devel < 1.1/#&/' /root/rpmbuild/SPECS/openssh.spec
    cd /root/rpmbuild/SPECS
    echo -e "\033[34;1m开始制作 openssh${openssh_version} 相关rpm软件包  \033[0m"
    rpmbuild -ba openssh.spec
    if [ $? -eq 0 ]; then
        echo -e "\033[34;1mopenssh${openssh_version} 相关rpm软件包制作成功，生成的软件包信息如下：  \033[0m"
        echo
        echo -e "\033[33;1m软件包存放路径：/root/rpmbuild/RPMS/x86_64/ \033[0m" && ls /root/rpmbuild/RPMS/x86_64/
    else
        echo -e "\033[33;1mopenssh${openssh_version} 相关rpm软件包制作失败，请根据报错信息进行解决，再重新进行编译 \033[0m"
    fi
}

function main() {
    install_dependency
    download_package
    config_and_build
}
main
