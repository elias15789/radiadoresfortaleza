<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Producto" %>
<%@ page import="modelo.Venta" %>
<%@ page import="modelo.dao.ProductoDAO" %>
<%@ page import="modelo.dao.VentaDAO" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Cargar datos para el dashboard
  ProductoDAO productoDAO = new ProductoDAO();
  VentaDAO ventaDAO = new VentaDAO();
  
  List<Producto> productos = productoDAO.obtenerProductos();
  List<Producto> stockBajo = productoDAO.obtenerProductosStockBajo();
  List<Venta> ventasRecientes = ventaDAO.obtenerVentasPaginadas(1, 5);
  
  double totalVentasHoy = ventaDAO.obtenerTotalVentasHoy();
  double totalVentasMes = ventaDAO.obtenerTotalVentasMes();
  
  int totalProductos = productos.size();
  int productosStockBajo = stockBajo.size();
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Panel de Control - Radiadores Fortaleza</title>
  <link href="img/logo/logo.png" rel="icon">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <link href="estilos/estiloscontrol.css" rel="stylesheet">
  <style>
    /* Colores corporativos Radiadores Fortaleza */
    .card-radiadores {
      border-left: 4px solid #cc3333;
    }
    .text-radiadores {
      color: #cc3333;
    }
    .bg-radiadores {
      background: linear-gradient(45deg, #cc3333, #b52d3a);
      color: white;
    }
    .btn-radiadores {
      background-color: #cc3333;
      border-color: #cc3333;
      color: white;
    }
    .btn-radiadores:hover {
      background-color: #b52d3a;
      border-color: #b52d3a;
      color: white;
    }
    .dashboard-header {
      background: linear-gradient(45deg, #cc3333, #b52d3a);
      color: white;
      padding: 2rem 0;
      margin-bottom: 2rem;
      border-radius: 0.5rem;
    }
    .stat-card {
      transition: transform 0.2s;
      cursor: pointer;
    }
    .stat-card:hover {
      transform: translateY(-5px);
    }
    .stat-number {
      font-size: 2rem;
      font-weight: bold;
      color: #cc3333;
    }
    .progress-custom {
      height: 8px;
      background-color: #f8f9fa;
    }
    .progress-bar-radiadores {
      background-color: #cc3333;
    }
    .alert-stock {
      border-left: 4px solid #ffc107;
      background-color: #fff3cd;
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
      
      <!-- Dashboard -->
      <li class="nav-item active">
        <a class="nav-link" href="panel.jsp">
          <i class="fas fa-fw fa-tachometer-alt"></i>
          <span>Panel de Control</span>
        </a>
      </li>
      
      <hr class="sidebar-divider">
      <div class="sidebar-heading">Gestión</div>
      
      <!-- Almacén -->
      <% boolean puedeAlmacen = true; try { String r = (String) session.getAttribute("rolUsuario"); puedeAlmacen = (r == null) || "ADMIN".equals(r) || "ALMACEN".equals(r) || "ALMACENERO".equals(r); } catch(Exception e) { puedeAlmacen = true; } %>
      <% if (puedeAlmacen) { %>
      <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseAlmacen"
          aria-expanded="true" aria-controls="collapseAlmacen">
          <i class="fas fa-warehouse"></i>
          <span>Almacén</span>
        </a>
        <div id="collapseAlmacen" class="collapse" aria-labelledby="headingAlmacen" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Productos en Almacén</h6>
            <a class="collapse-item" href="AlmacenServlet">Gestor de Almacén</a>
            <a class="collapse-item" href="AlmacenServlet?accion=VerAluminio">Radiadores de Aluminio</a>
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
          
          <!-- Header del Dashboard -->
          <div class="dashboard-header text-center">
            <h1><i class=></i> Panel de Control</h1>
            
            <p class="mb-0">Resumen general del sistema</p>
          </div>

          <!-- Estadísticas Principales -->
          <div class="row">
            <!-- Ventas Hoy -->
            <div class="col-xl-3 col-md-6 mb-4">
              <div class="card card-radiadores shadow h-100 py-2 stat-card" onclick="location.href='VentaServlet?accion=reporteDiario'">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                      <div class="text-xs font-weight-bold text-uppercase mb-1">Ventas Hoy</div>
                      <div class="stat-number">
                        <% 
                          DecimalFormat df = new DecimalFormat("#,##0.00");
                          out.print("S/ " + df.format(totalVentasHoy));
                        %>
                      </div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-calendar-day fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Ventas Mes -->
            <div class="col-xl-3 col-md-6 mb-4">
              <div class="card card-radiadores shadow h-100 py-2 stat-card">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                      <div class="text-xs font-weight-bold text-uppercase mb-1">Ventas del Mes</div>
                      <div class="stat-number">S/ <%= df.format(totalVentasMes) %></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-calendar-alt fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Total Productos -->
            <div class="col-xl-3 col-md-6 mb-4">
              <div class="card card-radiadores shadow h-100 py-2 stat-card" onclick="location.href='AlmacenServlet'">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                      <div class="text-xs font-weight-bold text-uppercase mb-1">Total Productos</div>
                      <div class="stat-number"><%= totalProductos %></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-boxes fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Alertas de Stock -->
            <div class="col-xl-3 col-md-6 mb-4">
              <div class="card border-left-warning shadow h-100 py-2 stat-card" onclick="location.href='stock_bajo.jsp'">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                      <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Stock Bajo</div>
                      <div class="h5 mb-0 font-weight-bold text-gray-800"><%= productosStockBajo %></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Gráficos y Tablas -->
          <div class="row">
            
            <!-- Ventas Recientes -->
            <div class="col-lg-8 mb-4">
              <div class="card shadow">
                <div class="card-header py-3">
                  <h6 class="m-0 font-weight-bold text-radiadores">
                    <i class="fas fa-history"></i> Ventas Recientes
                  </h6>
                </div>
                <div class="card-body">
                  <% if (ventasRecientes != null && !ventasRecientes.isEmpty()) { 
                       SimpleDateFormat sdf = new SimpleDateFormat("dd/MM HH:mm"); %>
                    <div class="table-responsive">
                      <table class="table table-sm">
                        <thead>
                          <tr>
                            <th>Fecha</th>
                            <th>Cliente</th>
                            <th>Producto</th>
                            <th>Total</th>
                          </tr>
                        </thead>
                        <tbody>
                          <% for (Venta venta : ventasRecientes) { %>
                            <tr>
                              <td><%= sdf.format(venta.getFecha()) %></td>
                              <td><%= venta.getNombreCliente() %></td>
                              <td><%= venta.getNombreProducto() != null ? venta.getNombreProducto() : "Producto #" + venta.getIdProducto() %></td>
                              <td><strong>S/ <%= df.format(venta.getTotal()) %></strong></td>
                            </tr>
                          <% } %>
                        </tbody>
                      </table>
                    </div>
                    <div class="text-center mt-3">
                      <a href="VentaServlet?accion=listar" class="btn btn-radiadores">
                        <i class="fas fa-list"></i> Ver Todas las Ventas
                      </a>
                    </div>
                  <% } else { %>
                    <div class="text-center text-muted py-4">
                      <i class="fas fa-shopping-cart fa-3x mb-3"></i>
                      <p>No hay ventas registradas aún</p>
                      <a href="VentaServlet" class="btn btn-radiadores">
                        <i class="fas fa-plus"></i> Registrar Primera Venta
                      </a>
                    </div>
                  <% } %>
                </div>
              </div>
            </div>

            <!-- Alertas de Stock -->
            <div class="col-lg-4 mb-4">
              <div class="card shadow">
                <div class="card-header py-3">
                  <h6 class="m-0 font-weight-bold text-warning">
                    <i class="fas fa-exclamation-triangle"></i> Alertas de Stock
                  </h6>
                </div>
                <div class="card-body">
                  <% if (stockBajo != null && !stockBajo.isEmpty()) { %>
                    <% for (Producto producto : stockBajo) { %>
                      <div class="alert-stock p-2 mb-2 rounded">
                        <div class="d-flex justify-content-between align-items-center">
                          <div>
                            <strong><%= producto.getNombre() %></strong><br>
                            <small class="text-muted">Stock: <%= producto.getCantidad() %> unidades</small>
                          </div>
                          <div>
                            <% if (producto.getCantidad() <= 2) { %>
                              <span class="badge badge-danger">Crítico</span>
                            <% } else { %>
                              <span class="badge badge-warning">Bajo</span>
                            <% } %>
                          </div>
                        </div>
                      </div>
                    <% } %>
                    <div class="text-center mt-3">
                      <a href="stock_bajo.jsp" class="btn btn-warning btn-sm">
                        <i class="fas fa-exclamation-triangle"></i> Ver Stock Bajo
                      </a>
                    </div>
                  <% } else { %>
                    <div class="text-center text-success py-3">
                      <i class="fas fa-check-circle fa-2x mb-2"></i>
                      <p class="mb-0">Stock en buen estado</p>
                    </div>
                  <% } %>
                </div>
              </div>
            </div>
          </div>

          

        </div>
      </div>
    </div>
  </div>

  <!-- Scroll to top -->
  <a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
  </a>

  <!-- Scripts -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
  
  <script>
    $(document).ready(function() {
      // Toggle sidebar
      $("#sidebarToggleTop").click(function() {
        $("#accordionSidebar").toggleClass("toggled");
      });

      // Animación para las tarjetas de estadísticas
      $(".stat-card").hover(
        function() {
          $(this).addClass("shadow-lg");
        },
        function() {
          $(this).removeClass("shadow-lg");
        }
      );
    });
  </script>
</body>
</html>