package modelo.dao;

import modelo.Producto;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    private final String jdbcURL = "jdbc:mysql://hopper.proxy.rlwy.net:51480/railway";
    private final String jdbcUser = "root";
    private final String jdbcPassword = "gTUqErORGgdpKJEtPRUyNHDvEEhEwoWg";


    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUser, jdbcPassword);
    }

    // Agregar producto usando SP
    public void agregarProducto(Producto producto) {
        String sql = "{CALL registrar_producto(?, ?, ?, ?, ?)}";
        try (Connection con = getConnection(); CallableStatement cs = con.prepareCall(sql)) {
            cs.setString(1, producto.getNombre());
            cs.setDouble(2, producto.getPrecio());
            cs.setString(3, producto.getTipo());
            cs.setInt(4, producto.getCantidad());
            cs.setString(5, producto.getModelo());
            cs.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Modificar producto usando SP (por nombre)
    public void modificarProducto(Producto producto) {
        String sql = "{CALL modificar_producto(?, ?, ?, ?, ?)}";
        try (Connection con = getConnection(); CallableStatement cs = con.prepareCall(sql)) {
            cs.setString(1, producto.getNombre());  
            cs.setDouble(2, producto.getPrecio());
            cs.setString(3, producto.getTipo());
            cs.setInt(4, producto.getCantidad());
            cs.setString(5, producto.getModelo());
            cs.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Eliminar producto por nombre usando SP
    public void eliminarProductoPorNombre(String nombre) {
        String sql = "{CALL eliminar_producto(?)}";
        try (Connection con = getConnection(); CallableStatement cs = con.prepareCall(sql)) {
            cs.setString(1, nombre);
            cs.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Buscar producto por nombre usando SP
    public Producto buscarProductoPorNombre(String nombre) {
        Producto producto = null;
        String sql = "{CALL buscar_producto(?)}";
        try (Connection con = getConnection(); CallableStatement cs = con.prepareCall(sql)) {
            cs.setString(1, nombre);
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    producto = new Producto();
                    producto.setId(rs.getInt("idproductos"));
                    producto.setNombre(rs.getString("nombre"));
                    producto.setPrecio(rs.getDouble("precio"));
                    producto.setTipo(rs.getString("tipo"));
                    producto.setCantidad(rs.getInt("cantidad"));
                    producto.setModelo(rs.getString("modelo"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return producto;
    }

    // Obtener productos con stock bajo usando SP
    public List<Producto> obtenerProductosStockBajo() {
        List<Producto> lista = new ArrayList<>();
        String sql = "{CALL alerta_stock_bajo()}";
        try (Connection con = getConnection(); CallableStatement cs = con.prepareCall(sql); ResultSet rs = cs.executeQuery()) {
            while (rs.next()) {
                Producto producto = new Producto();
                producto.setId(rs.getInt("idproductos"));
                producto.setNombre(rs.getString("nombre"));
                producto.setPrecio(rs.getDouble("precio"));
                producto.setTipo(rs.getString("tipo"));
                producto.setCantidad(rs.getInt("cantidad"));
                producto.setModelo(rs.getString("modelo"));
                lista.add(producto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Obtener todos los productos
    public List<Producto> obtenerProductos() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT * FROM productos";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Producto producto = new Producto();
                producto.setId(rs.getInt("idproductos"));
                producto.setNombre(rs.getString("nombre"));
                producto.setPrecio(rs.getDouble("precio"));
                producto.setTipo(rs.getString("tipo"));
                producto.setCantidad(rs.getInt("cantidad"));
                producto.setModelo(rs.getString("modelo"));
                lista.add(producto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public List<Producto> obtenerProductosPorTipo(String tipo) {
    List<Producto> lista = new ArrayList<>();
    String sql = "SELECT * FROM productos WHERE tipo = ?";
    try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, tipo);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Producto producto = new Producto();
                producto.setId(rs.getInt("idproductos"));
                producto.setNombre(rs.getString("nombre"));
                producto.setPrecio(rs.getDouble("precio"));
                producto.setTipo(rs.getString("tipo"));
                producto.setCantidad(rs.getInt("cantidad"));
                producto.setModelo(rs.getString("modelo"));
                lista.add(producto);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return lista;
}
// --- MÉTODOS NUEVOS PARA EL CATÁLOGO ---

/**
 * Busca productos por término (nombre o modelo) con coincidencias parciales y paginación
 * @param termino Texto a buscar (ej: "Toyota")
 * @param pagina Número de página (comienza en 1)
 * @param porPagina Cantidad de productos por página
 * @return Lista de productos que coinciden
 */
public List<Producto> buscarProductos(String termino, int pagina, int porPagina) {
    List<Producto> resultados = new ArrayList<>();
    String sql = "SELECT * FROM productos WHERE nombre LIKE ? OR modelo LIKE ? LIMIT ? OFFSET ?";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        int offset = (pagina - 1) * porPagina;
        ps.setString(1, "%" + termino + "%");
        ps.setString(2, "%" + termino + "%");
        ps.setInt(3, porPagina);
        ps.setInt(4, offset);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Producto producto = new Producto();
                producto.setId(rs.getInt("idproductos"));
                producto.setNombre(rs.getString("nombre"));
                producto.setPrecio(rs.getDouble("precio"));
                producto.setTipo(rs.getString("tipo"));
                producto.setCantidad(rs.getInt("cantidad"));
                producto.setModelo(rs.getString("modelo"));
                resultados.add(producto);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return resultados;
}

/**
 * Obtiene productos por tipo con paginación
 * @param tipo Tipo de producto a filtrar
 * @param pagina Número de página (comienza en 1)
 * @param porPagina Cantidad de productos por página
 * @return Lista de productos del tipo especificado
 */
public List<Producto> obtenerProductosPorTipoPaginados(String tipo, int pagina, int porPagina) {
    List<Producto> lista = new ArrayList<>();
    String sql = "SELECT * FROM productos WHERE tipo = ? LIMIT ? OFFSET ?";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        int offset = (pagina - 1) * porPagina;
        ps.setString(1, tipo);
        ps.setInt(2, porPagina);
        ps.setInt(3, offset);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Producto producto = new Producto();
                producto.setId(rs.getInt("idproductos"));
                producto.setNombre(rs.getString("nombre"));
                producto.setPrecio(rs.getDouble("precio"));
                producto.setTipo(rs.getString("tipo"));
                producto.setCantidad(rs.getInt("cantidad"));
                producto.setModelo(rs.getString("modelo"));
                lista.add(producto);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return lista;
}

/**
 * Obtiene todos los productos con paginación
 * @param pagina Número de página (comienza en 1)
 * @param porPagina Cantidad de productos por página
 * @return Lista de productos paginada
 */
public List<Producto> obtenerProductosPaginados(int pagina, int porPagina) {
    List<Producto> lista = new ArrayList<>();
    String sql = "SELECT * FROM productos LIMIT ? OFFSET ?";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        int offset = (pagina - 1) * porPagina;
        ps.setInt(1, porPagina);
        ps.setInt(2, offset);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Producto producto = new Producto();
                producto.setId(rs.getInt("idproductos"));
                producto.setNombre(rs.getString("nombre"));
                producto.setPrecio(rs.getDouble("precio"));
                producto.setTipo(rs.getString("tipo"));
                producto.setCantidad(rs.getInt("cantidad"));
                producto.setModelo(rs.getString("modelo"));
                lista.add(producto);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return lista;
}

/**
 * Cuenta el total de productos para paginación
 * @return Total de productos en la base de datos
 */
public int contarTotalProductos() {
    String sql = "SELECT COUNT(*) FROM productos";
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}

/**
 * Cuenta productos que coinciden con un término de búsqueda
 * @param termino Texto a buscar
 * @return Cantidad de productos que coinciden
 */
public int contarProductosBusqueda(String termino) {
    String sql = "SELECT COUNT(*) FROM productos WHERE nombre LIKE ? OR modelo LIKE ?";
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, "%" + termino + "%");
        ps.setString(2, "%" + termino + "%");
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}

/**
 * Cuenta productos de un tipo específico
 * @param tipo Tipo de producto
 * @return Cantidad de productos del tipo especificado
 */
public int contarProductosPorTipo(String tipo) {
    String sql = "SELECT COUNT(*) FROM productos WHERE tipo = ?";
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, tipo);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}

/**
 * Obtiene la lista de tipos de productos disponibles
 * @return Lista de tipos distintos
 */
public List<String> obtenerTiposProductos() {
    List<String> tipos = new ArrayList<>();
    String sql = "SELECT DISTINCT tipo FROM productos";
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            tipos.add(rs.getString("tipo"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return tipos;
}

/**
 * Actualiza el stock de un producto agregando la cantidad especificada
 */
public boolean actualizarStock(int idProducto, int cantidadAgregar) {
    String sql = "UPDATE productos SET cantidad = cantidad + ? WHERE idproductos = ?";
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, cantidadAgregar);
        ps.setInt(2, idProducto);
        int filasAfectadas = ps.executeUpdate();
        return filasAfectadas > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

/**
 * Actualiza la imagen de un producto
 */
public boolean actualizarImagen(int idProducto, String nuevaImagen) {
    String sql = "UPDATE productos SET imagen = ? WHERE idproductos = ?";
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, nuevaImagen);
        ps.setInt(2, idProducto);
        int filasAfectadas = ps.executeUpdate();
        return filasAfectadas > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

/**
 * Obtiene un producto por su ID
 */
public Producto obtenerProductoPorId(int idProducto) {
    String sql = "SELECT * FROM productos WHERE idproductos = ?";
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idProducto);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Producto producto = new Producto();
                producto.setId(rs.getInt("idproductos"));
                producto.setNombre(rs.getString("nombre"));
                producto.setPrecio(rs.getDouble("precio"));
                producto.setTipo(rs.getString("tipo"));
                producto.setCantidad(rs.getInt("cantidad"));
                producto.setModelo(rs.getString("modelo"));
                producto.setImagen(rs.getString("imagen"));
                producto.setMarca(rs.getString("marca"));
                return producto;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

/**
 * Modifica un producto por ID en lugar de nombre
 */
public void modificarProductoPorId(Producto producto) {
    String sql = "{CALL modificar_producto_por_id(?, ?, ?, ?, ?, ?, ?)}";
    try (Connection con = getConnection(); CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, producto.getId());
        cs.setString(2, producto.getNombre());  
        cs.setDouble(3, producto.getPrecio());
        cs.setString(4, producto.getTipo());
        cs.setInt(5, producto.getCantidad());
        cs.setString(6, producto.getModelo());
        cs.setString(7, producto.getImagen());
        cs.executeUpdate();
    } catch (Exception e) {
        // Si no existe el SP, usar SQL directo
        String sqlDirect = "UPDATE productos SET nombre=?, precio=?, tipo=?, cantidad=?, modelo=?, imagen=? WHERE idproductos=?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sqlDirect)) {
            ps.setString(1, producto.getNombre());
            ps.setDouble(2, producto.getPrecio());
            ps.setString(3, producto.getTipo());
            ps.setInt(4, producto.getCantidad());
            ps.setString(5, producto.getModelo());
            ps.setString(6, producto.getImagen());
            ps.setInt(7, producto.getId());
            ps.executeUpdate();
        } catch (Exception e2) {
            e2.printStackTrace();
        }
    }
}
}
