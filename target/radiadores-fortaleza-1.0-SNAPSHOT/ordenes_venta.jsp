<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.OrdenVenta" %>
<%@ page import="modelo.Proveedor" %>
<%@ page import="modelo.Producto" %>
<%@ page import="modelo.dao.OrdenVentaDAO" %>
<%@ page import="modelo.dao.ProveedorDAO" %>
<%@ page import="modelo.dao.ProductoDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%
  // Obtener datos desde el servlet (si están disponibles) o cargar directamente
  List<OrdenVenta> ordenes = (List<OrdenVenta>) request.getAttribute("ordenes");
  List<Proveedor> proveedoresActivos = (List<Proveedor>) request.getAttribute("proveedoresActivos");
  List<Producto> productos = (List<Producto>) request.getAttribute("productos");
  
  if (ordenes == null || proveedoresActivos == null || productos == null) {
    // Si no vienen del servlet, cargar directamente (primera carga de la página)
    OrdenVentaDAO ordenDAO = new OrdenVentaDAO();
    ProveedorDAO proveedorDAO = new ProveedorDAO();
    ProductoDAO productoDAO = new ProductoDAO();
    
    if (ordenes == null) ordenes = ordenDAO.obtenerOrdenesVenta();
    if (proveedoresActivos == null) proveedoresActivos = proveedorDAO.obtenerProveedoresActivos();
    if (productos == null) productos = productoDAO.obtenerProductos();
  }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Órdenes de Compra - Radiadores Fortaleza</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
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
    .modal-header {
      background: linear-gradient(45deg, #cc3333, #b52d3a);
      color: white;
    }
    .badge-pendiente { background-color: #ffc107; color: #000; }
    .badge-aprobada { background-color: #17a2b8; }
    .badge-enviada { background-color: #007bff; }
    .badge-recibida { background-color: #28a745; }
    .badge-cancelada { background-color: #dc3545; }
    .proveedor-info {
      background-color: #f8f9fa;
      border: 1px solid #dee2e6;
      border-radius: 0.25rem;
      padding: 0.75rem;
      margin-top: 0.5rem;
      display: none;
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
      <!-- Dashboard -->
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
      <% boolean puedeVentas = true; try { String r = (String) session.getAttribute("rolUsuario"); puedeVentas = (r == null) || "ADMIN".equals(r) || "VENTAS".equals(r) || "VENDEDOR".equals(r) || "ASESOR".equals(r) || "ASESOR_VENTAS".equals(r); } catch(Exception e) { puedeVentas = true; } %>
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
      <li class="nav-item active">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseControlCompras" 
          aria-expanded="true" aria-controls="collapseControlCompras">
          <i class="fas fa-shopping-basket"></i>
          <span>Control de Compras</span>
        </a>
        <div id="collapseControlCompras" class="collapse show" aria-labelledby="headingControlCompras" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Proveedores y Órdenes</h6>
            <a class="collapse-item" href="gestionar_proveedores.jsp">Gestionar Proveedores</a>
            <a class="collapse-item active" href="ordenes_venta.jsp">Órdenes de Compra</a>
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
            <div class="col-md-3">
              <div class="card card-stats">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h6 class="text-uppercase mb-0">Total Órdenes</h6>
                      <span class="h2 font-weight-bold mb-0">
                        <%= ordenes != null ? ordenes.size() : 0 %>
                      </span>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-file-invoice fa-2x"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-3">
              <div class="card card-stats">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h6 class="text-uppercase mb-0">Pendientes</h6>
                      <span class="h2 font-weight-bold mb-0">
                        <% 
                          int pendientes = 0;
                          if (ordenes != null) {
                            for (OrdenVenta o : ordenes) {
                              if ("PENDIENTE".equals(o.getEstado())) pendientes++;
                            }
                          }
                          out.print(pendientes);
                        %>
                      </span>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-clock fa-2x"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-3">
              <div class="card card-stats">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h6 class="text-uppercase mb-0">Valor Total</h6>
                      <span class="h2 font-weight-bold mb-0">
                        <% 
                          double valorTotal = 0;
                          if (ordenes != null) {
                            for (OrdenVenta o : ordenes) {
                              valorTotal += o.getTotal();
                            }
                          }
                          DecimalFormat df = new DecimalFormat("#,##0");
                          out.print("S/ " + df.format(valorTotal));
                        %>
                      </span>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-dollar-sign fa-2x"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-3">
              <div class="card card-stats">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h6 class="text-uppercase mb-0">Completadas</h6>
                      <span class="h2 font-weight-bold mb-0">
                        <% 
                          int completadas = 0;
                          if (ordenes != null) {
                            for (OrdenVenta o : ordenes) {
                              if ("RECIBIDA".equals(o.getEstado())) completadas++;
                            }
                          }
                          out.print(completadas);
                        %>
                      </span>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-check-circle fa-2x"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Alertas -->
          <% 
            String mensaje = (String) request.getAttribute("mensaje");
            String error = (String) request.getAttribute("error");
            if (mensaje != null) { 
          %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
              <i class="fas fa-check-circle"></i> <%= mensaje %>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
          <% } %>
          
          <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <i class="fas fa-exclamation-triangle"></i> <%= error %>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
          <% } %>

          <!-- Acciones Rápidas -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="card shadow">
                <div class="card-header py-3">
                  <h6 class="m-0 font-weight-bold" style="color: #cc3333;">
                    <i class="fas fa-tools"></i> Acciones Rápidas
                  </h6>
                </div>
                <div class="card-body">
                  <div class="row text-center">
                    <div class="col-md-3 mb-2">
                      <button class="btn btn-radiadores btn-block" data-toggle="modal" data-target="#modalCrearOrden">
                        <i class="fas fa-plus fa-2x mb-2"></i><br>
                        Nueva Orden
                      </button>
                    </div>
                    <div class="col-md-3 mb-2">
                      <button class="btn btn-info btn-block" onclick="toggleBusqueda()">
                        <i class="fas fa-search fa-2x mb-2"></i><br>
                        Buscar Orden
                      </button>
                    </div>
                    <div class="col-md-3 mb-2">
                      <button class="btn btn-warning btn-block" onclick="filtrarOrdenes('PENDIENTE')">
                        <i class="fas fa-clock fa-2x mb-2"></i><br>
                        Solo Pendientes
                      </button>
                    </div>
                    <div class="col-md-3 mb-2">
                      <a href="gestionar_proveedores.jsp" class="btn btn-secondary btn-block">
                        <i class="fas fa-users fa-2x mb-2"></i><br>
                        Gestionar Proveedores
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Búsqueda -->
          <div id="busquedaSection" class="search-box" style="display: none;">
            <h5 style="color: #cc3333;" class="mb-3"><i class="fas fa-search"></i> Buscar Orden</h5>
            <div class="row">
              <div class="col-md-8">
                <input type="text" id="buscarOrden" class="form-control" placeholder="Número de orden, proveedor o producto...">
              </div>
              <div class="col-md-4">
                <button type="button" class="btn btn-radiadores btn-block" onclick="buscarOrden()">
                  <i class="fas fa-search"></i> Buscar
                </button>
              </div>
            </div>
          </div>

          <!-- Lista de Órdenes -->
          <div class="card shadow">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold" style="color: #cc3333;">
                <i class="fas fa-file-invoice"></i> Órdenes de Compra
              </h6>
            </div>
            <div class="card-body">
              <% if (ordenes != null && !ordenes.isEmpty()) { 
                   SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                   DecimalFormat dfPrecio = new DecimalFormat("#,##0.00");
              %>
                <div class="table-responsive">
                  <table class="table table-bordered table-hover" id="tablaOrdenes">
                    <thead style="background-color: #cc3333; color: white;">
                      <tr>
                        <th>N° Orden</th>
                        <th>Fecha</th>
                        <th>Proveedor</th>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>P. Unitario</th>
                        <th>Total</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                      </tr>
                    </thead>
                    <tbody>
                      <% for (OrdenVenta o : ordenes) { %>
                        <tr data-estado="<%= o.getEstado() %>">
                          <td><strong><%= o.getNumeroOrden() %></strong></td>
                          <td><%= sdf.format(o.getFechaOrden()) %></td>
                          <td><%= o.getNombreProveedor() != null ? o.getNombreProveedor() : "Proveedor #" + o.getIdProveedor() %></td>
                          <td><%= o.getNombreProducto() != null ? o.getNombreProducto() : "Producto #" + o.getIdProducto() %></td>
                          <td><%= o.getCantidadSolicitada() %></td>
                          <td>S/ <%= dfPrecio.format(o.getPrecioUnitario()) %></td>
                          <td><strong>S/ <%= dfPrecio.format(o.getTotal()) %></strong></td>
                          <td>
                            <% String estado = o.getEstado(); %>
                            <% if ("PENDIENTE".equals(estado)) { %>
                              <span class="badge badge-pendiente">PENDIENTE</span>
                            <% } else if ("APROBADA".equals(estado)) { %>
                              <span class="badge badge-aprobada">APROBADA</span>
                            <% } else if ("ENVIADA".equals(estado)) { %>
                              <span class="badge badge-enviada">ENVIADA</span>
                            <% } else if ("RECIBIDA".equals(estado)) { %>
                              <span class="badge badge-recibida">RECIBIDA</span>
                            <% } else if ("CANCELADA".equals(estado)) { %>
                              <span class="badge badge-cancelada">CANCELADA</span>
                            <% } %>
                          </td>
                          <td>
                            <button class="btn btn-sm btn-info btn-ver" 
                                    data-id="<%= o.getIdOrdenVenta() %>"
                                    data-numero="<%= o.getNumeroOrden() %>"
                                    data-proveedor="<%= o.getNombreProveedor() != null ? o.getNombreProveedor() : "" %>"
                                    data-producto="<%= o.getNombreProducto() != null ? o.getNombreProducto() : "" %>"
                                    data-cantidad="<%= o.getCantidadSolicitada() %>"
                                    data-precio="<%= o.getPrecioUnitario() %>"
                                    data-total="<%= o.getTotal() %>"
                                    data-estado="<%= o.getEstado() %>"
                                    data-fecha="<%= sdf.format(o.getFechaOrden()) %>"
                                    data-observaciones="<%= o.getObservaciones() != null ? o.getObservaciones() : "" %>">
                              <i class="fas fa-eye"></i>
                            </button>
                            <% if (!"RECIBIDA".equals(estado) && !"CANCELADA".equals(estado)) { %>
                              <button class="btn btn-sm btn-radiadores ml-1 btn-cambiar-estado" 
                                      data-id="<%= o.getIdOrdenVenta() %>" 
                                      data-estado="<%= estado %>"
                                      data-numero="<%= o.getNumeroOrden() %>">
                                <i class="fas fa-edit"></i>
                              </button>
                            <% } %>
                          </td>
                        </tr>
                      <% } %>
                    </tbody>
                  </table>
                </div>
              <% } else { %>
                <div class="text-center text-muted py-5">
                  <i class="fas fa-file-invoice fa-3x mb-3"></i>
                  <h4>No hay órdenes de compra registradas</h4>
                  <p>Comience creando órdenes para gestionar sus compras.</p>
                  <button class="btn btn-radiadores" data-toggle="modal" data-target="#modalCrearOrden">
                    <i class="fas fa-plus"></i> Crear Primera Orden
                  </button>
                </div>
              <% } %>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>

  <!-- Modal Crear Orden -->
  <div class="modal fade" id="modalCrearOrden" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-plus"></i> Nueva Orden de Compra</h5>
          <button type="button" class="close text-white" data-dismiss="modal">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <form action="orden_controller.jsp" method="post" id="formOrden">
          <input type="hidden" name="accion" value="crear">
          <div class="modal-body">
            <div class="row">
              <div class="col-md-6">
                <h6 class="mb-3" style="color: #cc3333;"><i class="fas fa-user"></i> Información del Proveedor</h6>
                
                <div class="form-group">
                  <label for="selectProveedor">Seleccionar Proveedor *</label>
                  <select name="idProveedor" id="selectProveedor" class="form-control" required>
                    <option value="">Seleccionar proveedor...</option>
                    <% if (proveedoresActivos != null) { %>
                      <% for (Proveedor prov : proveedoresActivos) { %>
                        <option value="<%= prov.getIdProveedor() %>" 
                                data-nombre="<%= prov.getNombre() %>"
                                data-ruc="<%= prov.getRuc() != null ? prov.getRuc() : "" %>"
                                data-contacto="<%= prov.getContacto() != null ? prov.getContacto() : "" %>"
                                data-telefono="<%= prov.getTelefono() != null ? prov.getTelefono() : "" %>">
                          <%= prov.getNombre() %> <% if (prov.getRuc() != null && !prov.getRuc().isEmpty()) { %>- RUC: <%= prov.getRuc() %><% } %>
                        </option>
                      <% } %>
                    <% } %>
                  </select>
                </div>
                
                <div id="proveedorInfo" class="proveedor-info" style="display: none;">
                  <div class="alert alert-info">
                    <div class="row">
                      <div class="col-12">
                        <strong>RUC:</strong> <span id="proveedorRuc">-</span><br>
                        <strong>Contacto:</strong> <span id="proveedorContacto">-</span><br>
                        <strong>Teléfono:</strong> <span id="proveedorTelefono">-</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-6">
                <h6 class="mb-3" style="color: #cc3333;"><i class="fas fa-box"></i> Información del Producto</h6>
                
                <div class="form-group">
                  <label for="nombreProducto">Producto a Solicitar *</label>
                  <select name="idProducto" id="nombreProducto" class="form-control" required>
                    <option value="">Seleccionar producto...</option>
                    <% if (productos != null) { %>
                      <% for (Producto p : productos) { %>
                        <option value="<%= p.getId() %>" data-nombre="<%= p.getNombre() %>" data-precio="<%= p.getPrecio() %>">
                          <%= p.getNombre() %> - <%= p.getModelo() %> (<%= p.getTipo() %>)
                        </option>
                      <% } %>
                    <% } %>
                  </select>
                </div>
                
                <div class="row">
                  <div class="col-md-6">
                    <div class="form-group">
                      <label for="cantidadSolicitada">Cantidad *</label>
                      <input type="number" name="cantidadSolicitada" id="cantidadSolicitada" class="form-control" min="1" required>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label for="precioUnitario">Precio Unitario (S/) *</label>
                      <input type="number" name="precioUnitario" id="precioUnitario" class="form-control" 
                             step="0.01" min="0.01" required>
                    </div>
                  </div>
                </div>
                
                <div class="form-group">
                  <label for="totalOrden">Total de la Orden (S/)</label>
                  <input type="text" id="totalOrden" class="form-control font-weight-bold" readonly>
                </div>
              </div>
            </div>
            
            <hr>
            
            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label for="fechaEntrega">Fecha de Entrega Esperada</label>
                  <input type="date" name="fechaEntrega" id="fechaEntrega" class="form-control">
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group">
                  <label for="observaciones">Observaciones</label>
                  <textarea name="observaciones" id="observaciones" class="form-control" rows="3"
                            placeholder="Observaciones adicionales..."></textarea>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-radiadores">
              <i class="fas fa-save"></i> Crear Orden
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal Ver Orden -->
  <div class="modal fade" id="modalVerOrden" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-eye"></i> Detalles de la Orden</h5>
          <button type="button" class="close text-white" data-dismiss="modal">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-md-6">
              <h6 style="color: #cc3333;"><i class="fas fa-info-circle"></i> Información General</h6>
              <table class="table table-borderless">
                <tr><td><strong>Número:</strong></td><td id="verNumero">-</td></tr>
                <tr><td><strong>Fecha:</strong></td><td id="verFecha">-</td></tr>
                <tr><td><strong>Estado:</strong></td><td id="verEstado">-</td></tr>
                <tr><td><strong>Proveedor:</strong></td><td id="verProveedor">-</td></tr>
              </table>
            </div>
            <div class="col-md-6">
              <h6 style="color: #cc3333;"><i class="fas fa-box"></i> Detalles del Producto</h6>
              <table class="table table-borderless">
                <tr><td><strong>Producto:</strong></td><td id="verProducto">-</td></tr>
                <tr><td><strong>Cantidad:</strong></td><td id="verCantidad">-</td></tr>
                <tr><td><strong>P. Unitario:</strong></td><td id="verPrecio">-</td></tr>
                <tr><td><strong>Total:</strong></td><td id="verTotal">-</td></tr>
              </table>
            </div>
          </div>
          <div class="row">
            <div class="col-12">
              <h6 style="color: #cc3333;"><i class="fas fa-comment"></i> Observaciones</h6>
              <p id="verObservaciones" class="text-muted">-</p>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal Cambiar Estado -->
  <div class="modal fade" id="modalCambiarEstado" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit"></i> Cambiar Estado</h5>
          <button type="button" class="close text-white" data-dismiss="modal">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <form action="orden_controller.jsp" method="post">
          <input type="hidden" name="accion" value="cambiarEstado">
          <input type="hidden" name="idOrden" id="cambiarIdOrden">
          <div class="modal-body">
            <p>Cambiar estado de la orden <strong id="cambiarNumeroOrden">-</strong>:</p>
            <div class="form-group">
              <label for="nuevoEstado">Nuevo Estado</label>
              <select name="nuevoEstado" id="nuevoEstado" class="form-control" required>
                <option value="PENDIENTE">PENDIENTE</option>
                <option value="APROBADA">APROBADA</option>
                <option value="RECIBIDA">RECIBIDA</option>
                <option value="CANCELADA">CANCELADA</option>
              </select>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-radiadores">
              <i class="fas fa-save"></i> Cambiar Estado
            </button>
          </div>
        </form>
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

      // Cambio de proveedor
      $("#selectProveedor").change(function() {
        const option = $(this).find('option:selected');
        const idProveedor = $(this).val();
        
        if (idProveedor) {
          $("#proveedorRuc").text(option.data('ruc') || "-");
          $("#proveedorContacto").text(option.data('contacto') || "-");
          $("#proveedorTelefono").text(option.data('telefono') || "-");
          $("#proveedorInfo").show();
        } else {
          $("#proveedorInfo").hide();
        }
      });

      // Cambio de producto
      $("#nombreProducto").change(function() {
        const option = $(this).find('option:selected');
        const precio = option.data('precio');
        const idProducto = $(this).val();
        
        if (idProducto && precio) {
          $("#precioUnitario").val(precio.toFixed(2));
          calcularTotal();
        } else {
          $("#precioUnitario").val('');
          $("#totalOrden").val('');
        }
      });

      // Calcular total automáticamente
      $("#cantidadSolicitada, #precioUnitario").on('input', function() {
        calcularTotal();
      });

      // Event listeners para botones
      $(document).on('click', '.btn-ver', function() {
        mostrarDetallesOrden($(this));
      });

      $(document).on('click', '.btn-cambiar-estado', function() {
        const id = $(this).data('id');
        const numero = $(this).data('numero');
        const estadoActual = $(this).data('estado');
        
        $("#cambiarIdOrden").val(id);
        $("#cambiarNumeroOrden").text(numero);
        $("#nuevoEstado").val(estadoActual);
        
        $("#modalCambiarEstado").modal('show');
      });
    });



    function calcularTotal() {
      const cantidad = parseFloat($("#cantidadSolicitada").val()) || 0;
      const precio = parseFloat($("#precioUnitario").val()) || 0;
      const total = cantidad * precio;
      $("#totalOrden").val('S/ ' + total.toFixed(2));
    }

    function mostrarDetallesOrden(button) {
      $("#verNumero").text(button.data('numero'));
      $("#verFecha").text(button.data('fecha'));
      $("#verEstado").html('<span class="badge badge-' + button.data('estado').toLowerCase() + '">' + button.data('estado') + '</span>');
      $("#verProveedor").text(button.data('proveedor'));
      $("#verProducto").text(button.data('producto'));
      $("#verCantidad").text(button.data('cantidad'));
      $("#verPrecio").text('S/ ' + parseFloat(button.data('precio')).toFixed(2));
      $("#verTotal").text('S/ ' + parseFloat(button.data('total')).toFixed(2));
      $("#verObservaciones").text(button.data('observaciones') || 'Sin observaciones');
      
      $("#modalVerOrden").modal('show');
    }

    function toggleBusqueda() {
      $("#busquedaSection").toggle();
      if ($("#busquedaSection").is(':visible')) {
        $("#buscarOrden").focus();
      }
    }

    function buscarOrden() {
      const termino = $("#buscarOrden").val().toLowerCase();
      const filas = $("#tablaOrdenes tbody tr");
      
      filas.each(function() {
        const fila = $(this);
        const texto = fila.text().toLowerCase();
        
        if (texto.includes(termino)) {
          fila.show();
        } else {
          fila.hide();
        }
      });
    }

    function filtrarOrdenes(estado) {
      const filas = $("#tablaOrdenes tbody tr");
      
      if (estado === 'TODOS') {
        filas.show();
      } else {
        filas.each(function() {
          const fila = $(this);
          const estadoFila = fila.data('estado');
          
          if (estadoFila === estado) {
            fila.show();
          } else {
            fila.hide();
          }
        });
      }
    }

    // Búsqueda en tiempo real
    $("#buscarOrden").on('input', function() {
      buscarOrden();
    });

    // Validación del formulario
    $("#formOrden").submit(function(e) {
      const idProveedor = $("#selectProveedor").val();
      const idProducto = $("#nombreProducto").val();
      const cantidad = $("#cantidadSolicitada").val();
      const precio = $("#precioUnitario").val();
      
      if (!idProveedor || idProveedor === '') {
        e.preventDefault();
        alert('Por favor, seleccione un proveedor válido.');
        $("#selectProveedor").focus();
        return false;
      }
      
      if (!idProducto || idProducto === '') {
        e.preventDefault();
        alert('Por favor, seleccione un producto.');
        $("#nombreProducto").focus();
        return false;
      }
      
      if (!cantidad || cantidad <= 0) {
        e.preventDefault();
        alert('Por favor, ingrese una cantidad válida.');
        $("#cantidadSolicitada").focus();
        return false;
      }
      
      if (!precio || precio <= 0) {
        e.preventDefault();
        alert('Por favor, ingrese un precio válido.');
        $("#precioUnitario").focus();
        return false;
      }
      
      // Debug: mostrar valores antes de enviar
      console.log('Enviando orden:', {
        idProveedor: idProveedor,
        idProducto: idProducto,
        cantidad: cantidad,
        precio: precio
      });
    });
  </script>
</body>
</html>
