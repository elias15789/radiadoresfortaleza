<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio de Sesión</title>
    <link rel="stylesheet" href="estilos/estilo2.css">
    <link href="img/logo/logo.png" rel="icon">
    <style>
        .company-header {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            flex-direction: column;
            text-align: center;
        }
        .company-logo {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 10px;
            border: 2px solid #ddd;
        }
        .company-name {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }
        .company-slogan {
            font-size: 14px;
            color: #666;
            font-style: italic;
        }
    </style>
</head>
<body>
<div class="formulario">
    <!-- Encabezado de la empresa -->
    <div class="company-header">
        <img src="img/logo/images.png" alt="Logo de la empresa" class="company-logo">
        <div class="company-name">Radiadores Fortaleza</div>
        
    </div>
    
    <h1>Inicio de Sesión</h1>
    <form action="LoginServlet" method="POST">
        <div class="username">  
            <input 
                oninput="removeNumbers(this); validateEmail()" 
                type="email" 
                name="email" 
                id="email" 
                required 
                placeholder="Correo Electrónico">
        </div>
        <div class="username">
            <input 
                maxlength="50" 
                type="password" 
                id="password" 
                name="password" 
                required 
                disabled 
                placeholder="Contraseña">
            <span class="toggle-password" onclick="togglePasswordVisibility()">👁️</span>
        </div>
        <input type="submit" value="Iniciar Sesión">
    </form>
    <% String error = (String) request.getAttribute("error");
        if (error != null) { %>
        <div class="mensaje-error"><p><%= error %></p></div>
    <% } %>
</div>
<script>
    function removeNumbers(input) {
        input.value = input.value.replace(/[0-9]/g, ''); 
    }

    function validateEmail() {
        var email = document.getElementById('email');
        var password = document.getElementById('password');
        var emailRegex = /^[A-Za-z+_.-]+@(.+)$/; 
        
        if (emailRegex.test(email.value)) {
            password.disabled = false;
        } else {
            password.disabled = true;
            password.value = ''; 
        }
    }

    function togglePasswordVisibility() {
        var password = document.getElementById('password');
        if (password.type === 'password') {
            password.type = 'text';
        } else {
            password.type = 'password';
        }
    }
</script>
</body>
</html>