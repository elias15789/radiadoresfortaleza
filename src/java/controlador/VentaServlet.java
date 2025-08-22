package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import modelo.Venta;
import modelo.Producto;
import modelo.dao.VentaDAO;
import modelo.dao.ProductoDAO;

@WebServlet("/VentaServlet")
public class VentaServlet extends HttpServlet {

    private final VentaDAO ventaDAO = new VentaDAO();
    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Control de acceso por rol: ADMIN y VENTAS/ASESOR pueden acceder
        try {
            HttpSession session = request.getSession(false);
            String rol = session != null ? (String) session.getAttribute("rolUsuario") : null;
            boolean autorizado = (rol == null) || "ADMIN".equals(rol) || "VENTAS".equals(rol) || "ASESOR".equals(rol) || "ASESOR_VENTAS".equals(rol);
            if (!autorizado) {
                response.sendRedirect("panel.jsp?error=sin_permiso");
                return;
            }
        } catch (Exception ignored) {}

        String accion = request.getParameter("accion");
        
        if (accion != null) {
            switch (accion) {
                case "listar":
                    listarVentas(request, response);
                    return;
                case "buscar":
                    buscarVentas(request, response);
                    return;
                case "buscarProducto":
                    buscarProductoAjax(request, response);
                    return;
                case "reporteDiario":
                    generarReporteDiario(request, response);
                    return;
                case "reporteMensual":
                    generarReporteMensual(request, response);
                    return;
            }
        }

        // Vista por defecto - mostrar formulario y ventas recientes
        mostrarPaginaVentas(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Control de acceso por rol
        try {
            HttpSession session = request.getSession(false);
            String rol = session != null ? (String) session.getAttribute("rolUsuario") : null;
            boolean autorizado = (rol == null) || "ADMIN".equals(rol) || "VENTAS".equals(rol) || "ASESOR".equals(rol) || "ASESOR_VENTAS".equals(rol);
            if (!autorizado) {
                response.sendRedirect("panel.jsp?error=sin_permiso");
                return;
            }
        } catch (Exception ignored) {}

        String accion = request.getParameter("accion");
        
        if ("registrar".equals(accion)) {
            registrarVenta(request, response);
        } else {
            // Compatibilidad con formulario anterior
            registrarVentaLegacy(request, response);
        }
    }

    private void registrarVenta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Obtener parámetros del formulario
            int idProducto = parseInt(request.getParameter("idProducto"));
            String nombreCliente = request.getParameter("nombreCliente");
            String documentoCliente = request.getParameter("documentoCliente");
            String tipoDocumento = request.getParameter("tipoDocumento");
            int cantidad = parseInt(request.getParameter("cantidad"));
            double precioUnitario = parseDouble(request.getParameter("precioUnitario"));

            // Validaciones básicas
            if (idProducto <= 0 || nombreCliente == null || nombreCliente.trim().isEmpty() || 
                cantidad <= 0 || precioUnitario <= 0) {
                request.setAttribute("error", "Todos los campos son obligatorios y deben ser válidos");
                mostrarPaginaVentas(request, response);
                return;
            }

            // Verificar que el producto existe
            Producto producto = productoDAO.buscarProductoPorNombre(request.getParameter("nombreProducto"));
            if (producto == null) {
                request.setAttribute("error", "El producto seleccionado no existe");
                mostrarPaginaVentas(request, response);
                return;
            }

            // Crear objeto venta
            Venta venta = new Venta(idProducto, nombreCliente.trim(), documentoCliente.trim(), 
                                  tipoDocumento, cantidad, precioUnitario);

            // Registrar venta
            boolean exito = ventaDAO.registrarVenta(venta);
            
