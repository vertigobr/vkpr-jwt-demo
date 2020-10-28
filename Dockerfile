FROM maven:3.6.3-openjdk-11-slim AS build
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package

FROM openjdk:11
COPY --from=build /usr/src/app/target/*.jar app.jar
ARG DEPLOY_ENV
ENV TARGET_ENV=$DEPLOY_ENV
ENTRYPOINT java -jar -Dspring.profiles.active=$TARGET_ENV app.jar
