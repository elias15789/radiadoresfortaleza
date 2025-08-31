<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Producto" %>
<%@ page import="modelo.Venta" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Sistema de Ventas - Radiadores Fortaleza</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <link href="estilos/estiloscontrol.css" rel="stylesheet">
  <style>
    .card-stats {
      background: linear-gradient(45deg, #cc3333, #b52d3a);
      color: white;
    }
    .card-stats .card-body {
      padding: 1rem;
    }
    .stats-number {
      font-size: 1.5rem;
      font-weight: bold;
    }
    .producto-info {
      background-color: #f8f9fa;
      border: 1px solid #dee2e6;
      border-radius: 0.25rem;
      padding: 0.75rem;
      margin-top: 0.5rem;
      display: none;
    }
    .table-ventas {
      font-size: 0.875rem;
    }
    .badge-stock-alto { background-color: #28a745; }
    .badge-stock-medio { background-color: #ffc107; }
    .badge-stock-bajo { background-color: #cc3333; }
    .search-box {
      background-color: #f8f9fa;
      border-radius: 0.5rem;
      padding: 1rem;
      margin-bottom: 1rem;
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
          <span>Panel de Control</span></a>
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
      
      <% boolean puedeVentas = true; try { String r = (String) session.getAttribute("rolUsuario"); puedeVentas = (r == null) || "ADMIN".equals(r) || "VENTAS".equals(r) || "VENDEDOR".equals(r) || "ASESOR".equals(r) || "ASESOR_VENTAS".equals(r); } catch(Exception e) { puedeVentas = true; } %>
      <% if (puedeVentas) { %>
      <li class="nav-item active">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseVentas" aria-expanded="true"
          aria-controls="collapseVentas">
          <i class="fas fa-shopping-cart"></i>
          <span>Ventas</span>
        </a>
        <div id="collapseVentas" class="collapse show" aria-labelledby="headingVentas" data-parent="#accordionSidebar">
          <div class="bg-white py-2 collapse-inner rounded">
            <h6 class="collapse-header">Gestión de Ventas</h6>
            <a class="collapse-item active" href="VentaServlet">Registrar Venta</a>
            <a class="collapse-item" href="VentaServlet?accion=listar">Ver Todas las Ventas</a>
            <a class="collapse-item" href="VentaServlet?accion=reporteDiario">Reporte Diario</a>
          </div>
        </div>
      </li>
      <% } %>

      <% boolean puedeProveedores = true; try { String r = (String) session.getAttribute("rolUsuario"); puedeProveedores = (r == null) || "ADMIN".equals(r); } catch(Exception e) { puedeProveedores = true; } %>
      <% if (puedeProveedores) { %>
      <li class="nav-item">
        <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseControlCompras" aria-expanded="true"
          aria-controls="collapseControlCompras">
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
                      <h6 class="text-uppercase mb-0">Ventas Hoy</h6>
                      <span class="stats-number">S/ 
                        <% 
                          DecimalFormat df = new DecimalFormat("#,##0.00");
                          Double totalHoy = (Double) request.getAttribute("totalVentasHoy");
                          if (totalHoy != null) {
                            out.print(df.format(totalHoy));
                          } else {
                            out.print("0.00");
                          }
                        %>
                      </span>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-calendar-day fa-2x"></i>
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
                      <h6 class="text-uppercase mb-0">Ventas Este Mes</h6>
                      <span class="stats-number">S/ 
                        <% 
                          Double totalMes = (Double) request.getAttribute("totalVentasMes");
                          if (totalMes != null) {
                            out.print(df.format(totalMes));
                          } else {
                            out.print("0.00");
                          }
                        %>
                      </span>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-calendar-alt fa-2x"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Alertas -->
          <% if (request.getAttribute("exito") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
              <i class="fas fa-check-circle"></i> <%= request.getAttribute("exito") %>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
          <% } %>
          
          <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <i class="fas fa-exclamation-triangle"></i> <%= request.getAttribute("error") %>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
          <% } %>

          <!-- Formulario de Registro de Venta -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold" style="color: #cc3333;">
                <i class="fas fa-plus-circle"></i> Registrar Nueva Venta
              </h6>
            </div>
            <div class="card-body">
              <form action="VentaServlet" method="post" id="formVenta">
                <input type="hidden" name="accion" value="registrar">
                <input type="hidden" name="idProducto" id="idProducto">
                
                <div class="row">
                  <!-- Información del Cliente -->
                  <div class="col-md-6">
                    <h6 class="mb-3" style="color: #cc3333;"><i class="fas fa-user"></i> Datos del Cliente</h6>
                    
                    <div class="form-group">
                      <label for="nombreCliente">Nombre del Cliente <span class="text-danger">*</span></label>
                      <input type="text" name="nombreCliente" id="nombreCliente" class="form-control" required>
                    </div>
                    
                    <div class="row">
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="tipoDocumento">Tipo de Documento</label>
                          <select name="tipoDocumento" id="tipoDocumento" class="form-control">
                            <option value="DNI">DNI</option>
                            <option value="RUC">RUC</option>
                            
                          </select>
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="documentoCliente">Número de Documento</label>
                          <input type="text" name="documentoCliente" id="documentoCliente" class="form-control">
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Información del Producto -->
                  <div class="col-md-6">
                    <h6 class="mb-3" style="color: #cc3333;"><i class="fas fa-box"></i> Datos del Producto</h6>
                    
                    <div class="form-group">
                      <label for="nombreProducto">Buscar Producto <span class="text-danger">*</span></label>
                      <input type="text" name="nombreProducto" id="nombreProducto" class="form-control" 
                             placeholder="Escriba el nombre del producto..." required>
                      <small class="form-text text-muted">Escriba el nombre del producto para buscarlo automáticamente</small>
                    </div>
                    
                    <div id="productoInfo" class="producto-info">
                      <div class="row">
                        <div class="col-md-6">
                          <strong>Precio sugerido:</strong> <span id="precioSugerido">S/ 0.00</span>
                        </div>
                        <div class="col-md-6">
                          <strong>Stock disponible:</strong> <span id="stockDisponible" class="badge">0</span>
                        </div>
                      </div>
                    </div>
                    
                    <div class="row">
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="cantidad">Cantidad <span class="text-danger">*</span></label>
                          <input type="number" name="cantidad" id="cantidad" class="form-control" min="1" required>
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label for="precioUnitario">Precio Unitario (S/) <span class="text-danger">*</span></label>
                          <input type="number" name="precioUnitario" id="precioUnitario" class="form-control" 
                                 step="0.01" min="0.01" required>
                        </div>
                      </div>
                    </div>
                    
                    <div class="form-group">
                      <label for="totalVenta">Total de la Venta (S/)</label>
                      <input type="text" id="totalVenta" class="form-control font-weight-bold" readonly>
                    </div>
                  </div>
                </div>

                <hr>
                <div class="text-center">
                  <button type="submit" class="btn btn-lg" style="background-color: #cc3333; border-color: #cc3333; color: white;">
                    <i class="fas fa-cash-register"></i> Registrar Venta
                  </button>
                  <button type="reset" class="btn btn-secondary btn-lg ml-2">
                    <i class="fas fa-undo"></i> Limpiar Formulario
                  </button>
                </div>
              </form>
            </div>
          </div>

          <!-- Ventas Recientes -->
          <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
              <h6 class="m-0 font-weight-bold" style="color: #cc3333;">
                <i class="fas fa-history"></i> Ventas Recientes
              </h6>
              <a href="VentaServlet?accion=listar" class="btn btn-sm" style="background-color: #cc3333; border-color: #cc3333; color: white;">
                <i class="fas fa-list"></i> Ver Todas
              </a>
            </div>
            <div class="card-body">
              <% 
                List<Venta> ventasRecientes = (List<Venta>) request.getAttribute("ventasRecientes");
                if (ventasRecientes != null && !ventasRecientes.isEmpty()) {
                  SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
              %>
                <div class="table-responsive">
                  <table class="table table-bordered table-ventas">
                    <thead class="thead-light">
                      <tr>
                        <th>Fecha</th>
                        <th>Cliente</th>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>P. Unitario</th>
                        <th>Total</th>
                        <th>Estado</th>
                      </tr>
                    </thead>
                    <tbody>
                      <% for (Venta venta : ventasRecientes) { %>
                        <tr>
                          <td><%= sdf.format(venta.getFecha()) %></td>
                          <td>
                            <strong><%= venta.getNombreCliente() %></strong><br>
                            <small class="text-muted"><%= venta.getTipoDocumento() %>: <%= venta.getDocumentoCliente() %></small>
                          </td>
                          <td>
                            <%= venta.getNombreProducto() != null ? venta.getNombreProducto() : "Producto #" + venta.getIdProducto() %>
                          </td>
                          <td><%= venta.getCantidadVendida() %></td>
                          <td>S/ <%= df.format(venta.getPrecioUnitario()) %></td>
                          <td><strong>S/ <%= df.format(venta.getTotal()) %></strong></td>
                          <td>
                            <span class="badge badge-success"><%= venta.getEstado() %></span>
                          </td>
                        </tr>
                      <% } %>
                    </tbody>
                  </table>
                </div>
              <% } else { %>
                <div class="text-center text-muted py-4">
                  <i class="fas fa-shopping-cart fa-3x mb-3"></i>
                  <p>No hay ventas registradas aún.</p>
                  <p>Complete el formulario arriba para registrar su primera venta.</p>
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
      // Toggle sidebar
      $("#sidebarToggleTop").click(function() {
        $("#accordionSidebar").toggleClass("toggled");
      });

      // Búsqueda automática de productos
      let timeoutId;
      $("#nombreProducto").on('input', function() {
        clearTimeout(timeoutId);
        const nombre = $(this).val().trim();
        
        if (nombre.length >= 3) {
          timeoutId = setTimeout(function() {
            buscarProducto(nombre);
          }, 500);
        } else {
          $("#productoInfo").hide();
          $("#idProducto").val('');
        }
      });

      // Calcular total automáticamente
      $("#cantidad, #precioUnitario").on('input', function() {
        calcularTotal();
      });

      // Limpiar formulario
      $("button[type='reset']").click(function() {
        $("#productoInfo").hide();
        $("#totalVenta").val('');
        $("#idProducto").val('');
      });
    });

    function buscarProducto(nombre) {
      $.ajax({
        url: 'VentaServlet',
        type: 'GET',
        data: { 
          accion: 'buscarProducto',
          nombre: nombre 
        },
        dataType: 'json',
        success: function(response) {
          if (response.encontrado) {
            $("#idProducto").val(response.id);
            $("#precioSugerido").text('S/ ' + response.precio.toFixed(2));
            $("#stockDisponible").text(response.stock);
            $("#precioUnitario").val(response.precio.toFixed(2));
            
            // Colorear badge según stock
            const badge = $("#stockDisponible");
            badge.removeClass('badge-stock-alto badge-stock-medio badge-stock-bajo');
            if (response.stock > 10) {
              badge.addClass('badge-stock-alto');
            } else if (response.stock > 5) {
              badge.addClass('badge-stock-medio');
            } else {
              badge.addClass('badge-stock-bajo');
            }
            
            $("#productoInfo").show();
            calcularTotal();
          } else {
            $("#productoInfo").hide();
            $("#idProducto").val('');
          }
        },
        error: function() {
          $("#productoInfo").hide();
          $("#idProducto").val('');
        }
      });
    }

    function calcularTotal() {
      const cantidad = parseFloat($("#cantidad").val()) || 0;
      const precio = parseFloat($("#precioUnitario").val()) || 0;
      const total = cantidad * precio;
      $("#totalVenta").val('S/ ' + total.toFixed(2));
    }

    // Validación del formulario
    $("#formVenta").submit(function(e) {
      const idProducto = $("#idProducto").val();
      if (!idProducto) {
        e.preventDefault();
        alert('Por favor, seleccione un producto válido.');
        $("#nombreProducto").focus();
        return false;
      }

      const stock = parseInt($("#stockDisponible").text()) || 0;
      const cantidad = parseInt($("#cantidad").val()) || 0;
      
      if (cantidad > stock) {
        e.preventDefault();
        alert('La cantidad solicitada (' + cantidad + ') excede el stock disponible (' + stock + ').');
        $("#cantidad").focus();
        return false;
      }
    });
  </script>
</body>
</html>
