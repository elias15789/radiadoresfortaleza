# Imagen base con Tomcat + JDK 17
FROM tomcat:9.0-jdk17

# Borrar las apps por defecto de Tomcat (ejemplo: ROOT, docs, etc.)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar tu WAR al Tomcat como ROOT.war
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Exponer el puerto que usará Railway
EXPOSE 8080

# Comando para ejecutar Tomcat
CMD ["catalina.sh", "run"]
