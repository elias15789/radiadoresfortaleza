<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Proveedor" %>
<%@ page import="modelo.dao.ProveedorDAO" %>
<%@ page import="java.util.Date" %>
<%@ page errorPage="error_handler.jsp" %>

<%
try {
    request.setCharacterEncoding("UTF-8");
    String accion = request.getParameter("accion");
    
    if (accion == null) {
        response.sendRedirect("gestionar_proveedores.jsp");
        return;
    }
    
    ProveedorDAO proveedorDAO = new ProveedorDAO();
    String mensaje = null;
    String error = null;
    
    if ("agregar".equals(accion)) {
        try {
            String nombre = request.getParameter("nombre");
            if (nombre == null || nombre.trim().isEmpty()) {
                error = "El nombre es requerido.";
            } else {
                Proveedor proveedor = new Proveedor();
                proveedor.setNombre(nombre.trim());
                proveedor.setRuc(request.getParameter("ruc"));
                proveedor.setRazonSocial(request.getParameter("razonSocial"));
                proveedor.setTelefono(request.getParameter("telefono"));
                proveedor.setEmail(request.getParameter("email"));
                proveedor.setDireccion(request.getParameter("direccion"));
                proveedor.setContacto(request.getParameter("contacto"));
                proveedor.setEstado("ACTIVO");
                proveedor.setFechaRegistro(new Date());
                
                boolean exito = proveedorDAO.crearProveedor(proveedor);
                
                if (exito) {
                    mensaje = "Proveedor agregado exitosamente.";
                } else {
                    error = "Error al agregar el proveedor.";
                }
            }
        } catch (Exception e) {
            error = "Error al agregar el proveedor: " + e.getMessage();
        }
        
    } else if ("editar".equals(accion)) {
        try {
            String idProveedorStr = request.getParameter("idProveedor");
            if (idProveedorStr == null || idProveedorStr.trim().isEmpty()) {
                error = "ID de proveedor requerido.";
            } else {
                int idProveedor = Integer.parseInt(idProveedorStr);
                
                // Obtener el proveedor actual
                Proveedor proveedorActual = proveedorDAO.obtenerProveedorPorId(idProveedor);
                if (proveedorActual == null) {
                    error = "Proveedor no encontrado.";
                } else {
                    Proveedor proveedor = new Proveedor();
                    proveedor.setIdProveedor(idProveedor);
                    proveedor.setNombre(request.getParameter("nombre"));
                    proveedor.setRuc(request.getParameter("ruc"));
                    proveedor.setRazonSocial(request.getParameter("razonSocial"));
                    proveedor.setTelefono(request.getParameter("telefono"));
                    proveedor.setEmail(request.getParameter("email"));
                    proveedor.setDireccion(request.getParameter("direccion"));
                    proveedor.setContacto(request.getParameter("contacto"));
                    // Mantener el estado y fecha originales
                    proveedor.setEstado(proveedorActual.getEstado());
                    proveedor.setFechaRegistro(proveedorActual.getFechaRegistro());
                    
                    boolean exito = proveedorDAO.actualizarProveedor(proveedor);
                    
                    if (exito) {
                        mensaje = "Proveedor actualizado exitosamente.";
                    } else {
                        error = "Error al actualizar el proveedor.";
                    }
                }
            }
        } catch (NumberFormatException e) {
            error = "ID de proveedor inválido.";
        } catch (Exception e) {
            error = "Error al actualizar el proveedor: " + e.getMessage();
        }
        
    } else if ("cambiarEstado".equals(accion)) {
        try {
            String idProveedorStr = request.getParameter("idProveedor");
            String nuevoEstado = request.getParameter("nuevoEstado");
            
            if (idProveedorStr == null || nuevoEstado == null) {
                error = "Parámetros requeridos faltantes.";
            } else {
                int idProveedor = Integer.parseInt(idProveedorStr);
                
                Proveedor proveedor = proveedorDAO.obtenerProveedorPorId(idProveedor);
                if (proveedor != null) {
                    boolean exito = proveedorDAO.cambiarEstadoProveedor(idProveedor, nuevoEstado);
                    
                    if (exito) {
                        mensaje = "Estado del proveedor cambiado a: " + nuevoEstado;
                    } else {
                        error = "Error al cambiar el estado del proveedor.";
                    }
                } else {
                    error = "Proveedor no encontrado.";
                }
            }
        } catch (NumberFormatException e) {
            error = "ID de proveedor inválido.";
        } catch (Exception e) {
            error = "Error al cambiar el estado: " + e.getMessage();
        }
    } else {
        error = "Acción no válida.";
    }
    
    // Cargar proveedores para mostrar
    List<Proveedor> proveedores = proveedorDAO.obtenerProveedores();
    request.setAttribute("proveedores", proveedores);
    request.setAttribute("mensaje", mensaje);
    request.setAttribute("error", error);
    
    // Redirigir a la página de gestión
    request.getRequestDispatcher("gestionar_proveedores.jsp").forward(request, response);
    
} catch (Exception e) {
    // Log del error
    System.err.println("Error en proveedor_actions.jsp: " + e.getMessage());
    e.printStackTrace();
    
    // Redirigir con error
    request.setAttribute("error", "Error interno del sistema: " + e.getMessage());
    request.getRequestDispatcher("gestionar_proveedores.jsp").forward(request, response);
}
%>

