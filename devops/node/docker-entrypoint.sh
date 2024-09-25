#!/bin/bash
set -e

if [ "$baseURL" ];
    then
    sed -i "s|###baseURL###|$baseURL|g" /usr/share/nginx/html/*/js/app.*.js
fi

exec "$@"
