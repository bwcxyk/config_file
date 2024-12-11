FROM nginx:stable-alpine
LABEL maintainer="yaokun <yaokun@bwcxtech.com>"
ENV TZ "Asia/Shanghai"

COPY default.conf /etc/nginx/conf.d/default.conf
COPY dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
