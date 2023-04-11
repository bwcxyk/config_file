#!/bin/bash
  
mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
echo "deb http://mirrors.163.com/debian/ buster main non-free contrib" >>/etc/apt/sources.list
echo "deb http://mirrors.163.com/debian/ buster-updates main non-free contrib" >>/etc/apt/sources.list
echo "deb http://mirrors.163.com/debian/ buster-backports main non-free contrib" >>/etc/apt/sources.list
echo "deb http://mirrors.163.com/debian-security/ buster/updates main non-free contrib" >>/etc/apt/sources.list

export DEBIAN_FRONTEND=noninteractive
apt-get update &&
    apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &&
    apt-get -o Dpkg::Options::="--force-confold" dist-upgrade -q -y --force-yes

apt -y update
apt-get install -y gnupg2
apt-get install -y ca-certificates
apt install -y --no-install-recommends curl
apt-get install -y cron
apt-get install -y socat
apt-get install -y vim

mkdir /usr/local/etc/blog

blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

cd /usr/sbin

your_domain="blog.kdyzm.cn"
        green " "
        green " "
        green "=========================================="
		blue "获取到你的域名为 $your_domain"
        green "=========================================="
        sleep 3s
    green " "
        green " "
        green "=========================================="
        blue "安装acme.sh 并开始签发证书"
        green "=========================================="
        sleep 3s

/usr/sbin/nginx -s reload

        curl https://get.acme.sh | sh
        ~/.acme.sh/acme.sh --issue -d $your_domain --nginx
        ~/.acme.sh/acme.sh --installcert -d $your_domain --key-file /usr/local/etc/blog/private.key --fullchain-file /usr/local/etc/blog/cert.crt
        ~/.acme.sh/acme.sh --upgrade --auto-upgrade
        chmod -R 755 /usr/local/etc/blog

if test -s /usr/local/etc/blog/cert.crt; then

/usr/sbin/nginx -s reload

        green "=========================================="
                blue "检测到证书已经正常签发"
        green "=========================================="
else
        green "=========================================="
                red "证书签发失败，请重新尝试"
        green "=========================================="
fi
