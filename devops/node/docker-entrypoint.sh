#!/bin/bash
set -e
if [ "$INDEX_URL" ];
    then
    sed -i "s|index.html index.htm|${INDEX_URL}|g" /etc/nginx/conf.d/default.conf
fi

# use root
sed -i "s|user  nginx;|user  root;|g" /etc/nginx/nginx.conf

nginx -g 'daemon off;'