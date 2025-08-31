<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Producto" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Almacén de Aluminio - Radiadores Fortaleza</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <link href="estilos/estiloscontrol.css" rel="stylesheet">
  <style>
    .card-stats {
      background: linear-gradient(45deg, #cc3333, #b52d3a);
      color: white;
    }
    .search-box {
      background-color: #f8f9fa;
      border-radius: 0.5rem;
      padding: 1rem;
      margin-bottom: 1rem;
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
            <a class="collapse-item active" href="AlmacenServlet?accion=VerAluminio">Radiadores de Aluminio</a>
            <a class="collapse-item" href="AlmacenServlet?accion=VerBronce">Radiadores de Bronce</a>
            <a class="collapse-item" href="stock_bajo.jsp">Stock Bajo</a>
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
          
          <!-- Estadísticas Rápidas -->
          <div class="row mb-4">
            <div class="col-md-6">
              <div class="card card-stats">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h6 class="text-uppercase mb-0">Productos de Aluminio</h6>
                      <span class="h2 font-weight-bold mb-0">
                        <% 
                          List<Producto> productos = (List<Producto>) request.getAttribute("listaProductos");
                          int totalAluminio = 0;
                          if (productos != null) {
                            for (Producto p : productos) {
                              if ("Aluminio".equalsIgnoreCase(p.getTipo())) {
                                totalAluminio++;
                              }
                            }
                          }
                          out.print(totalAluminio);
                        %>
                      </span>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-cube fa-2x"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="card card-stats">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h6 class="text-uppercase mb-0">Total Unidades</h6>
                      <span class="h2 font-weight-bold mb-0">
                        <% 
                          int stockAluminio = 0;
                          if (productos != null) {
                            for (Producto p : productos) {
                              if ("Aluminio".equalsIgnoreCase(p.getTipo())) {
                                stockAluminio += p.getCantidad();
                              }
                            }
                          }
                          out.print(stockAluminio);
                        %>
                      </span>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-layer-group fa-2x"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Alertas -->
          <% 
            String mensaje = (String) request.getAttribute("mensaje");
            if (mensaje != null) { 
          %>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
              <i class="fas fa-info-circle"></i> <%= mensaje %>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
          <% } %>

          <!-- Buscador -->
          <div class="search-box">
            <h5 style="color: #cc3333;" class="mb-3"><i class="fas fa-search"></i> Buscar Producto de Aluminio</h5>
            <form action="AlmacenServlet" method="post">
              <input type="hidden" name="accion" value="Buscar">
              <div class="row">
                <div class="col-md-8">
                  <input type="text" name="nombre" class="form-control" placeholder="Nombre del producto de aluminio..." required>
                </div>
                <div class="col-md-4">
                  <button type="submit" class="btn btn-block" style="background-color: #cc3333; border-color: #cc3333; color: white;">
                    <i class="fas fa-search"></i> Buscar
                  </button>
                </div>
              </div>
            </form>
          </div>

          <!-- Lista de Productos de Aluminio -->
          <div class="card shadow">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold" style="color: #cc3333;">
                <i class="fas fa-cube"></i> Radiadores de Aluminio
              </h6>
            </div>
            <div class="card-body">
              <% if (productos != null && !productos.isEmpty()) { 
                   boolean hayAluminio = false;
                   for (Producto p : productos) {
                     if ("Aluminio".equalsIgnoreCase(p.getTipo())) {
                       hayAluminio = true;
                       break;
                     }
                   }
                   
                   if (hayAluminio) { 
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
                      </tr>
                    </thead>
                    <tbody>
                      <% for (Producto p : productos) { 
                           if ("Aluminio".equalsIgnoreCase(p.getTipo())) { %>
                        <tr>
                          <td><%= p.getNombre() %></td>
                          <td><%= p.getModelo() %></td>
                          <td><span class="badge badge-secondary"><%= p.getTipo() %></span></td>
                          <td>S/ <%= df.format(p.getPrecio()) %></td>
                          <td>
                            <% if (p.getCantidad() <= 2) { %>
                              <span class="badge badge-danger"><%= p.getCantidad() %> unidades</span>
                            <% } else if (p.getCantidad() <= 5) { %>
                              <span class="badge badge-warning"><%= p.getCantidad() %> unidades</span>
                            <% } else { %>
                              <span class="badge badge-success"><%= p.getCantidad() %> unidades</span>
                            <% } %>
                          </td>
                        </tr>
                      <% } } %>
                    </tbody>
                  </table>
                </div>
              <% } else { %>
                <div class="text-center text-muted py-4">
                  <i class="fas fa-cube fa-3x mb-3"></i>
                  <h4>No hay productos de aluminio</h4>
                  <p>No se encontraron radiadores de aluminio en el inventario.</p>
                </div>
              <% } } else { %>
                <div class="text-center text-muted py-4">
                  <i class="fas fa-cube fa-3x mb-3"></i>
                  <h4>No hay productos disponibles</h4>
                  <p>Cargue productos para ver el inventario.</p>
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