FROM eclipse-temurin:17
WORKDIR /app
COPY target/*.jar spring-boot-webhook-jenkins.jar
EXPOSE 8085
ENTRYPOINT ["java","-jar","spring-boot-webhook-jenkins.jar"]