package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import modelo.Producto;
import modelo.dao.ProductoDAO;

@WebServlet("/AlmacenServlet")
public class AlmacenServlet extends HttpServlet {

    private final ProductoDAO dao = new ProductoDAO();

    // GET: Carga vistas según el valor de "accion"
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Control de acceso por rol: ADMIN y ALMACEN/ALMACENERO pueden acceder
        try {
            HttpSession session = request.getSession(false);
            String rol = session != null ? (String) session.getAttribute("rolUsuario") : null;
            boolean autorizado = (rol == null) || "ADMIN".equals(rol) || "ALMACEN".equals(rol) || "ALMACENERO".equals(rol);
            if (!autorizado) {
                response.sendRedirect("panel.jsp?error=sin_permiso");
                return;
            }
        } catch (Exception ignored) {}
        String accion = request.getParameter("accion");
        List<Producto> lista;

        if (accion != null) {
            switch (accion) {
                case "VerAluminio":
                    lista = dao.obtenerProductosPorTipo("Aluminio");
                    request.setAttribute("listaProductos", lista);
                    request.getRequestDispatcher("almacen_aluminio.jsp").forward(request, response);
                    return;

                case "VerBronce":
                    lista = dao.obtenerProductosPorTipo("Bronce");
                    request.setAttribute("listaProductos", lista);
                    request.getRequestDispatcher("almacen_bronce.jsp").forward(request, response);
                    return;

                case "StockBajo":
                    lista = dao.obtenerProductosStockBajo();
                    request.setAttribute("productosStockBajo", lista);
                    request.getRequestDispatcher("stock_bajo.jsp").forward(request, response);
                    return;

                case "VerDetalle":
                    String idDetalle = request.getParameter("id");
                    if (idDetalle != null) {
                        int id = parseInt(idDetalle);
                        // Aquí puedes implementar la vista de detalle
                        response.sendRedirect("AlmacenServlet");
                    }
                    return;

                case "Editar":
                    String idEditar = request.getParameter("id");
                    if (idEditar != null) {
                        int id = parseInt(idEditar);
                        // Redirigir al formulario de edición en almacen_nuevo.jsp con el ID
                        response.sendRedirect("AlmacenServlet?editarId=" + id);
                    }
                    return;
            }
        }