            if (exito) {
                request.setAttribute("exito", "Venta registrada exitosamente");
            } else {
                request.setAttribute("error", "Error al registrar la venta. Verifique el stock disponible.");
            }

        } catch (Exception e) {
            request.setAttribute("error", "Error en los datos: " + e.getMessage());
        }

        mostrarPaginaVentas(request, response);
    }

    private void registrarVentaLegacy(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String nombreProducto = request.getParameter("nombre");
            int cantidad = parseInt(request.getParameter("cantidad"));
            double precio = parseDouble(request.getParameter("precio"));

            // Buscar producto por nombre
            Producto producto = productoDAO.buscarProductoPorNombre(nombreProducto);
            if (producto == null) {
                response.sendRedirect("ventas.jsp?error=producto_no_encontrado");
                return;
            }

            // Crear venta básica
            Venta venta = new Venta(producto.getId(), "Cliente General", "00000000", "DNI", cantidad, precio);
            boolean exito = ventaDAO.registrarVenta(venta);

            if (exito) {
                response.sendRedirect("ventas.jsp?exito=1");
            } else {
                response.sendRedirect("ventas.jsp?error=stock_insuficiente");
            }

        } catch (Exception e) {
            response.sendRedirect("ventas.jsp?error=datos_invalidos");
        }
    }

    private void listarVentas(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int pagina = parseInt(request.getParameter("pagina"));
            if (pagina <= 0) pagina = 1;
            
            int porPagina = 10;
            List<Venta> ventas = ventaDAO.obtenerVentasPaginadas(pagina, porPagina);
            int totalVentas = ventaDAO.contarTotalVentas();
            int totalPaginas = (int) Math.ceil((double) totalVentas / porPagina);

            request.setAttribute("ventas", ventas);
            request.setAttribute("paginaActual", pagina);
            request.setAttribute("totalPaginas", totalPaginas);
            request.setAttribute("totalVentas", totalVentas);

        } catch (Exception e) {
            request.setAttribute("error", "Error al cargar las ventas: " + e.getMessage());
        }

        request.getRequestDispatcher("lista_ventas.jsp").forward(request, response);
    }

    private void buscarVentas(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String termino = request.getParameter("termino");
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFin = request.getParameter("fechaFin");
        
        List<Venta> ventas;

        try {
            if (termino != null && !termino.trim().isEmpty()) {
                ventas = ventaDAO.buscarVentasPorCliente(termino.trim());
                request.setAttribute("terminoBusqueda", termino);
            } else if (fechaInicio != null && fechaFin != null && !fechaInicio.isEmpty() && !fechaFin.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date inicio = sdf.parse(fechaInicio);
                Date fin = sdf.parse(fechaFin);
                ventas = ventaDAO.obtenerVentasPorFecha(inicio, fin);
                request.setAttribute("fechaInicioBusqueda", fechaInicio);
                request.setAttribute("fechaFinBusqueda", fechaFin);
            } else {
                ventas = ventaDAO.obtenerTodasLasVentas();
            }

            request.setAttribute("ventas", ventas);
            request.setAttribute("esBusqueda", true);

        } catch (ParseException e) {
            request.setAttribute("error", "Formato de fecha inválido");
            ventas = ventaDAO.obtenerTodasLasVentas();
            request.setAttribute("ventas", ventas);
        } catch (Exception e) {
            request.setAttribute("error", "Error en la búsqueda: " + e.getMessage());
        }

        request.getRequestDispatcher("lista_ventas.jsp").forward(request, response);
    }

    private void buscarProductoAjax(HttpServletRequest request, HttpServletResponse response) throws IOException { 
        String nombre = request.getParameter("nombre");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (nombre != null && !nombre.trim().isEmpty()) {
            Producto producto = productoDAO.buscarProductoPorNombre(nombre.trim());
            if (producto != null) {
                String json = String.format(
                    "{\"encontrado\":true,\"id\":%d,\"nombre\":\"%s\",\"precio\":%.2f,\"stock\":%d}",
                    producto.getId(), producto.getNombre(), producto.getPrecio(), producto.getCantidad()
                );
                response.getWriter().write(json);
            } else {
                response.getWriter().write("{\"encontrado\":false}");
            }
        } else {
            response.getWriter().write("{\"encontrado\":false}");
        }
    }

    private void generarReporteDiario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Obtener total de ventas del día
            double totalHoy = ventaDAO.obtenerTotalVentasHoy();
            request.setAttribute("totalVentasHoy", totalHoy);
            
            // Formatear fecha actual
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String hoy = sdf.format(new Date());
            request.setAttribute("fechaReporte", hoy);
            
            // Obtener ventas del día
            List<Venta> ventasHoy;
            try {
                Date fechaHoy = new Date();
                ventasHoy = ventaDAO.obtenerVentasPorFecha(fechaHoy, fechaHoy);
            } catch (Exception e) {
                System.err.println("Error al obtener ventas por fecha: " + e.getMessage());
                // Como alternativa, obtener ventas recientes
                ventasHoy = ventaDAO.obtenerVentasPaginadas(1, 10);
            }
            
            request.setAttribute("ventasHoy", ventasHoy);
            
            // Forward a la página de reporte
            request.getRequestDispatcher("reporte_ventas.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error en generarReporteDiario: " + e.getMessage());
            e.printStackTrace();
            
            // En caso de error, redirigir con mensaje de error
            request.setAttribute("error", "Error al generar el reporte diario: " + e.getMessage());
            request.setAttribute("totalVentasHoy", 0.0);
            request.setAttribute("ventasHoy", new ArrayList<Venta>());
            request.setAttribute("fechaReporte", new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
            
            request.getRequestDispatcher("reporte_ventas.jsp").forward(request, response);
        }
    }

    private void generarReporteMensual(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        double totalMes = ventaDAO.obtenerTotalVentasMes();
        request.setAttribute("totalVentasMes", totalMes);
        request.getRequestDispatcher("reporte_ventas_mes.jsp").forward(request, response);
    }

    private void mostrarPaginaVentas(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Cargar productos para el formulario
        List<Producto> productos = productoDAO.obtenerProductos();
        request.setAttribute("productos", productos);

        // Cargar ventas recientes (últimas 5)
        List<Venta> ventasRecientes = ventaDAO.obtenerVentasPaginadas(1, 5);
        request.setAttribute("ventasRecientes", ventasRecientes);

        // Estadísticas rápidas
        double totalHoy = ventaDAO.obtenerTotalVentasHoy();
        double totalMes = ventaDAO.obtenerTotalVentasMes();
        request.setAttribute("totalVentasHoy", totalHoy);
        request.setAttribute("totalVentasMes", totalMes);

        request.getRequestDispatcher("ventas.jsp").forward(request, response);
    }

    private int parseInt(String s) {
        try {
            return s != null ? Integer.parseInt(s.trim()) : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private double parseDouble(String s) {
        try {
            return s != null ? Double.parseDouble(s.trim()) : 0.0;
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }
}
