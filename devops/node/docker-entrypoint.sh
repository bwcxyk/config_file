#!/bin/bash
set -e
if [ "$INDEX_URL" ];
    then
    sed -i "s|index.html index.htm|${INDEX_URL}|g" /etc/nginx/conf.d/default.conf
fi

if [ "$baseURL" ];
    then
    sed -i "s|###baseURL###|$baseURL|g" /usr/share/nginx/html/*/js/app.*.js
fi

# use root
sed -i "s|user  nginx;|user  root;|g" /etc/nginx/nginx.conf

nginx -g 'daemon off;'