        // Vista por defecto
        lista = dao.obtenerProductos();
        request.setAttribute("listaProductos", lista);
        request.getRequestDispatcher("almacen_nuevo.jsp").forward(request, response);
    }

    // POST: Ejecuta acciones como Agregar, Modificar, Eliminar, Buscar
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Control de acceso por rol
        try {
            HttpSession session = request.getSession(false);
            String rol = session != null ? (String) session.getAttribute("rolUsuario") : null;
            boolean autorizado = (rol == null) || "ADMIN".equals(rol) || "ALMACEN".equals(rol) || "ALMACENERO".equals(rol);
            if (!autorizado) {
                response.sendRedirect("panel.jsp?error=sin_permiso");
                return;
            }
        } catch (Exception ignored) {}
        String accion = request.getParameter("accion");
        Producto producto;
        List<Producto> lista;

        switch (accion) {
            case "Agregar":
                producto = new Producto();
                producto.setNombre(request.getParameter("nombre"));
                producto.setTipo(request.getParameter("tipo"));
                producto.setModelo(request.getParameter("modelo"));
                producto.setCantidad(parseInt(request.getParameter("cantidad")));
                producto.setPrecio(parseDouble(request.getParameter("precio")));
                String imagenAgregar = request.getParameter("imagen");
                if (imagenAgregar != null && !imagenAgregar.trim().isEmpty()) {
                    producto.setImagen(imagenAgregar);
                } else {
                    producto.setImagen("placeholder.jpg");
                }
                dao.agregarProducto(producto);
                request.setAttribute("mensaje", "Producto agregado correctamente");
                break;

            case "Modificar":
                producto = new Producto();
                producto.setNombre(request.getParameter("nombre"));
                producto.setTipo(request.getParameter("tipo"));
                producto.setModelo(request.getParameter("modelo"));
                producto.setCantidad(parseInt(request.getParameter("cantidad")));
                producto.setPrecio(parseDouble(request.getParameter("precio")));
                dao.modificarProducto(producto);
                break;

            case "ModificarPorId":
                String idProductoModificar = request.getParameter("idProducto");
                if (idProductoModificar != null) {
                    try {
                        producto = new Producto();
                        producto.setId(parseInt(idProductoModificar));
                        producto.setNombre(request.getParameter("nombre"));
                        producto.setTipo(request.getParameter("tipo"));
                        producto.setModelo(request.getParameter("modelo"));
                        producto.setCantidad(parseInt(request.getParameter("cantidad")));
                        producto.setPrecio(parseDouble(request.getParameter("precio")));
                        String imagen = request.getParameter("imagen");
                        if (imagen != null && !imagen.trim().isEmpty()) {
                            producto.setImagen(imagen);
                        } else {
                            producto.setImagen("placeholder.jpg");
                        }
                        dao.modificarProductoPorId(producto);
                        request.setAttribute("mensaje", "Producto actualizado correctamente");
                    } catch (Exception e) {
                        request.setAttribute("mensaje", "Error al actualizar el producto");
                    }
                }
                break;

            case "Eliminar":
                String nombreEliminar = request.getParameter("nombre");
                dao.eliminarProductoPorNombre(nombreEliminar);
                break;

            case "Buscar":
                String nombreBuscar = request.getParameter("nombre");
                Producto productoBuscado = dao.buscarProductoPorNombre(nombreBuscar);
                if (productoBuscado != null) {
                    request.setAttribute("producto", productoBuscado);
                } else {
                    request.setAttribute("mensaje", "Producto no encontrado");
                }
                break;

            case "Reabastecer":
                String idProductoReabastecer = request.getParameter("idProducto");
                String cantidadAgregarStr = request.getParameter("cantidad");
                if (idProductoReabastecer != null && cantidadAgregarStr != null) {
                    try {
                        int idProducto = parseInt(idProductoReabastecer);
                        int cantidadAgregar = parseInt(cantidadAgregarStr);
                        
                        // Actualizar stock
                        boolean exito = dao.actualizarStock(idProducto, cantidadAgregar);
                        if (exito) {
                            request.setAttribute("mensaje", "Stock actualizado correctamente");
                        } else {
                            request.setAttribute("mensaje", "Error al actualizar el stock");
                        }
                    } catch (Exception e) {
                        request.setAttribute("mensaje", "Error en los datos proporcionados");
                    }
                }
                break;

            case "ActualizarImagen":
                String idProductoImagen = request.getParameter("idProducto");
                String nuevaImagen = request.getParameter("imagen");
                if (idProductoImagen != null && nuevaImagen != null) {
                    try {
                        int idProducto = parseInt(idProductoImagen);
                        boolean exito = dao.actualizarImagen(idProducto, nuevaImagen);
                        if (exito) {
                            request.setAttribute("mensaje", "Imagen actualizada correctamente");
                        } else {
                            request.setAttribute("mensaje", "Error al actualizar la imagen");
                        }
                    } catch (Exception e) {
                        request.setAttribute("mensaje", "Error al procesar la imagen");
                    }
                }
                break;
        }

        // Siempre actualizar la lista de productos
        lista = dao.obtenerProductos();
        request.setAttribute("listaProductos", lista);
        request.getRequestDispatcher("almacen_nuevo.jsp").forward(request, response);
    }

    private int parseInt(String s) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return 0;
        }
    }

    private double parseDouble(String s) {
        try {
            return Double.parseDouble(s);
        } catch (Exception e) {
            return 0.0;
        }
    }
}
