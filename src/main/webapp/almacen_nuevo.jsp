<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Producto" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Gestor de Almacén - Radiadores Fortaleza</title>
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
      <li class="nav-item active">
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
            <div class="col-md-3">
              <div class="card card-stats">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h6 class="text-uppercase mb-0">Total Productos</h6>
                      <span class="h2 font-weight-bold mb-0">
                        <% 
                          List<Producto> productos = (List<Producto>) request.getAttribute("listaProductos");
                          int totalProductos = productos != null ? productos.size() : 0;
                          out.print(totalProductos);
                        %>
                      </span>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-boxes fa-2x"></i>
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
                      <h6 class="text-uppercase mb-0">Total Stock</h6>
                      <span class="h2 font-weight-bold mb-0">
                        <% 
                          int stockTotal = 0;
                          if (productos != null) {
                            for (Producto p : productos) {
                              stockTotal += p.getCantidad();
                            }
                          }
                          out.print(stockTotal);
                        %>
                      </span>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-cubes fa-2x"></i>
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
                          if (productos != null) {
                            for (Producto p : productos) {
                              valorTotal += p.getPrecio() * p.getCantidad();
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
                      <h6 class="text-uppercase mb-0">Stock Bajo</h6>
                      <span class="h2 font-weight-bold mb-0">
                        <% 
                          int stockBajo = 0;
                          if (productos != null) {
                            for (Producto p : productos) {
                              if (p.getCantidad() <= 5) stockBajo++;
                            }
                          }
                          out.print(stockBajo);
                        %>
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
                      <button class="btn btn-radiadores btn-block" data-toggle="modal" data-target="#modalAgregar">
                        <i class="fas fa-plus fa-2x mb-2"></i><br>
                        Agregar Producto
                      </button>
                    </div>
                    <div class="col-md-3 mb-2">
                      <button class="btn btn-info btn-block" onclick="toggleBusqueda()">
                        <i class="fas fa-search fa-2x mb-2"></i><br>
                        Buscar Producto
                      </button>
                    </div>
                    <div class="col-md-3 mb-2">
                      <a href="stock_bajo.jsp" class="btn btn-warning btn-block">
                        <i class="fas fa-exclamation-triangle fa-2x mb-2"></i><br>
                        Stock Bajo
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Búsqueda -->
          <div id="busquedaSection" class="search-box" style="display: none;">
            <h5 style="color: #cc3333;" class="mb-3"><i class="fas fa-search"></i> Buscar Producto</h5>
            <form action="AlmacenServlet" method="post">
              <input type="hidden" name="accion" value="Buscar">
              <div class="row">
                <div class="col-md-8">
                  <input type="text" name="nombre" class="form-control" placeholder="Nombre del producto..." required>
                </div>
                <div class="col-md-4">
                  <button type="submit" class="btn btn-radiadores btn-block">
                    <i class="fas fa-search"></i> Buscar
                  </button>
                </div>
              </div>
            </form>
          </div>

          <!-- Resultado de Búsqueda -->
          <% 
            Producto producto = (Producto) request.getAttribute("producto");
            if (producto != null) { 
              DecimalFormat dfBusqueda = new DecimalFormat("#,##0.00");
          %>
            <div class="card shadow mb-4">
              <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold" style="color: #cc3333;">
                  <i class="fas fa-search"></i> Resultado de Búsqueda
                </h6>
              </div>
              <div class="card-body">
                <div class="row">
                  <div class="col-md-8">
                    <h5 style="color: #cc3333;"><%= producto.getNombre() %></h5>
                    <p><strong>Modelo:</strong> <%= producto.getModelo() %></p>
                    <p><strong>Tipo:</strong> 
                      <% if ("Aluminio".equalsIgnoreCase(producto.getTipo())) { %>
                        <span class="badge badge-secondary"><%= producto.getTipo() %></span>
                      <% } else if ("Bronce".equalsIgnoreCase(producto.getTipo())) { %>
                        <span class="badge badge-warning"><%= producto.getTipo() %></span>
                      <% } else { %>
                        <span class="badge badge-info"><%= producto.getTipo() %></span>
                      <% } %>
                    </p>
                    <p><strong>Precio:</strong> S/ <%= dfBusqueda.format(producto.getPrecio()) %></p>
                    <p><strong>Stock:</strong> 
                      <% if (producto.getCantidad() <= 2) { %>
                        <span class="badge badge-danger"><%= producto.getCantidad() %> unidades</span>
                      <% } else if (producto.getCantidad() <= 5) { %>
                        <span class="badge badge-warning"><%= producto.getCantidad() %> unidades</span>
                      <% } else { %>
                        <span class="badge badge-success"><%= producto.getCantidad() %> unidades</span>
                      <% } %>
                    </p>
                  </div>
                  <div class="col-md-4 text-center">
                    <button class="btn btn-radiadores btn-block mb-2 btn-editar" 
                            data-id="<%= producto.getId() %>" 
                            data-nombre="<%= producto.getNombre() %>" 
                            data-modelo="<%= producto.getModelo() %>" 
                            data-tipo="<%= producto.getTipo() %>" 
                            data-precio="<%= producto.getPrecio() %>" 
                            data-cantidad="<%= producto.getCantidad() %>">
                      <i class="fas fa-edit"></i> Editar
                    </button>
                    <button class="btn btn-danger btn-block btn-eliminar" data-nombre="<%= producto.getNombre() %>">
                      <i class="fas fa-trash"></i> Eliminar
                    </button>
                  </div>
                </div>
              </div>
            </div>
          <% } %>

          <!-- Lista de Productos -->
          <div class="card shadow">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold" style="color: #cc3333;">
                <i class="fas fa-boxes"></i> Inventario de Productos
              </h6>
            </div>
            <div class="card-body">
              <% if (productos != null && !productos.isEmpty()) { 
                   DecimalFormat dfPrecio = new DecimalFormat("#,##0.00");
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
                        <th>Acciones</th>
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
                          <td>S/ <%= dfPrecio.format(p.getPrecio()) %></td>
                          <td>
                            <% if (p.getCantidad() <= 2) { %>
                              <span class="badge badge-danger"><%= p.getCantidad() %> unidades</span>
                            <% } else if (p.getCantidad() <= 5) { %>
                              <span class="badge badge-warning"><%= p.getCantidad() %> unidades</span>
                            <% } else { %>
                              <span class="badge badge-success"><%= p.getCantidad() %> unidades</span>
                            <% } %>
                          </td>
                          <td>
                            <button class="btn btn-sm btn-radiadores btn-editar" 
                                    data-id="<%= p.getId() %>" 
                                    data-nombre="<%= p.getNombre() %>" 
                                    data-modelo="<%= p.getModelo() %>" 
                                    data-tipo="<%= p.getTipo() %>" 
                                    data-precio="<%= p.getPrecio() %>" 
                                    data-cantidad="<%= p.getCantidad() %>">
                              <i class="fas fa-edit"></i> Editar
                            </button>
                            <button class="btn btn-sm btn-danger ml-1 btn-eliminar" data-nombre="<%= p.getNombre() %>">
                              <i class="fas fa-trash"></i> Eliminar
                            </button>
                          </td>
                        </tr>
                      <% } %>
                    </tbody>
                  </table>
                </div>
              <% } else { %>
                <div class="text-center text-muted py-5">
                  <i class="fas fa-boxes fa-3x mb-3"></i>
                  <h4>No hay productos en el almacén</h4>
                  <p>Comience agregando productos para gestionar su inventario.</p>
                  <button class="btn btn-radiadores" data-toggle="modal" data-target="#modalAgregar">
                    <i class="fas fa-plus"></i> Agregar Primer Producto
                  </button>
                </div>
              <% } %>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>

  <!-- Modal Agregar Producto -->
  <div class="modal fade" id="modalAgregar" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-plus"></i> Agregar Nuevo Producto</h5>
          <button type="button" class="close text-white" data-dismiss="modal">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <form action="AlmacenServlet" method="post">
          <input type="hidden" name="accion" value="Agregar">
          <div class="modal-body">
            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label for="nombre">Nombre del Producto *</label>
                  <input type="text" name="nombre" id="nombre" class="form-control" required>
                </div>
                <div class="form-group">
                  <label for="modelo">Modelo *</label>
                  <input type="text" name="modelo" id="modelo" class="form-control" required>
                </div>
                <div class="form-group">
                  <label for="tipo">Tipo *</label>
                  <select name="tipo" id="tipo" class="form-control" required>
                    <option value="">Seleccionar tipo...</option>
                    <option value="Aluminio">Aluminio</option>
                    <option value="Bronce">Bronce</option>
                    
                  </select>
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group">
                  <label for="precio">Precio (S/) *</label>
                  <input type="number" name="precio" id="precio" class="form-control" step="0.01" min="0" required>
                </div>
                <div class="form-group">
                  <label for="cantidad">Cantidad Inicial *</label>
                  <input type="number" name="cantidad" id="cantidad" class="form-control" min="0" required>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-radiadores">
              <i class="fas fa-save"></i> Guardar Producto
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal Editar Producto -->
  <div class="modal fade" id="modalEditar" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit"></i> Editar Producto</h5>
          <button type="button" class="close text-white" data-dismiss="modal">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <form action="AlmacenServlet" method="post">
          <input type="hidden" name="accion" value="ModificarPorId">
          <input type="hidden" name="idProducto" id="editarIdProducto">
          <div class="modal-body">
            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label for="editarNombre">Nombre del Producto *</label>
                  <input type="text" name="nombre" id="editarNombre" class="form-control" required>
                </div>
                <div class="form-group">
                  <label for="editarModelo">Modelo *</label>
                  <input type="text" name="modelo" id="editarModelo" class="form-control" required>
                </div>
                <div class="form-group">
                  <label for="editarTipo">Tipo *</label>
                  <select name="tipo" id="editarTipo" class="form-control" required>
                    <option value="Aluminio">Aluminio</option>
                    <option value="Bronce">Bronce</option>
                    <option value="Cobre">Cobre</option>
                    <option value="Mixto">Mixto</option>
                  </select>
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group">
                  <label for="editarPrecio">Precio (S/) *</label>
                  <input type="number" name="precio" id="editarPrecio" class="form-control" step="0.01" min="0" required>
                </div>
                <div class="form-group">
                  <label for="editarCantidad">Cantidad *</label>
                  <input type="number" name="cantidad" id="editarCantidad" class="form-control" min="0" required>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-radiadores">
              <i class="fas fa-save"></i> Actualizar Producto
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
        const modelo = $(this).data('modelo');
        const tipo = $(this).data('tipo');
        const precio = $(this).data('precio');
        const cantidad = $(this).data('cantidad');
        
        editarProductoConDatos(id, nombre, modelo, tipo, precio, cantidad);
      });

      // Event listener para botones de eliminar
      $(document).on('click', '.btn-eliminar', function() {
        const nombre = $(this).data('nombre');
        eliminarProducto(nombre);
      });
    });

    function toggleBusqueda() {
      $("#busquedaSection").toggle();
    }

    function editarProducto(id) {
      $("#editarIdProducto").val(id);
      $("#modalEditar").modal('show');
    }

    function editarProductoConDatos(id, nombre, modelo, tipo, precio, cantidad) {
      $("#editarIdProducto").val(id);
      $("#editarNombre").val(nombre);
      $("#editarModelo").val(modelo);
      $("#editarTipo").val(tipo);
      $("#editarPrecio").val(precio);
      $("#editarCantidad").val(cantidad);
      $("#modalEditar").modal('show');
    }

    function eliminarProducto(nombre) {
      if (confirm('¿Está seguro de que desea eliminar el producto "' + nombre + '"?')) {
        const form = document.createElement('form');
        form.method = 'post';
        form.action = 'AlmacenServlet';
        
        const accionInput = document.createElement('input');
        accionInput.type = 'hidden';
        accionInput.name = 'accion';
        accionInput.value = 'Eliminar';
        
        const nombreInput = document.createElement('input');
        nombreInput.type = 'hidden';
        nombreInput.name = 'nombre';
        nombreInput.value = nombre;
        
        form.appendChild(accionInput);
        form.appendChild(nombreInput);
        document.body.appendChild(form);
        form.submit();
      }
    }
  </script>
</body>
</html>