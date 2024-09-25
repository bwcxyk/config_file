#!/bin/bash
set -e

if [ "$baseURL" ];
    then
    sed -i "s|###baseURL###|$baseURL|g" /usr/share/nginx/html/*/js/app.*.js
fi

# use root
sed -i "s|user  nginx;|user  root;|g" /etc/nginx/nginx.conf

nginx -g 'daemon off;'
