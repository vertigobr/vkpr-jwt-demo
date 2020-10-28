FROM openjdk:11
ARG JAR_FILE=target/*.jar
ARG DEPLOY_ENV
ENV TARGET_ENV=$DEPLOY_ENV
COPY ${JAR_FILE} app.jar
ENTRYPOINT java -jar -Dspring.profiles.active=$TARGET_ENV /app.jar
