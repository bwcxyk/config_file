添加 arthas

```dockerfile
# add arthas
COPY --from=hengyunabc/arthas:4.0.2-no-jdk /opt/arthas /opt/arthas
```

添加 skywalking

```dockerfile
# copy skywalking
COPY --from=apache/skywalking-java-agent:9.3.0-java8 /skywalking/agent /opt/skywalking-agent
```

添加 opentelemetry

```dockerfile
# add opentelemetry
COPY --from=yaokun/opentelemetry-javaagent:2.11.0 /opt/otel /opt/otel
```

