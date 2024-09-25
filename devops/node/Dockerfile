FROM nginx:stable-alpine
LABEL maintainer="yaokun <yaokun@bwcxtech.com>"

ENV TZ "Asia/Shanghai"

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# file
COPY default.conf /etc/nginx/conf.d/default.conf
COPY dist /usr/share/nginx/html

# listen
EXPOSE 80

# start
ENTRYPOINT ["bash", "-c", "/usr/local/bin/docker-entrypoint.sh"]
