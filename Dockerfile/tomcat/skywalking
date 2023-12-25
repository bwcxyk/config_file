FROM tomcat:8.5.64
LABEL maintainer="yaokun@bwcxtech.com"

COPY agent /skywalking

RUN sed -i '1 i\CATALINA_OPTS="$CATALINA_OPTS -javaagent:/skywalking/skywalking-agent.jar"; export CATALINA_OPTS' /usr/local/tomcat/bin/catalina.sh
