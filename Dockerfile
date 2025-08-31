# Etapa 1: construir la app con Maven y Java 17
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: ejecutar con Tomcat 9 y Java 17
FROM tomcat:9.0-jdk17
# Eliminar aplicaciones por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*
# Copiar el WAR generado
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
# Railway expone automáticamente el puerto definido en PORT, pero por defecto usamos 8080
EXPOSE 8080
# Usamos catalina para correr Tomcat
CMD ["catalina.sh", "run"]
