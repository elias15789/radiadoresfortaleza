<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Venta" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Reporte de Ventas - Radiadores Fortaleza</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link href="estilos/estiloscontrol.css" rel="stylesheet">
  <style>
    /* Colores corporativos de Radiadores Fortaleza */
    .report-header {
      background: linear-gradient(45deg, #cc3333, #b52d3a);
      color: white;
      padding: 2rem 0;
      margin-bottom: 2rem;
    }
    .stat-card {
      background: #f8f9fa;
      border-left: 4px solid #cc3333;
      padding: 1rem;
      margin-bottom: 1rem;
    }
    .text-radiadores { color: #cc3333; }
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
    .card-radiadores {
      border-left: 4px solid #cc3333;
    }
    .table th {
      background-color: #f8f9fa;
      border-color: #dee2e6;
      color: #495057;
    }
    @media print {
      .no-print { display: none !important; }
      .sidebar { display: none !important; }
      #content-wrapper { margin-left: 0 !important; }
    }
  </style>
</head>
<body id="page-top">
  <div id="wrapper">

    <!-- Sidebar -->
    <ul class="navbar-nav sidebar sidebar-light accordion no-print" id="accordionSidebar">
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
          <span>Panel de Control</span></a>
      </li>
      <% } %>
      <hr class="sidebar-divider">
      <div class="sidebar-heading">Características</div>
      
      
      <% boolean puedeAlmacen = true; try { String r = (String) session.getAttribute("rolUsuario"); puedeAlmacen = (r == null) || "ADMIN".equals(r) || "ALMACEN".equals(r) || "ALMACENERO".equals(r); } catch(Exception e) { puedeAlmacen = true; } %>
      <li class="nav-item" style="<%= puedeAlmacen ? "" : "display:none;" %>">
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
      
      <% boolean puedeVentas = true; try { String r = (String) session.getAttribute("rolUsuario"); puedeVentas = (r == null) || "ADMIN".equals(r) || "VENTAS".equals(r) || "ASESOR".equals(r) || "ASESOR_VENTAS".equals(r); } catch(Exception e) { puedeVentas = true; } %>
      <li class="nav-item" style="<%= puedeVentas ? "" : "display:none;" %>">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseVentas" aria-expanded="true"
          aria-controls="collapseVentas">
          <i class="fas fa-shopping-cart"></i>
          <span>Ventas</span>
        </a>
        <div id="collapseVentas" class="collapse show" aria-labelledby="headingVentas" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Gestión de Ventas</h6>
            <a class="collapse-item" href="VentaServlet">Registrar Venta</a>
            <a class="collapse-item" href="VentaServlet?accion=listar">Ver Todas las Ventas</a>
            <a class="collapse-item active" href="VentaServlet?accion=reporteDiario">Reporte Diario</a>
          </div>
        </div>
      </li>
      
      <!-- Control de Compras -->
      <% boolean puedeProveedores = true; try { String r = (String) session.getAttribute("rolUsuario"); puedeProveedores = (r == null) || "ADMIN".equals(r); } catch(Exception e) { puedeProveedores = true; } %>
      <li class="nav-item" style="<%= puedeProveedores ? "" : "display:none;" %>">
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

      <hr class="sidebar-divider">
    </ul>

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">
      <div id="content">
        <!-- TopBar -->
        <nav class="navbar navbar-expand navbar-light bg-navbar topbar mb-4 static-top no-print">
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
          
          <!-- Header del Reporte -->
          <div class="report-header text-center">
            <h1><i class="fas fa-chart-line"></i> Reporte de Ventas Diario</h1>
            <h3>Radiadores Fortaleza</h3>
            <p class="mb-0">Fecha: <%= request.getAttribute("fechaReporte") != null ? request.getAttribute("fechaReporte") : "Hoy" %></p>
          </div>

          <!-- Estadísticas Generales -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="card shadow">
                <div class="card-header py-3">
                  <h6 class="m-0 font-weight-bold text-radiadores">
                    <i class="fas fa-calculator"></i> Resumen del Día
                  </h6>
                </div>
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-4">
                      <div class="stat-card text-center">
                        <h4 class="text-radiadores">
                          <% 
                            DecimalFormat df = new DecimalFormat("#,##0.00");
                            Double totalHoy = (Double) request.getAttribute("totalVentasHoy");
                            if (totalHoy != null) {
                              out.print("S/ " + df.format(totalHoy));
                            } else {
                              out.print("S/ 0.00");
                            }
                          %>
                        </h4>
                        <p class="mb-0"><strong>Total de Ingresos</strong></p>
                      </div>
                    </div>
                    <div class="col-md-4">
                      <div class="stat-card text-center">
                        <h4 class="text-radiadores">
                          <% 
                            List<Venta> ventasHoy = (List<Venta>) request.getAttribute("ventasHoy");
                            int totalVentas = ventasHoy != null ? ventasHoy.size() : 0;
                            out.print(totalVentas);
                          %>
                        </h4>
                        <p class="mb-0"><strong>Número de Ventas</strong></p>
                      </div>
                    </div>
                    <div class="col-md-4">
                      <div class="stat-card text-center">
                        <h4 class="text-radiadores">
                          <% 
                            if (ventasHoy != null && totalVentas > 0) {
                              double promedio = totalHoy / totalVentas;
                              out.print("S/ " + df.format(promedio));
                            } else {
                              out.print("S/ 0.00");
                            }
                          %>
                        </h4>
                        <p class="mb-0"><strong>Venta Promedio</strong></p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Detalle de Ventas -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-radiadores">
                <i class="fas fa-list"></i> Detalle de Ventas del Día
              </h6>
            </div>
            <div class="card-body">
              <% if (ventasHoy != null && !ventasHoy.isEmpty()) { 
                   SimpleDateFormat sdf = new SimpleDateFormat("HH:mm"); %>
                <div class="table-responsive">
                  <table class="table table-bordered table-striped">
                    <thead class="thead-dark">
                      <tr>
                        <th>Hora</th>
                        <th>Cliente</th>
                        <th>Documento</th>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>P. Unitario</th>
                        <th>Total</th>
                        <th>Estado</th>
                      </tr>
                    </thead>
                    <tbody>
                      <% for (Venta venta : ventasHoy) { %>
                        <tr>
                          <td><%= sdf.format(venta.getFecha()) %></td>
                          <td><%= venta.getNombreCliente() %></td>
                          <td>
                            <%= venta.getTipoDocumento() %>: <%= venta.getDocumentoCliente() %>
                          </td>
                          <td>
                            <%= venta.getNombreProducto() != null ? venta.getNombreProducto() : "Producto #" + venta.getIdProducto() %>
                          </td>
                          <td class="text-center"><%= venta.getCantidadVendida() %></td>
                          <td class="text-right">S/ <%= df.format(venta.getPrecioUnitario()) %></td>
                          <td class="text-right"><strong>S/ <%= df.format(venta.getTotal()) %></strong></td>
                          <td>
                            <% if ("COMPLETADA".equals(venta.getEstado())) { %>
                              <span class="badge badge-success">COMPLETADA</span>
                            <% } else if ("PENDIENTE".equals(venta.getEstado())) { %>
                              <span class="badge badge-warning">PENDIENTE</span>
                            <% } else { %>
                              <span class="badge badge-danger">CANCELADA</span>
                            <% } %>
                          </td>
                        </tr>
                      <% } %>
                    </tbody>
                    <tfoot class="thead-light">
                      <tr>
                        <th colspan="6" class="text-right">TOTAL DEL DÍA:</th>
                        <th class="text-right">S/ <%= df.format(totalHoy != null ? totalHoy : 0.0) %></th>
                        <th></th>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              <% } else { %>
                <div class="text-center text-muted py-5">
                  <i class="fas fa-calendar-times fa-3x mb-3"></i>
                  <h4>No hay ventas registradas hoy</h4>
                  <p>Aún no se han registrado ventas para el día de hoy.</p>
                </div>
              <% } %>
            </div>
          </div>

          <!-- Acciones -->
          <div class="row no-print">
            <div class="col-md-12 text-center">
              <a href="VentaServlet?accion=listar" class="btn btn-secondary btn-lg mr-2">
                <i class="fas fa-list"></i> Ver Todas las Ventas
              </a>
              <button onclick="window.print()" class="btn btn-radiadores btn-lg">
                <i class="fas fa-print"></i> Imprimir Reporte
              </button>
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
      // Toggle sidebar
      $("#sidebarToggleTop").click(function() {
        $("#accordionSidebar").toggleClass("toggled");
      });
    });
  </script>
</body>
</html>
