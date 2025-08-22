<<<<<<< HEAD
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
=======
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
>>>>>>> ca9f218 (arreglado dockerfile)
