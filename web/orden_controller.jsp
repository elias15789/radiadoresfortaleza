<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.OrdenVenta" %>
<%@ page import="modelo.Proveedor" %>
<%@ page import="modelo.Producto" %>
<%@ page import="modelo.dao.OrdenVentaDAO" %>
<%@ page import="modelo.dao.ProveedorDAO" %>
<%@ page import="modelo.dao.ProductoDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    request.setCharacterEncoding("UTF-8");
    String accion = request.getParameter("accion");
    
    OrdenVentaDAO ordenDAO = new OrdenVentaDAO();
    ProveedorDAO proveedorDAO = new ProveedorDAO();
    ProductoDAO productoDAO = new ProductoDAO();
    
    String mensaje = null;
    String error = null;
    
    if ("crear".equals(accion)) {
        try {
            // Verificar parámetros requeridos
            String idProveedorStr = request.getParameter("idProveedor");
            String idProductoStr = request.getParameter("idProducto");
            String cantidadStr = request.getParameter("cantidadSolicitada");
            String precioStr = request.getParameter("precioUnitario");
            
            if (idProveedorStr == null || idProveedorStr.trim().isEmpty()) {
                error = "Error: No se ha seleccionado un proveedor.";
            } else if (idProductoStr == null || idProductoStr.trim().isEmpty()) {
                error = "Error: No se ha seleccionado un producto.";
            } else {
                OrdenVenta orden = new OrdenVenta();
                orden.setIdProveedor(Integer.parseInt(idProveedorStr));
                orden.setIdProducto(Integer.parseInt(idProductoStr));
                orden.setCantidadSolicitada(Integer.parseInt(cantidadStr));
                orden.setPrecioUnitario(Double.parseDouble(precioStr));
                
                // Fecha de entrega esperada (opcional)
                String fechaEntregaStr = request.getParameter("fechaEntrega");
                if (fechaEntregaStr != null && !fechaEntregaStr.trim().isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date fechaEntrega = sdf.parse(fechaEntregaStr);
                    orden.setFechaEntregaEsperada(fechaEntrega);
                }
                
                orden.setObservaciones(request.getParameter("observaciones"));
                orden.setEstado("PENDIENTE");
                orden.setFechaOrden(new Date());
                
                // Generar número de orden automático
                orden.setNumeroOrden("OC-" + System.currentTimeMillis());
                
                boolean exito = ordenDAO.crearOrdenVenta(orden);
                
                if (exito) {
                    mensaje = "Orden de compra creada exitosamente. Número: " + orden.getNumeroOrden();
                } else {
                    error = "Error al crear la orden de compra.";
                }
            }
        } catch (NumberFormatException e) {
            error = "Error: Datos numéricos inválidos. Verifique cantidad y precio.";
        } catch (Exception e) {
            error = "Error al crear la orden: " + e.getMessage();
        }
    } else if ("cambiarEstado".equals(accion)) {
        try {
            int idOrden = Integer.parseInt(request.getParameter("idOrden"));
            String nuevoEstado = request.getParameter("nuevoEstado");
            
            boolean exito = ordenDAO.cambiarEstadoOrden(idOrden, nuevoEstado);
            
            if (exito) {
                mensaje = "Estado de la orden actualizado a: " + nuevoEstado;
            } else {
                error = "Error al cambiar el estado de la orden.";
            }
        } catch (Exception e) {
            error = "Error al cambiar el estado: " + e.getMessage();
        }
    }
    
    // Cargar datos para mostrar
    List<OrdenVenta> ordenes = ordenDAO.obtenerOrdenesVenta();
    List<Proveedor> proveedoresActivos = proveedorDAO.obtenerProveedoresActivos();
    List<Producto> productos = productoDAO.obtenerProductos();
    
    request.setAttribute("ordenes", ordenes);
    request.setAttribute("proveedoresActivos", proveedoresActivos);
    request.setAttribute("productos", productos);
    request.setAttribute("mensaje", mensaje);
    request.setAttribute("error", error);
    
    // Redirigir a la página de órdenes
    request.getRequestDispatcher("ordenes_venta.jsp").forward(request, response);
%>














