FROM tomcat:9.0-jdk8
LABEL maintainer="yaokun <yaokun@bwcxtech.com>"

ENV TZ "Asia/Shanghai"

RUN rm -rf /usr/local/tomcat/webapps
COPY ./target/*.war /usr/local/tomcat/webapps/

WORKDIR /usr/local/tomcat

EXPOSE 8080

CMD ["catalina.sh", "run"]
