# Imagen base: Tomcat con JDK 17
FROM tomcat:9.0-jdk17

# Limpiar las apps por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el WAR generado en "dist" al Tomcat como ROOT.war
COPY dist/*.war /usr/local/tomcat/webapps/ROOT.war

# Exponer el puerto que usará Railway
EXPOSE 8080

# Ejecutar Tomcat
CMD ["catalina.sh", "run"]
