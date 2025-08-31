<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Proveedor" %>
<%@ page import="modelo.dao.ProveedorDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Obtener proveedores desde el servlet (si están disponibles) o cargar directamente
  List<Proveedor> proveedores = (List<Proveedor>) request.getAttribute("proveedores");
  if (proveedores == null) {
    // Si no vienen del servlet, cargar directamente (primera carga de la página)
    ProveedorDAO proveedorDAO = new ProveedorDAO();
    proveedores = proveedorDAO.obtenerProveedores();
  }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestión de Proveedores - Radiadores Fortaleza</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link href="estilos/estiloscontrol.css" rel="stylesheet">
  <style>
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
    .badge-activo {
      background-color: #28a745;
    }
    .badge-inactivo {
      background-color: #dc3545;
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
            <a class="collapse-item active" href="gestionar_proveedores.jsp">Gestionar Proveedores</a>
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
                    <div class="col-md-6 mb-2">
                      <button class="btn btn-radiadores btn-block" data-toggle="modal" data-target="#modalAgregarProveedor">
                        <i class="fas fa-plus fa-2x mb-2"></i><br>
                        Agregar Proveedor
                      </button>
                    </div>
                    <div class="col-md-6 mb-2">
                      <a href="ordenes_venta.jsp" class="btn btn-warning btn-block">
                        <i class="fas fa-shopping-cart fa-2x mb-2"></i><br>
                        Órdenes de Compra
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>



          <!-- Lista de Proveedores -->
          <div class="card shadow">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold" style="color: #cc3333;">
                <i class="fas fa-users"></i> Lista de Proveedores
              </h6>
            </div>
            <div class="card-body">
              <% if (proveedores != null && !proveedores.isEmpty()) { %>
                <div class="table-responsive">
                  <table class="table table-bordered table-hover" id="tablaProveedores">
                    <thead style="background-color: #cc3333; color: white;">
                      <tr>
                        <th>Nombre</th>
                        <th>RUC</th>
                        <th>Razón Social</th>
                        <th>Teléfono</th>
                        <th>Email</th>
                        <th>Acciones</th>
                      </tr>
                    </thead>
                    <tbody>
                      <% for (Proveedor p : proveedores) { %>
                        <tr data-estado="<%= p.getEstado() %>">
                          <td><strong><%= p.getNombre() %></strong></td>
                          <td><%= p.getRuc() != null ? p.getRuc() : "-" %></td>
                          <td><%= p.getRazonSocial() != null ? p.getRazonSocial() : "-" %></td>
                          <td><%= p.getTelefono() != null ? p.getTelefono() : "-" %></td>
                          <td><%= p.getEmail() != null ? p.getEmail() : "-" %></td>
                          <td>
                            <button class="btn btn-sm btn-radiadores btn-editar" 
                                    data-id="<%= p.getIdProveedor() %>" 
                                    data-nombre="<%= p.getNombre() %>" 
                                    data-ruc="<%= p.getRuc() != null ? p.getRuc() : "" %>" 
                                    data-razon="<%= p.getRazonSocial() != null ? p.getRazonSocial() : "" %>" 
                                    data-telefono="<%= p.getTelefono() != null ? p.getTelefono() : "" %>" 
                                    data-email="<%= p.getEmail() != null ? p.getEmail() : "" %>" 
                                    data-direccion="<%= p.getDireccion() != null ? p.getDireccion() : "" %>" 
                                    data-contacto="<%= p.getContacto() != null ? p.getContacto() : "" %>" 
                                    data-estado="<%= p.getEstado() %>">
                              <i class="fas fa-edit"></i> Editar
                            </button>
                          </td>
                        </tr>
                      <% } %>
                    </tbody>
                  </table>
                </div>
              <% } else { %>
                <div class="text-center text-muted py-5">
                  <i class="fas fa-users fa-3x mb-3"></i>
                  <h4>No hay proveedores registrados</h4>
                  <p>Comience agregando proveedores para gestionar sus compras.</p>
                  <button class="btn btn-radiadores" data-toggle="modal" data-target="#modalAgregarProveedor">
                    <i class="fas fa-plus"></i> Agregar Primer Proveedor
                  </button>
                </div>
              <% } %>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>

  <!-- Modal Agregar Proveedor -->
  <div class="modal fade" id="modalAgregarProveedor" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-plus"></i> Agregar Nuevo Proveedor</h5>
          <button type="button" class="close text-white" data-dismiss="modal">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <form action="proveedor_simple.jsp" method="post">
          <input type="hidden" name="accion" value="agregar">
          <div class="modal-body">
            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label for="nombre">Nombre del Proveedor *</label>
                  <input type="text" name="nombre" id="nombre" class="form-control" required>
                </div>
                <div class="form-group">
                  <label for="ruc">RUC</label>
                  <input type="text" name="ruc" id="ruc" class="form-control" maxlength="11">
                </div>
                <div class="form-group">
                  <label for="razonSocial">Razón Social</label>
                  <input type="text" name="razonSocial" id="razonSocial" class="form-control">
                </div>
                <div class="form-group">
                  <label for="telefono">Teléfono</label>
                  <input type="text" name="telefono" id="telefono" class="form-control">
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group">
                  <label for="email">Email</label>
                  <input type="email" name="email" id="email" class="form-control">
                </div>
                <div class="form-group">
                  <label for="direccion">Dirección</label>
                  <textarea name="direccion" id="direccion" class="form-control" rows="3"></textarea>
                </div>
                <div class="form-group">
                  <label for="contacto">Persona de Contacto</label>
                  <input type="text" name="contacto" id="contacto" class="form-control">
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-radiadores">
              <i class="fas fa-save"></i> Guardar Proveedor
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal Editar Proveedor -->
  <div class="modal fade" id="modalEditarProveedor" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit"></i> Editar Proveedor</h5>
          <button type="button" class="close text-white" data-dismiss="modal">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <form action="proveedor_simple.jsp" method="post">
          <input type="hidden" name="accion" value="editar">
          <input type="hidden" name="idProveedor" id="editarIdProveedor">
          <div class="modal-body">
            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label for="editarNombre">Nombre del Proveedor *</label>
                  <input type="text" name="nombre" id="editarNombre" class="form-control" required>
                </div>
                <div class="form-group">
                  <label for="editarRuc">RUC</label>
                  <input type="text" name="ruc" id="editarRuc" class="form-control" maxlength="11">
                </div>
                <div class="form-group">
                  <label for="editarRazonSocial">Razón Social</label>
                  <input type="text" name="razonSocial" id="editarRazonSocial" class="form-control">
                </div>
                <div class="form-group">
                  <label for="editarTelefono">Teléfono</label>
                  <input type="text" name="telefono" id="editarTelefono" class="form-control">
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group">
                  <label for="editarEmail">Email</label>
                  <input type="email" name="email" id="editarEmail" class="form-control">
                </div>
                <div class="form-group">
                  <label for="editarDireccion">Dirección</label>
                  <textarea name="direccion" id="editarDireccion" class="form-control" rows="3"></textarea>
                </div>
                <div class="form-group">
                  <label for="editarContacto">Persona de Contacto</label>
                  <input type="text" name="contacto" id="editarContacto" class="form-control">
                </div>

              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-radiadores">
              <i class="fas fa-save"></i> Actualizar Proveedor
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

      // Event listener para botones de editar
      $(document).on('click', '.btn-editar', function() {
        const id = $(this).data('id');
        const nombre = $(this).data('nombre');
        const ruc = $(this).data('ruc');
        const razon = $(this).data('razon');
        const telefono = $(this).data('telefono');
        const email = $(this).data('email');
        const direccion = $(this).data('direccion');
        const contacto = $(this).data('contacto');
        
        $("#editarIdProveedor").val(id);
        $("#editarNombre").val(nombre);
        $("#editarRuc").val(ruc);
        $("#editarRazonSocial").val(razon);
        $("#editarTelefono").val(telefono);
        $("#editarEmail").val(email);
        $("#editarDireccion").val(direccion);
        $("#editarContacto").val(contacto);
        
        $("#modalEditarProveedor").modal('show');
      });


    });








  </script>
</body>
</html>
