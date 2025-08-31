# Usar Tomcat 9 con Java 17
FROM tomcat:10.1-jdk17


# Eliminar aplicaciones por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar tu WAR ya compilado
COPY radiadores-fortaleza-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war


# Exponer puerto 8080
EXPOSE 8080

# Iniciar Tomcat
CMD ["catalina.sh", "run"]
