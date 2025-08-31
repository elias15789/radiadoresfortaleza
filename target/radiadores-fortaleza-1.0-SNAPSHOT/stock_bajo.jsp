<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Producto" %>
<%@ page import="modelo.dao.ProductoDAO" %>
<%@ page import="java.text.DecimalFormat" %>
<%
  // Cargar productos con stock bajo
  ProductoDAO productoDAO = new ProductoDAO();
  List<Producto> productos = productoDAO.obtenerProductosStockBajo();
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Productos con Stock Bajo - Radiadores Fortaleza</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link href="estilos/estiloscontrol.css" rel="stylesheet">
  <style>
    .card-stats {
      background: linear-gradient(45deg, #cc3333, #b52d3a);
      color: white;
    }
    .table-responsive {
      font-size: 0.875rem;
    }
  </style>
</head>
<body id="page-top">
  <div id="wrapper">

    <!-- Sidebar -->
    <ul class="navbar-nav sidebar sidebar-light accordion" id="accordionSidebar">
      <a class="sidebar-brand d-flex align-items-center justify-content-center" href="panel.jsp">
        <div class="sidebar-brand-icon">
          <img src="img/logo/images.png">
        </div>
        <div class="sidebar-brand-text mx-3">Radiadores Fortaleza</div>
      </a>
      <hr class="sidebar-divider my-0">
      
      <% boolean mostrarPanel = true; try { String r = (String) session.getAttribute("rolUsuario"); mostrarPanel = (r == null) || "ADMIN".equals(r); } catch(Exception e) { mostrarPanel = true; } %>
      <% if (mostrarPanel) { %>
      <li class="nav-item">
        <a class="nav-link" href="panel.jsp">
          <i class="fas fa-fw fa-tachometer-alt"></i>
          <span>Panel de Control</span>
        </a>
      </li>
      <% } %>
      
      <hr class="sidebar-divider">
      <div class="sidebar-heading">Gestión</div>
      
      <!-- Almacén -->
      <% boolean puedeAlmacen = true; try { String r = (String) session.getAttribute("rolUsuario"); puedeAlmacen = (r == null) || "ADMIN".equals(r) || "ALMACEN".equals(r) || "ALMACENERO".equals(r); } catch(Exception e) { puedeAlmacen = true; } %>
      <% if (puedeAlmacen) { %>
      <li class="nav-item active">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseAlmacen"
          aria-expanded="true" aria-controls="collapseAlmacen">
          <i class="fas fa-warehouse"></i>
          <span>Almacén</span>
        </a>
        <div id="collapseAlmacen" class="collapse show" aria-labelledby="headingAlmacen" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Productos en Almacén</h6>
            <a class="collapse-item" href="AlmacenServlet">Gestor de Almacén</a>
            <a class="collapse-item" href="AlmacenServlet?accion=VerAluminio">Radiadores de Aluminio</a>
            <a class="collapse-item" href="AlmacenServlet?accion=VerBronce">Radiadores de Bronce</a>
            <a class="collapse-item active" href="stock_bajo.jsp">Stock Bajo</a>
          </div>
        </div>
      </li>
      <% } %>
      
      <!-- Ventas -->
      <% boolean puedeVentas = true; try { String r = (String) session.getAttribute("rolUsuario"); puedeVentas = (r == null) || "ADMIN".equals(r) || "VENTAS".equals(r) || "ASESOR".equals(r) || "ASESOR_VENTAS".equals(r); } catch(Exception e) { puedeVentas = true; } %>
      <% if (puedeVentas) { %>
      <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseVentas" 
          aria-expanded="true" aria-controls="collapseVentas">
          <i class="fas fa-shopping-cart"></i>
          <span>Ventas</span>
        </a>
        <div id="collapseVentas" class="collapse" aria-labelledby="headingVentas" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Gestión de Ventas</h6>
            <a class="collapse-item" href="VentaServlet">Registrar Venta</a>
            <a class="collapse-item" href="VentaServlet?accion=listar">Ver Todas las Ventas</a>
            <a class="collapse-item" href="VentaServlet?accion=reporteDiario">Reporte Diario</a>
          </div>
        </div>
      </li>
      <% } %>

      <!-- Control de Compras -->
      <% boolean puedeProveedores = true; try { String r = (String) session.getAttribute("rolUsuario"); puedeProveedores = (r == null) || "ADMIN".equals(r); } catch(Exception e) { puedeProveedores = true; } %>
      <% if (puedeProveedores) { %>
      <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseControlCompras" 
          aria-expanded="true" aria-controls="collapseControlCompras">
          <i class="fas fa-shopping-basket"></i>
          <span>Control de Compras</span>
        </a>
        <div id="collapseControlCompras" class="collapse" aria-labelledby="headingControlCompras" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Proveedores y Órdenes</h6>
            <a class="collapse-item" href="gestionar_proveedores.jsp">Gestionar Proveedores</a>
            <a class="collapse-item" href="ordenes_venta.jsp">Órdenes de Compra</a>
          </div>
        </div>
      </li>
      <% } %>

      <hr class="sidebar-divider">
    </ul>

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">
      <div id="content">
        <!-- TopBar -->
        <nav class="navbar navbar-expand navbar-light bg-navbar topbar mb-4 static-top">
          <button id="sidebarToggleTop" class="btn btn-link rounded-circle mr-3">
            <i class="fa fa-bars"></i>
          </button>
          <ul class="navbar-nav ml-auto">
            <div class="topbar-divider d-none d-sm-block"></div>
            <li class="nav-item dropdown no-arrow">
              <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown"
                aria-haspopup="true" aria-expanded="false">
                <img class="img-profile rounded-circle" src="img/boy.png" style="max-width: 60px">
                 <span class="ml-2 d-none d-lg-inline text-white small"><%= session.getAttribute("rolUsuario") != null ? ((String)session.getAttribute("rolUsuario")) : "USUARIO" %></span>
              </a>
              <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
                <a href="login.jsp" class="dropdown-item">
                  <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                  Cerrar Sesión
                </a>
              </div>
            </li>
          </ul>
        </nav>

        <!-- Page Content -->
        <div class="container-fluid">
          
          <!-- Estadísticas -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="card card-stats">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h6 class="text-uppercase mb-0">Productos con Stock Bajo</h6>
                      <span class="h2 font-weight-bold mb-0">
                        <%= productos != null ? productos.size() : 0 %>
                      </span>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-exclamation-triangle fa-2x"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Lista de Productos con Stock Bajo -->
          <div class="card shadow">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold" style="color: #cc3333;">
                <i class="fas fa-exclamation-triangle"></i> Productos con Stock Bajo (≤ 5 unidades)
              </h6>
            </div>
            <div class="card-body">
              <% if (productos != null && !productos.isEmpty()) { 
                   DecimalFormat df = new DecimalFormat("#,##0.00");
              %>
                <div class="table-responsive">
                  <table class="table table-bordered table-hover">
                    <thead style="background-color: #cc3333; color: white;">
                      <tr>
                        <th>Nombre</th>
                        <th>Modelo</th>
                        <th>Tipo</th>
                        <th>Precio</th>
                        <th>Cantidad</th>
                        <th>Estado</th>
                      </tr>
                    </thead>
                    <tbody>
                      <% for (Producto p : productos) { %>
                        <tr>
                          <td><%= p.getNombre() %></td>
                          <td><%= p.getModelo() %></td>
                          <td>
                            <% if ("Aluminio".equalsIgnoreCase(p.getTipo())) { %>
                              <span class="badge badge-secondary"><%= p.getTipo() %></span>
                            <% } else if ("Bronce".equalsIgnoreCase(p.getTipo())) { %>
                              <span class="badge badge-warning"><%= p.getTipo() %></span>
                            <% } else { %>
                              <span class="badge badge-info"><%= p.getTipo() %></span>
                            <% } %>
                          </td>
                          <td>S/ <%= df.format(p.getPrecio()) %></td>
                          <td>
                            <% if (p.getCantidad() <= 2) { %>
                              <span class="badge badge-danger font-weight-bold"><%= p.getCantidad() %> unidades</span>
                            <% } else { %>
                              <span class="badge badge-warning font-weight-bold"><%= p.getCantidad() %> unidades</span>
                            <% } %>
                          </td>
                          <td>
                            <% if (p.getCantidad() <= 2) { %>
                              <span class="badge badge-danger">
                                <i class="fas fa-exclamation-triangle"></i> CRÍTICO
                              </span>
                            <% } else { %>
                              <span class="badge badge-warning">
                                <i class="fas fa-exclamation"></i> BAJO
                              </span>
                            <% } %>
                          </td>
                        </tr>
                      <% } %>
                    </tbody>
                  </table>
                </div>
              <% } else { %>
                <div class="text-center text-success py-5">
                  <i class="fas fa-check-circle fa-3x mb-3"></i>
                  <h4>¡Excelente! No hay productos con stock bajo</h4>
                  <p class="text-muted">Todos los productos tienen stock adecuado en este momento.</p>
                  <a href="AlmacenServlet" class="btn" style="background-color: #cc3333; border-color: #cc3333; color: white;">
                    <i class="fas fa-warehouse"></i> Ver Todo el Inventario
                  </a>
                </div>
              <% } %>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>

  <!-- Scripts -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
  
  <script>
    $(document).ready(function() {
      $("#sidebarToggleTop").click(function() {
        $("#accordionSidebar").toggleClass("toggled");
      });
    });
  </script>
</body>
</html>