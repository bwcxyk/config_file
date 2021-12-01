#!/bin/bash
set -e
if [ "$INDEX_URL" ];
    then
    sed -i "s|index.html index.htm|${INDEX_URL}|g" /etc/nginx/conf.d/default.conf
fi

# Home page		
if [ "${YUANFU}" = "0" ];		
    then		
    cp /usr/share/nginx/html/login.html /usr/share/nginx/html/index.html		
fi

# use root
sed -i "s|user  nginx;|user  root;|g" /etc/nginx/nginx.conf

nginx -g 'daemon off;'