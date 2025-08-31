<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Radiadores Fortaleza</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap + Iconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="estilos/styles.css">

    <style>
        body {
            background-color: #f8f9fa;
            
        }
        .card-img-top {
            height: 200px;
            object-fit: contain;
            padding: 10px;
        }
        .card {
            transition: transform 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .catalog-container {
            max-width: 1200px;
            margin: auto;
            background: white;
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .sidebar {
            position: sticky;
            top: 20px;
        }
    </style>
</head>
<body>
    <!-- NAVBAR -->
    <nav class="navbar navbar-expand-lg fixed-top shadow-sm">
        <div class="container-lg"  >
          <a class="navbar-brand fw-bold text-white" href="index.jsp">Radiadores Fortaleza</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
              <li class="nav-item">
                <a class="nav-link active" aria-current="page" href="index.jsp">Inicio</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#services">Productos</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#about">Acerca de Nosotros</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#projects">Marcas</a>
              </li>
              
              <li class="nav-item">
                <a class="nav-link d-lg-none" href="#contact">Contact</a>
              </li>
            </ul>
            <a class="btn btn-outline-dark d-none d-lg-block" href="login.jsp">Iniciar Sesión</a>
          </div>
        </div>
      </nav>
    
    
    <section class="bg-dark" style="padding-top: 2rem;">
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <h1 class="page-title text-white mb-0">Catálogo de Productos</h1>
      </div>
    </div>
  </div>  
</section>
    


    
    <!-- CATÁLOGO CENTRADO -->
    <div class="container catalog-container">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3">
                <div class="sidebar">
                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Buscar Productos</h5>
                            <form action="CatalogoServlet" method="get">
                                <input type="search" name="q" class="form-control mb-2" placeholder="Buscar..." value="${param.q}">
                                <button class="btn btn-danger w-100" type="submit">Buscar</button>
                            </form>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Filtrar por Tipo</h5>
                            <div class="d-grid gap-2">
                                <a href="CatalogoServlet" class="btn btn-outline-secondary text-start">Todos</a>
                                <c:forEach items="${tiposProductos}" var="tipo">
                                    <a href="CatalogoServlet?tipo=${tipo}"
                                       class="btn btn-outline-secondary text-start ${param.tipo == tipo ? 'active' : ''}">
                                        ${tipo}
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                                
                    <div class="card mb-4">
    <div class="card-body">
        <h5 class="card-title">Filtrar por Marca</h5>
        <div class="d-grid gap-2">
            <a href="CatalogoServlet" 
               class="btn btn-outline-secondary text-start ${empty param.marca ? 'active' : ''}">
                Todas las marcas
            </a>
            <c:forEach items="${marcasProductos}" var="marca">
                <a href="CatalogoServlet?marca=${marca}"
                   class="btn btn-outline-secondary text-start ${param.marca == marca ? 'active' : ''}">
                    ${marca}
                </a>
            </c:forEach>
        </div>
    </div>
</div>
                </div>
            </div>

            <!-- Productos -->
            <div class="col-md-9">
                <h2 class="mb-4">${empty titulo ? 'Catálogo de Productos' : titulo}</h2>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <c:choose>
                    <c:when test="${empty productos}">
                        <div class="alert alert-info">No se encontraron productos.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-2 g-4">
                            <c:forEach items="${productos}" var="p">
                                <div class="col">
                                    <div class="card h-100">
                                        <img src="${pageContext.request.contextPath}/img/productos/placeholder.jpg"
                                             class="card-img-top" alt="${p.nombre}">
                                        <div class="card-body">
                                            <h5 class="card-title text-danger" style="font-size: 2rem;">${p.nombre}</h5>
                                            <p class="card-text">
                                                
                                                <strong>Tipo:</strong> ${p.tipo}<br>
                                                <strong>Precio:</strong> <span class="text-success">$${p.precio}</span>
                                            </p>
                                        </div>
                                        <div class="card-footer bg-white">
                                            <div class="d-flex justify-content-between">
                                                <small class="text-muted">Stock: ${p.cantidad}</small>
                                                <a href="#" class="btn btn-sm btn-outline-secondary">Ver detalles</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Paginación -->
                        <nav class="mt-4">
                            <ul class="pagination justify-content-center">
                                <c:if test="${paginaActual > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="CatalogoServlet?pagina=${paginaActual - 1}&q=${param.q}&tipo=${param.tipo}">Anterior</a>
                                    </li>
                                </c:if>
                                <c:forEach begin="1" end="${totalPaginas}" var="i">
                                    <li class="page-item ${i == paginaActual ? 'active' : ''}">
                                        <a class="page-link" href="CatalogoServlet?pagina=${i}&q=${param.q}&tipo=${param.tipo}">${i}</a>
                                    </li>
                                </c:forEach>
                                <c:if test="${paginaActual < totalPaginas}">
                                    <li class="page-item">
                                        <a class="page-link" href="CatalogoServlet?pagina=${paginaActual + 1}&q=${param.q}&tipo=${param.tipo}">Siguiente</a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <footer class="bg-dark text-white pt-5 pb-4 mt-5" id="contact">
        <div class="container text-center text-md-start">
            <div class="row">
                <div class="col-md-4">
                    <h5 class="text-uppercase mb-4 font-weight-bold text-warning">Radiadores Fortaleza</h5>
                    <p>Especialistas en radiadores para todo tipo de vehículos y maquinaria pesada.</p>
                </div>
                <div class="col-md-4">
                    <h5 class="text-uppercase mb-4 font-weight-bold text-warning">Contacto</h5>
                    <p><i class="fas fa-home me-3"></i> Av. la mar 354, Ica, Perú</p>
                    <p><i class="fas fa-envelope me-3"></i> radiadoresfortaleza@gmail.com</p>
                    <p><i class="fas fa-phone me-3"></i> +51 993 674 268</p>
                </div>
                <div class="col-md-4">
                    <h5 class="text-uppercase mb-4 font-weight-bold text-warning">Síguenos</h5>
                    <a href="#" class="text-white me-3"><i class="fab fa-facebook fa-lg"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-instagram fa-lg"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-whatsapp fa-lg"></i></a>
                </div>
            </div>
            <hr>
            <div class="text-center">&copy; 2025 Radiadores Fortaleza. Todos los derechos reservados.</div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
