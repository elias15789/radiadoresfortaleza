package modelo.dao;

import modelo.Venta;
import modelo.Producto;
import modelo.dao.ProductoDAO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.text.SimpleDateFormat;

public class VentaDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/Sys_Radiadores_Fort";
    private final String jdbcUser = "root";
    private final String jdbcPassword = "";

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUser, jdbcPassword);
    }

    /**
     * Registra una nueva venta y actualiza el stock del producto
     */
    public boolean registrarVenta(Venta venta) {
        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false); // Transacción

            // 1. Verificar stock disponible
            String sqlStock = "SELECT cantidad FROM productos WHERE idproductos = ?";
            try (PreparedStatement psStock = con.prepareStatement(sqlStock)) {
                psStock.setInt(1, venta.getIdProducto());
                try (ResultSet rs = psStock.executeQuery()) {
                    if (rs.next()) {
                        int stockActual = rs.getInt("cantidad");
                        if (stockActual < venta.getCantidadVendida()) {
                            throw new SQLException("Stock insuficiente. Disponible: " + stockActual);
                        }
                    } else {
                        throw new SQLException("Producto no encontrado");
                    }
                }
            }

            // 2. Registrar la venta
            String sqlVenta = "INSERT INTO ventas (id_producto, nombre_cliente, documento_cliente, tipo_documento, cantidad_vendida, precio_unitario, total, fecha, estado) VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), ?)";
            try (PreparedStatement psVenta = con.prepareStatement(sqlVenta)) {
                psVenta.setInt(1, venta.getIdProducto());
                psVenta.setString(2, venta.getNombreCliente());
                psVenta.setString(3, venta.getDocumentoCliente());
                psVenta.setString(4, venta.getTipoDocumento());
                psVenta.setInt(5, venta.getCantidadVendida());
                psVenta.setDouble(6, venta.getPrecioUnitario());
                psVenta.setDouble(7, venta.getTotal());
                psVenta.setString(8, venta.getEstado());
                psVenta.executeUpdate();
            }

            // 3. Actualizar stock del producto
            String sqlUpdateStock = "UPDATE productos SET cantidad = cantidad - ? WHERE idproductos = ?";
            try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdateStock)) {
                psUpdate.setInt(1, venta.getCantidadVendida());
                psUpdate.setInt(2, venta.getIdProducto());
                psUpdate.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Obtiene todas las ventas con información del producto
     */
    public List<Venta> obtenerTodasLasVentas() {
        List<Venta> ventas = new ArrayList<>();
        
        // Intentar con la nueva estructura primero
        String sql = "SELECT v.*, p.nombre as nombre_producto FROM ventas v " +
                    "LEFT JOIN productos p ON v.id_producto = p.idproductos " +
                    "ORDER BY v.fecha DESC";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Venta venta = mapearVentaSafe(rs);
                if (venta != null) {
                    ventas.add(venta);
                }
            }
        } catch (Exception e) {
            System.err.println("Error al obtener ventas: " + e.getMessage());
            e.printStackTrace();
            
            // Si falla, intentar con estructura básica
            ventas = obtenerVentasBasicas();
        }
        return ventas;
    }

    /**
     * Método de respaldo para obtener ventas con estructura básica
     */
    private List<Venta> obtenerVentasBasicas() {
        List<Venta> ventas = new ArrayList<>();
        String sql = "SELECT * FROM ventas ORDER BY id DESC LIMIT 10";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Venta venta = new Venta();
                venta.setIdVenta(rs.getInt("id"));
                venta.setIdProducto(rs.getInt("id_producto"));
                venta.setCantidadVendida(rs.getInt("cantidad"));
                venta.setPrecioUnitario(rs.getDouble("precio_unitario"));
                venta.setTotal(rs.getDouble("total"));
                venta.setFecha(rs.getTimestamp("fecha_venta"));
                venta.setNombreCliente("Cliente General");
                venta.setDocumentoCliente("00000000");
                venta.setTipoDocumento("DNI");
                venta.setEstado("COMPLETADA");
                ventas.add(venta);
            }
        } catch (Exception e) {
            System.err.println("Error al obtener ventas básicas: " + e.getMessage());
            e.printStackTrace();
        }
        return ventas;
    }

    /**
     * Obtiene ventas con paginación
     */
    public List<Venta> obtenerVentasPaginadas(int pagina, int porPagina) {
        List<Venta> ventas = new ArrayList<>();
        String sql = "SELECT v.*, p.nombre as nombre_producto FROM ventas v " +
                    "LEFT JOIN productos p ON v.id_producto = p.idproductos " +
                    "ORDER BY v.fecha DESC LIMIT ? OFFSET ?";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            int offset = (pagina - 1) * porPagina;
            ps.setInt(1, porPagina);
            ps.setInt(2, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Venta venta = mapearVenta(rs);
                    ventas.add(venta);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ventas;
    }

    /**
     * Busca ventas por cliente
     */
    public List<Venta> buscarVentasPorCliente(String cliente) {
        List<Venta> ventas = new ArrayList<>();
        String sql = "SELECT v.*, p.nombre as nombre_producto FROM ventas v " +
                    "LEFT JOIN productos p ON v.id_producto = p.idproductos " +
                    "WHERE v.nombre_cliente LIKE ? OR v.documento_cliente LIKE ? " +
                    "ORDER BY v.fecha DESC";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            String termino = "%" + cliente + "%";
            ps.setString(1, termino);
            ps.setString(2, termino);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Venta venta = mapearVenta(rs);
                    ventas.add(venta);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ventas;
    }

    /**
     * Obtiene ventas por rango de fechas
     */
    public List<Venta> obtenerVentasPorFecha(Date fechaInicio, Date fechaFin) {
        List<Venta> ventas = new ArrayList<>();
        String sql = "SELECT v.*, p.nombre as nombre_producto FROM ventas v " +
                    "LEFT JOIN productos p ON v.id_producto = p.idproductos " +
                    "WHERE DATE(v.fecha) BETWEEN ? AND ? " +
                    "ORDER BY v.fecha DESC";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setDate(1, new java.sql.Date(fechaInicio.getTime()));
            ps.setDate(2, new java.sql.Date(fechaFin.getTime()));
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Venta venta = mapearVenta(rs);
                    ventas.add(venta);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ventas;
    }

    /**
     * Obtiene el total de ventas del día
     */
    public double obtenerTotalVentasHoy() {
        // Intentar con la nueva estructura primero
        String sql = "SELECT COALESCE(SUM(total), 0) as total_hoy FROM ventas WHERE DATE(fecha) = CURDATE()";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("total_hoy");
            }
        } catch (Exception e) {
            System.err.println("Error con nueva estructura, intentando con estructura antigua: " + e.getMessage());
            
            // Si falla, intentar con estructura antigua
            String sqlAntigua = "SELECT COALESCE(SUM(total), 0) as total_hoy FROM ventas WHERE DATE(fecha_venta) = CURDATE()";
            try (Connection con = getConnection();
                 PreparedStatement ps = con.prepareStatement(sqlAntigua);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    return rs.getDouble("total_hoy");
                }
            } catch (Exception e2) {
                System.err.println("Error al obtener total de ventas hoy: " + e2.getMessage());
                e2.printStackTrace();
            }
        }
        return 0.0;
    }

    /**
     * Obtiene el total de ventas del mes
     */
    public double obtenerTotalVentasMes() {
        String sql = "SELECT COALESCE(SUM(total), 0) as total_mes FROM ventas " +
                    "WHERE MONTH(fecha) = MONTH(CURDATE()) AND YEAR(fecha) = YEAR(CURDATE())";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("total_mes");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Cuenta el total de ventas para paginación
     */
    public int contarTotalVentas() {
        String sql = "SELECT COUNT(*) FROM ventas";
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
     * Obtiene una venta por ID
     */
    public Venta obtenerVentaPorId(int idVenta) {
        String sql = "SELECT v.*, p.nombre as nombre_producto FROM ventas v " +
                    "LEFT JOIN productos p ON v.id_producto = p.idproductos " +
                    "WHERE v.id_venta = ?";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idVenta);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearVenta(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Mapea un ResultSet a un objeto Venta (versión segura)
     */
    private Venta mapearVentaSafe(ResultSet rs) {
        try {
            Venta venta = new Venta();
            
            // Intentar obtener campos de la nueva estructura
            try {
                venta.setIdVenta(rs.getInt("id_venta"));
            } catch (SQLException e) {
                venta.setIdVenta(rs.getInt("id"));
            }
            
            venta.setIdProducto(rs.getInt("id_producto"));
            
            try {
                venta.setNombreProducto(rs.getString("nombre_producto"));
            } catch (SQLException e) {
                venta.setNombreProducto("Producto #" + venta.getIdProducto());
            }
            
            try {
                venta.setNombreCliente(rs.getString("nombre_cliente"));
            } catch (SQLException e) {
                venta.setNombreCliente("Cliente General");
            }
            
            try {
                venta.setDocumentoCliente(rs.getString("documento_cliente"));
            } catch (SQLException e) {
                venta.setDocumentoCliente("00000000");
            }
            
            try {
                venta.setTipoDocumento(rs.getString("tipo_documento"));
            } catch (SQLException e) {
                venta.setTipoDocumento("DNI");
            }
            
            try {
                venta.setCantidadVendida(rs.getInt("cantidad_vendida"));
            } catch (SQLException e) {
                venta.setCantidadVendida(rs.getInt("cantidad"));
            }
            
            venta.setPrecioUnitario(rs.getDouble("precio_unitario"));
            venta.setTotal(rs.getDouble("total"));
            
            try {
                venta.setFecha(rs.getTimestamp("fecha"));
            } catch (SQLException e) {
                venta.setFecha(rs.getTimestamp("fecha_venta"));
            }
            
            try {
                venta.setEstado(rs.getString("estado"));
            } catch (SQLException e) {
                venta.setEstado("COMPLETADA");
            }
            
            return venta;
        } catch (SQLException e) {
            System.err.println("Error al mapear venta: " + e.getMessage());
            return null;
        }
    }

    /**
     * Mapea un ResultSet a un objeto Venta (versión original)
     */
    private Venta mapearVenta(ResultSet rs) throws SQLException {
        Venta venta = new Venta();
        venta.setIdVenta(rs.getInt("id_venta"));
        venta.setIdProducto(rs.getInt("id_producto"));
        venta.setNombreProducto(rs.getString("nombre_producto"));
        venta.setNombreCliente(rs.getString("nombre_cliente"));
        venta.setDocumentoCliente(rs.getString("documento_cliente"));
        venta.setTipoDocumento(rs.getString("tipo_documento"));
        venta.setCantidadVendida(rs.getInt("cantidad_vendida"));
        venta.setPrecioUnitario(rs.getDouble("precio_unitario"));
        venta.setTotal(rs.getDouble("total"));
        venta.setFecha(rs.getTimestamp("fecha"));
        venta.setEstado(rs.getString("estado"));
        return venta;
    }

    // Método de compatibilidad para código existente - retorna void
    public void insertarVenta(Venta venta) {
        // Asegurar que el estado esté definido
        if (venta.getEstado() == null || venta.getEstado().isEmpty()) {
            venta.setEstado("COMPLETADA");
        }
        // Llamar al nuevo método que retorna boolean
        registrarVenta(venta);
    }
}
