package modelo.dao;

import modelo.Proveedor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProveedorDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/sys_radiadores_fort";
    private final String jdbcUser = "root";
    private final String jdbcPassword = "";
    
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUser, jdbcPassword);
    }
    
    // Crear proveedor
    public boolean crearProveedor(Proveedor proveedor) {
        String sql = "INSERT INTO proveedores (nombre, ruc, razon_social, telefono, email, direccion, contacto, estado, fecha_registro) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, proveedor.getNombre());
            ps.setString(2, proveedor.getRuc());
            ps.setString(3, proveedor.getRazonSocial());
            ps.setString(4, proveedor.getTelefono());
            ps.setString(5, proveedor.getEmail());
            ps.setString(6, proveedor.getDireccion());
            ps.setString(7, proveedor.getContacto());
            ps.setString(8, proveedor.getEstado());
            ps.setTimestamp(9, new Timestamp(proveedor.getFechaRegistro().getTime()));
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Obtener todos los proveedores
    public List<Proveedor> obtenerProveedores() {
        List<Proveedor> proveedores = new ArrayList<>();
        String sql = "SELECT * FROM proveedores ORDER BY fecha_registro DESC";
        
        try (Connection con = getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Proveedor proveedor = new Proveedor();
                proveedor.setIdProveedor(rs.getInt("id_proveedor"));
                proveedor.setNombre(rs.getString("nombre"));
                proveedor.setRuc(rs.getString("ruc"));
                proveedor.setRazonSocial(rs.getString("razon_social"));
                proveedor.setTelefono(rs.getString("telefono"));
                proveedor.setEmail(rs.getString("email"));
                proveedor.setDireccion(rs.getString("direccion"));
                proveedor.setContacto(rs.getString("contacto"));
                proveedor.setEstado(rs.getString("estado"));
                proveedor.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                
                proveedores.add(proveedor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return proveedores;
    }
    
    // Obtener proveedor por ID
    public Proveedor obtenerProveedorPorId(int id) {
        String sql = "SELECT * FROM proveedores WHERE id_proveedor = ?";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Proveedor proveedor = new Proveedor();
                    proveedor.setIdProveedor(rs.getInt("id_proveedor"));
                    proveedor.setNombre(rs.getString("nombre"));
                    proveedor.setRuc(rs.getString("ruc"));
                    proveedor.setRazonSocial(rs.getString("razon_social"));
                    proveedor.setTelefono(rs.getString("telefono"));
                    proveedor.setEmail(rs.getString("email"));
                    proveedor.setDireccion(rs.getString("direccion"));
                    proveedor.setContacto(rs.getString("contacto"));
                    proveedor.setEstado(rs.getString("estado"));
                    proveedor.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                    
                    return proveedor;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Buscar proveedor por nombre
    public Proveedor buscarProveedorPorNombre(String nombre) {
        String sql = "SELECT * FROM proveedores WHERE nombre LIKE ? AND estado = 'ACTIVO' LIMIT 1";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + nombre + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Proveedor proveedor = new Proveedor();
                    proveedor.setIdProveedor(rs.getInt("id_proveedor"));
                    proveedor.setNombre(rs.getString("nombre"));
                    proveedor.setRuc(rs.getString("ruc"));
                    proveedor.setRazonSocial(rs.getString("razon_social"));
                    proveedor.setTelefono(rs.getString("telefono"));
                    proveedor.setEmail(rs.getString("email"));
                    proveedor.setDireccion(rs.getString("direccion"));
                    proveedor.setContacto(rs.getString("contacto"));
                    proveedor.setEstado(rs.getString("estado"));
                    proveedor.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                    
                    return proveedor;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Actualizar proveedor
    public boolean actualizarProveedor(Proveedor proveedor) {
        String sql = "UPDATE proveedores SET nombre = ?, ruc = ?, razon_social = ?, telefono = ?, email = ?, direccion = ?, contacto = ?, estado = ? WHERE id_proveedor = ?";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, proveedor.getNombre());
            ps.setString(2, proveedor.getRuc());
            ps.setString(3, proveedor.getRazonSocial());
            ps.setString(4, proveedor.getTelefono());
            ps.setString(5, proveedor.getEmail());
            ps.setString(6, proveedor.getDireccion());
            ps.setString(7, proveedor.getContacto());
            ps.setString(8, proveedor.getEstado());
            ps.setInt(9, proveedor.getIdProveedor());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Eliminar proveedor (cambiar estado a INACTIVO)
    public boolean eliminarProveedor(int id) {
        String sql = "UPDATE proveedores SET estado = 'INACTIVO' WHERE id_proveedor = ?";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Obtener proveedores activos
    public List<Proveedor> obtenerProveedoresActivos() {
        List<Proveedor> proveedores = new ArrayList<>();
        String sql = "SELECT * FROM proveedores WHERE estado = 'ACTIVO' ORDER BY nombre";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Proveedor proveedor = new Proveedor();
                proveedor.setIdProveedor(rs.getInt("id_proveedor"));
                proveedor.setNombre(rs.getString("nombre"));
                proveedor.setRuc(rs.getString("ruc"));
                proveedor.setRazonSocial(rs.getString("razon_social"));
                proveedor.setTelefono(rs.getString("telefono"));
                proveedor.setEmail(rs.getString("email"));
                proveedor.setDireccion(rs.getString("direccion"));
                proveedor.setContacto(rs.getString("contacto"));
                proveedor.setEstado(rs.getString("estado"));
                proveedor.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                
                proveedores.add(proveedor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return proveedores;
    }
    
    // Cambiar estado de proveedor
    public boolean cambiarEstadoProveedor(int id, String nuevoEstado) {
        String sql = "UPDATE proveedores SET estado = ? WHERE id_proveedor = ?";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}