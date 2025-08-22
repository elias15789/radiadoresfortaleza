package modelo.dao;

import modelo.OrdenVenta;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrdenVentaDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/sys_radiadores_fort";
    private final String jdbcUser = "root";
    private final String jdbcPassword = "";

    
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUser, jdbcPassword);
    }
    
    // Crear orden de compra
    public boolean crearOrdenVenta(OrdenVenta orden) {
        String sql = "INSERT INTO ordenes_compra (id_proveedor, idproductos, cantidad, precio_unitario, total, estado, fecha_orden, observaciones, numero_orden) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orden.getIdProveedor());
            ps.setInt(2, orden.getIdProducto());
            ps.setInt(3, orden.getCantidadSolicitada());
            ps.setDouble(4, orden.getPrecioUnitario());
            ps.setDouble(5, orden.getTotal());
            ps.setString(6, orden.getEstado());
            ps.setTimestamp(7, new Timestamp(orden.getFechaOrden().getTime()));
            ps.setString(8, orden.getObservaciones());
            ps.setString(9, orden.getNumeroOrden());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Obtener todas las órdenes de compra con información de proveedor y producto
    public List<OrdenVenta> obtenerOrdenesVenta() {
        List<OrdenVenta> ordenes = new ArrayList<>();
        String sql = "SELECT oc.*, p.nombre as nombre_proveedor, pr.nombre as nombre_producto " +
                    "FROM ordenes_compra oc " +
                    "LEFT JOIN proveedores p ON oc.id_proveedor = p.id_proveedor " +
                    "LEFT JOIN productos pr ON oc.idproductos = pr.idproductos " +
                    "ORDER BY oc.fecha_orden DESC";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                OrdenVenta orden = new OrdenVenta();
                orden.setIdOrdenVenta(rs.getInt("id_orden_compra"));
                orden.setIdProveedor(rs.getInt("id_proveedor"));
                orden.setNombreProveedor(rs.getString("nombre_proveedor"));
                orden.setIdProducto(rs.getInt("idproductos"));
                orden.setNombreProducto(rs.getString("nombre_producto"));
                orden.setCantidadSolicitada(rs.getInt("cantidad"));
                orden.setPrecioUnitario(rs.getDouble("precio_unitario"));
                orden.setTotal(rs.getDouble("total"));
                orden.setEstado(rs.getString("estado"));
                orden.setFechaOrden(rs.getTimestamp("fecha_orden"));
                orden.setObservaciones(rs.getString("observaciones"));
                orden.setNumeroOrden(rs.getString("numero_orden"));
                
                ordenes.add(orden);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return ordenes;
    }
    
    // Obtener orden por ID
    public OrdenVenta obtenerOrdenPorId(int id) {
        String sql = "SELECT oc.*, p.nombre as nombre_proveedor, pr.nombre as nombre_producto " +
                    "FROM ordenes_compra oc " +
                    "LEFT JOIN proveedores p ON oc.id_proveedor = p.id_proveedor " +
                    "LEFT JOIN productos pr ON oc.idproductos = pr.idproductos " +
                    "WHERE oc.id_orden_compra = ?";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OrdenVenta orden = new OrdenVenta();
                    orden.setIdOrdenVenta(rs.getInt("id_orden_compra"));
                    orden.setIdProveedor(rs.getInt("id_proveedor"));
                    orden.setNombreProveedor(rs.getString("nombre_proveedor"));
                    orden.setIdProducto(rs.getInt("idproductos"));
                    orden.setNombreProducto(rs.getString("nombre_producto"));
                    orden.setCantidadSolicitada(rs.getInt("cantidad"));
                    orden.setPrecioUnitario(rs.getDouble("precio_unitario"));
                    orden.setTotal(rs.getDouble("total"));
                    orden.setEstado(rs.getString("estado"));
                    orden.setFechaOrden(rs.getTimestamp("fecha_orden"));
                    orden.setObservaciones(rs.getString("observaciones"));
                    orden.setNumeroOrden(rs.getString("numero_orden"));
                    
                    return orden;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Actualizar orden de compra
    public boolean actualizarOrdenVenta(OrdenVenta orden) {
        String sql = "UPDATE ordenes_compra SET id_proveedor = ?, idproductos = ?, cantidad = ?, precio_unitario = ?, total = ?, estado = ?, observaciones = ? WHERE id_orden_compra = ?";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orden.getIdProveedor());
            ps.setInt(2, orden.getIdProducto());
            ps.setInt(3, orden.getCantidadSolicitada());
            ps.setDouble(4, orden.getPrecioUnitario());
            ps.setDouble(5, orden.getTotal());
            ps.setString(6, orden.getEstado());
            ps.setString(7, orden.getObservaciones());
            ps.setInt(8, orden.getIdOrdenVenta());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Cambiar estado de la orden
    public boolean cambiarEstadoOrden(int id, String nuevoEstado) {
        String sql = "UPDATE ordenes_compra SET estado = ? WHERE id_orden_compra = ?";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Obtener órdenes por estado
    public List<OrdenVenta> obtenerOrdenesPorEstado(String estado) {
        List<OrdenVenta> ordenes = new ArrayList<>();
        String sql = "SELECT oc.*, p.nombre as nombre_proveedor, pr.nombre as nombre_producto " +
                    "FROM ordenes_compra oc " +
                    "LEFT JOIN proveedores p ON oc.id_proveedor = p.id_proveedor " +
                    "LEFT JOIN productos pr ON oc.idproductos = pr.idproductos " +
                    "WHERE oc.estado = ? " +
                    "ORDER BY oc.fecha_orden DESC";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, estado);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrdenVenta orden = new OrdenVenta();
                    orden.setIdOrdenVenta(rs.getInt("id_orden_compra"));
                    orden.setIdProveedor(rs.getInt("id_proveedor"));
                    orden.setNombreProveedor(rs.getString("nombre_proveedor"));
                    orden.setIdProducto(rs.getInt("idproductos"));
                    orden.setNombreProducto(rs.getString("nombre_producto"));
                    orden.setCantidadSolicitada(rs.getInt("cantidad"));
                    orden.setPrecioUnitario(rs.getDouble("precio_unitario"));
                    orden.setTotal(rs.getDouble("total"));
                    orden.setEstado(rs.getString("estado"));
                    orden.setFechaOrden(rs.getTimestamp("fecha_orden"));
                    orden.setObservaciones(rs.getString("observaciones"));
                    orden.setNumeroOrden(rs.getString("numero_orden"));
                    
                    ordenes.add(orden);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return ordenes;
    }
    
    // Obtener órdenes recientes (últimas 10)
    public List<OrdenVenta> obtenerOrdenesRecientes() {
        List<OrdenVenta> ordenes = new ArrayList<>();
        String sql = "SELECT oc.*, p.nombre as nombre_proveedor, pr.nombre as nombre_producto " +
                    "FROM ordenes_compra oc " +
                    "LEFT JOIN proveedores p ON oc.id_proveedor = p.id_proveedor " +
                    "LEFT JOIN productos pr ON oc.idproductos = pr.idproductos " +
                    "ORDER BY oc.fecha_orden DESC LIMIT 10";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                OrdenVenta orden = new OrdenVenta();
                orden.setIdOrdenVenta(rs.getInt("id_orden_compra"));
                orden.setIdProveedor(rs.getInt("id_proveedor"));
                orden.setNombreProveedor(rs.getString("nombre_proveedor"));
                orden.setIdProducto(rs.getInt("idproductos"));
                orden.setNombreProducto(rs.getString("nombre_producto"));
                orden.setCantidadSolicitada(rs.getInt("cantidad"));
                orden.setPrecioUnitario(rs.getDouble("precio_unitario"));
                orden.setTotal(rs.getDouble("total"));
                orden.setEstado(rs.getString("estado"));
                orden.setFechaOrden(rs.getTimestamp("fecha_orden"));
                orden.setObservaciones(rs.getString("observaciones"));
                orden.setNumeroOrden(rs.getString("numero_orden"));
                
                ordenes.add(orden);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return ordenes;
    }
    
    // Eliminar orden de compra
    public boolean eliminarOrden(int id) {
        String sql = "DELETE FROM ordenes_compra WHERE id_orden_compra = ?";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}