FROM eclipse-temurin:8-alpine
LABEL maintainer="yaokun <yaokun@bwcxtech.com>"
ENV TZ "Asia/Shanghai"

COPY target/*.jar /home/app.jar

WORKDIR /home
EXPOSE 8080

# ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["bash", "-c", "java $JAVA_OPTS -jar app.jar --server.port=8080"]