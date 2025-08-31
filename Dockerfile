# Etapa 1: construir la app
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Etapa 2: ejecutar con Tomcat
FROM tomcat:9.0-jdk17
# Eliminar apps por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*
# Copiar el WAR generado
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
# Exponer el puerto
EXPOSE 8080
CMD ["catalina.sh", "run"]
