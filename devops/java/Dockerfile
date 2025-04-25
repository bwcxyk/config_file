FROM jetty:9.4-jdk8
LABEL maintainer="yaokun <yaokun@bwcxtech.com>"
ENV TZ "Asia/Shanghai"

# USER root
COPY docker-entrypoint.sh /usr/local/bin/

COPY ./build/libs/*.war /var/lib/jetty/webapps/

WORKDIR /var/lib/jetty
EXPOSE 8080

# Uncomment below to use the custom entrypoint script
# Note: When using a custom entrypoint, you typically need USER root permissions
# ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["sh", "-c", "java ${JAVA_OPTS} -jar /usr/local/jetty/start.jar"]
