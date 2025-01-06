FROM jetty:9.4-jdk8
LABEL maintainer="yaokun <yaokun@bwcxtech.com>"
ENV TZ "Asia/Shanghai"

COPY ./build/libs/*.war /var/lib/jetty/webapps/

EXPOSE 8080
# ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["sh", "-c", "java ${JAVA_OPTS} -jar /usr/local/jetty/start.jar"]