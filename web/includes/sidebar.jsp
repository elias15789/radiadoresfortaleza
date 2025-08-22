<!-- Sidebar Común para Radiadores Fortaleza -->
<ul class="navbar-nav sidebar sidebar-light accordion" id="accordionSidebar">
  <% String rol = null; try { rol = (String) session.getAttribute("rolUsuario"); } catch(Exception ignored) { } %>
  <% String brandHref = "panel.jsp"; if ("ALMACENERO".equals(rol)) { brandHref = "AlmacenServlet"; } else if ("VENDEDOR".equals(rol) || "ASESOR_VENTAS".equals(rol)) { brandHref = "VentaServlet"; } %>
  <a class="sidebar-brand d-flex align-items-center justify-content-center" href="<%= brandHref %>">
    <div class="sidebar-brand-icon">
      <img src="img/logo/images.png">
    </div>
    <div class="sidebar-brand-text mx-3">Radiadores Fortaleza</div>
  </a>
  <hr class="sidebar-divider my-0">
  
  <!-- Dashboard -->
  <% boolean mostrarPanel = (rol == null) || "ADMIN".equals(rol); %>
  <% if (mostrarPanel) { %>
  <li class="nav-item <%= "panel.jsp".equals(request.getParameter("page")) ? "active" : "" %>">
    <a class="nav-link" href="panel.jsp">
      <i class="fas fa-fw fa-tachometer-alt"></i>
      <span>Panel de Control</span>
    </a>
  </li>
  <% } %>
  
  <hr class="sidebar-divider">
  <div class="sidebar-heading">Gestión</div>
  
  <!-- Almacén -->
  <li class="nav-item <%= "almacen".equals(request.getParameter("section")) ? "active" : "" %>">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseAlmacen"
      aria-expanded="true" aria-controls="collapseAlmacen">
      <i class="fas fa-warehouse"></i>
      <span>Almacén</span>
    </a>
    <div id="collapseAlmacen" class="collapse <%= "almacen".equals(request.getParameter("section")) ? "show" : "" %>" 
         aria-labelledby="headingAlmacen" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">Productos en Almacén</h6>
        <a class="collapse-item" href="AlmacenServlet">Gestor de Almacén</a>
        <a class="collapse-item" href="AlmacenServlet?accion=VerAluminio">Radiadores de Aluminio</a>
        <a class="collapse-item" href="AlmacenServlet?accion=VerBronce">Radiadores de Bronce</a>
      </div>
    </div>
  </li>
  
  <!-- Ventas -->
  <li class="nav-item <%= "ventas".equals(request.getParameter("section")) ? "active" : "" %>">
    <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseVentas" 
      aria-expanded="true" aria-controls="collapseVentas">
      <i class="fas fa-shopping-cart"></i>
      <span>Ventas</span>
    </a>
    <div id="collapseVentas" class="collapse <%= "ventas".equals(request.getParameter("section")) ? "show" : "" %>" 
         aria-labelledby="headingVentas" data-parent="#accordionSidebar">
      <div class="bg-white py-2 collapse-inner rounded">
        <h6 class="collapse-header">Gestión de Ventas</h6>
        <a class="collapse-item <%= "registrar".equals(request.getParameter("page")) ? "active" : "" %>" href="VentaServlet">Registrar Venta</a>
        <a class="collapse-item <%= "listar".equals(request.getParameter("page")) ? "active" : "" %>" href="VentaServlet?accion=listar">Ver Todas las Ventas</a>
        <a class="collapse-item <%= "reporte".equals(request.getParameter("page")) ? "active" : "" %>" href="VentaServlet?accion=reporteDiario">Reporte Diario</a>
      </div>
    </div>
  </li>

  <!-- Control de Compras -->
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

  <hr class="sidebar-divider">
</ul>
