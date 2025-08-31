<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error - Sistema Radiadores</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="alert alert-danger">
            <h4><i class="fas fa-exclamation-triangle"></i> Error del Sistema</h4>
            <p>Ha ocurrido un error inesperado:</p>
            <% if (exception != null) { %>
                <pre><%= exception.getMessage() %></pre>
            <% } %>
        </div>
        <a href="gestionar_proveedores.jsp" class="btn btn-primary">Volver a Proveedores</a>
        <a href="index.jsp" class="btn btn-secondary">Ir al Inicio</a>
    </div>
</body>
</html>















