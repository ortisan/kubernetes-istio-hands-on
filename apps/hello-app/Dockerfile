FROM adoptopenjdk/openjdk11:jdk-11.0.10_9-alpine

RUN apk add --update \
    curl busybox-extras\
    && rm -rf /var/cache/apk/*

WORKDIR '/app'
COPY ./target/hello-app.jar ./app.jar

EXPOSE 8080
EXPOSE 9090

HEALTHCHECK CMD curl --fail http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
