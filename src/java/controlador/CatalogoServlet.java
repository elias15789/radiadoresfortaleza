package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Producto;
import modelo.dao.ProductoDAO;
import java.io.IOException;
import java.util.List;

@WebServlet("/CatalogoServlet")
public class CatalogoServlet extends HttpServlet {
    
    private ProductoDAO productoDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        productoDAO = new ProductoDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("Entrando a CatalogoServlet.doGet()"); // Debug
        
        try {
            // Parámetros de búsqueda y filtrado
            String tipo = request.getParameter("tipo");
            String busqueda = request.getParameter("q");
            
            System.out.println("Parámetros recibidos - tipo: " + tipo + ", busqueda: " + busqueda); // Debug
            
            // Configuración de paginación
            int pagina = obtenerParametroPagina(request);
            int productosPorPagina = 9;
            
            List<Producto> productos;
            int totalProductos;
            String titulo;
            
            // Lógica para determinar qué productos mostrar
            if (busqueda != null && !busqueda.trim().isEmpty()) {
                System.out.println("Realizando búsqueda: " + busqueda); // Debug
                productos = productoDAO.buscarProductos(busqueda.trim(), pagina, productosPorPagina);
                totalProductos = productoDAO.contarProductosBusqueda(busqueda.trim());
                titulo = "Resultados para: " + busqueda;
            } else if (tipo != null && !tipo.trim().isEmpty()) {
                System.out.println("Filtrando por tipo: " + tipo); // Debug
                productos = productoDAO.obtenerProductosPorTipo(tipo.trim());
                totalProductos = productoDAO.contarProductosPorTipo(tipo.trim());
                titulo = "Productos de " + tipo;
            } else {
                System.out.println("Obteniendo todos los productos"); // Debug
                productos = productoDAO.obtenerProductosPaginados(pagina, productosPorPagina);
                totalProductos = productoDAO.contarTotalProductos();
                titulo = "Nuestros productos";
            }
            
            System.out.println("Productos encontrados: " + productos.size()); // Debug
            System.out.println("Total de productos: " + totalProductos); // Debug
            
            // Calcular total de páginas
            int totalPaginas = (int) Math.ceil((double) totalProductos / productosPorPagina);
            
            // Obtener tipos de productos para los filtros
            List<String> tiposProductos = productoDAO.obtenerTiposProductos();
            
            // Configurar atributos para la vista
            configurarAtributosVista(request, productos, tiposProductos, titulo, pagina, totalPaginas);
            
            // Redirigir a la vista
            System.out.println("Redirigiendo a catalogo.jsp"); // Debug
            request.getRequestDispatcher("catalogo.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error en CatalogoServlet: " + e.getMessage()); // Debug
            e.printStackTrace();
            manejarError(request, response, e);
        }
    }
    
    private int obtenerParametroPagina(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("pagina"));
        } catch (NumberFormatException e) {
            return 1;
        }
    }
    
    private void configurarAtributosVista(HttpServletRequest request, List<Producto> productos, 
                                        List<String> tiposProductos, String titulo, 
                                        int paginaActual, int totalPaginas) {
        request.setAttribute("productos", productos);
        request.setAttribute("tiposProductos", tiposProductos);
        request.setAttribute("titulo", titulo);
        request.setAttribute("paginaActual", paginaActual);
        request.setAttribute("totalPaginas", totalPaginas);
        
        // Parámetros para mantener en los links de paginación
        String tipo = request.getParameter("tipo");
        String busqueda = request.getParameter("q");
        if (tipo != null) {
            request.setAttribute("parametrosFiltro", "tipo=" + tipo);
        } else if (busqueda != null) {
            request.setAttribute("parametrosFiltro", "q=" + busqueda);
        }
        
        System.out.println("Atributos configurados:"); // Debug
        System.out.println("- productos: " + productos.size() + " items");
        System.out.println("- tiposProductos: " + tiposProductos.size() + " items");
        System.out.println("- titulo: " + titulo);
        System.out.println("- paginaActual: " + paginaActual);
        System.out.println("- totalPaginas: " + totalPaginas);
    }
    
    private void manejarError(HttpServletRequest request, HttpServletResponse response, Exception e) 
            throws ServletException, IOException {
        request.setAttribute("error", "Error al cargar el catálogo: " + e.getMessage());
        try {
            request.getRequestDispatcher("catalogo.jsp").forward(request, response);
        } catch (Exception ex) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error grave en el servidor");
        }
    }
}