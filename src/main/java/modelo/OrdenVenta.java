package modelo;

import java.util.Date;

public class OrdenVenta {
    private int idOrdenCompra;
    private int idProveedor;
    private String nombreProveedor; // Para mostrar en vistas
    private int idProducto;
    private String nombreProducto; // Para mostrar en vistas
    private int cantidadSolicitada;
    private double precioUnitario;
    private double total;
    private String estado;
    private Date fechaOrden;
    private Date fechaEntregaEsperada;
    private String observaciones;
    private String numeroOrden;
    
    // Constructores
    public OrdenVenta() {
        this.estado = "PENDIENTE";
        this.fechaOrden = new Date();
    }
    
    public OrdenVenta(int idProveedor, int idProducto, int cantidadSolicitada, 
                      double precioUnitario, Date fechaEntregaEsperada, String observaciones) {
        this.idProveedor = idProveedor;
        this.idProducto = idProducto;
        this.cantidadSolicitada = cantidadSolicitada;
        this.precioUnitario = precioUnitario;
        this.total = cantidadSolicitada * precioUnitario;
        this.fechaEntregaEsperada = fechaEntregaEsperada;
        this.observaciones = observaciones;
        this.estado = "PENDIENTE";
        this.fechaOrden = new Date();
        // Generar número de orden automático
        this.numeroOrden = "OC-" + System.currentTimeMillis();
    }
    
    // Getters y Setters
    public int getIdOrdenVenta() { return idOrdenCompra; }
    public void setIdOrdenVenta(int idOrdenCompra) { this.idOrdenCompra = idOrdenCompra; }
    
    public int getIdOrdenCompra() { return idOrdenCompra; }
    public void setIdOrdenCompra(int idOrdenCompra) { this.idOrdenCompra = idOrdenCompra; }
    
    public int getIdProveedor() { return idProveedor; }
    public void setIdProveedor(int idProveedor) { this.idProveedor = idProveedor; }
    
    public String getNombreProveedor() { return nombreProveedor; }
    public void setNombreProveedor(String nombreProveedor) { this.nombreProveedor = nombreProveedor; }
    
    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }
    
    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }
    
    public int getCantidadSolicitada() { return cantidadSolicitada; }
    public void setCantidadSolicitada(int cantidadSolicitada) { 
        this.cantidadSolicitada = cantidadSolicitada;
        this.total = cantidadSolicitada * precioUnitario; // Recalcular total
    }
    
    public double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(double precioUnitario) { 
        this.precioUnitario = precioUnitario;
        this.total = cantidadSolicitada * precioUnitario; // Recalcular total
    }
    
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public Date getFechaOrden() { return fechaOrden; }
    public void setFechaOrden(Date fechaOrden) { this.fechaOrden = fechaOrden; }
    
    public Date getFechaEntregaEsperada() { return fechaEntregaEsperada; }
    public void setFechaEntregaEsperada(Date fechaEntregaEsperada) { this.fechaEntregaEsperada = fechaEntregaEsperada; }
    
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
    
    public String getNumeroOrden() { return numeroOrden; }
    public void setNumeroOrden(String numeroOrden) { this.numeroOrden = numeroOrden; }
}
