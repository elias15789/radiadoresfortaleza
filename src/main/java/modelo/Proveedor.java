package modelo;

import java.util.Date;

public class Proveedor {
    private int idProveedor;
    private String nombre;
    private String ruc;
    private String razonSocial;
    private String telefono;
    private String email;
    private String direccion;
    private String contacto;
    private String estado;
    private Date fechaRegistro;
    
    // Constructores
    public Proveedor() {
        this.estado = "ACTIVO";
        this.fechaRegistro = new Date();
    }
    
    public Proveedor(String nombre, String ruc, String razonSocial, String telefono, 
                     String email, String direccion, String contacto) {
        this.nombre = nombre;
        this.ruc = ruc;
        this.razonSocial = razonSocial;
        this.telefono = telefono;
        this.email = email;
        this.direccion = direccion;
        this.contacto = contacto;
        this.estado = "ACTIVO";
        this.fechaRegistro = new Date();
    }
    
    // Getters y Setters
    public int getIdProveedor() { return idProveedor; }
    public void setIdProveedor(int idProveedor) { this.idProveedor = idProveedor; }
    
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    
    public String getRuc() { return ruc; }
    public void setRuc(String ruc) { this.ruc = ruc; }
    
    public String getRazonSocial() { return razonSocial; }
    public void setRazonSocial(String razonSocial) { this.razonSocial = razonSocial; }
    
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
    
    public String getContacto() { return contacto; }
    public void setContacto(String contacto) { this.contacto = contacto; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public Date getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(Date fechaRegistro) { this.fechaRegistro = fechaRegistro; }
}




