package modelo;

import java.util.Date;

public class Venta {
    private int idVenta;
    private int idProducto;
    private String nombreProducto;  // Para mostrar en vistas
    private String nombreCliente;
    private String documentoCliente;
    private String tipoDocumento;
    private int cantidadVendida;
    private double precioUnitario;
    private double total;
    private Date fecha;
    private String estado;

    // Constructores
    public Venta() {}

    public Venta(int idProducto, String nombreCliente, String documentoCliente, String tipoDocumento, 
                 int cantidadVendida, double precioUnitario) {
        this.idProducto = idProducto;
        this.nombreCliente = nombreCliente;
        this.documentoCliente = documentoCliente;
        this.tipoDocumento = tipoDocumento;
        this.cantidadVendida = cantidadVendida;
        this.precioUnitario = precioUnitario;
        this.total = cantidadVendida * precioUnitario;
        this.estado = "COMPLETADA";
    }

    // Getters y Setters
    public int getIdVenta() { return idVenta; }
    public void setIdVenta(int idVenta) { this.idVenta = idVenta; }

    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }

    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }

    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }

    public String getDocumentoCliente() { return documentoCliente; }
    public void setDocumentoCliente(String documentoCliente) { this.documentoCliente = documentoCliente; }

    public String getTipoDocumento() { return tipoDocumento; }
    public void setTipoDocumento(String tipoDocumento) { this.tipoDocumento = tipoDocumento; }

    public int getCantidadVendida() { return cantidadVendida; }
    public void setCantidadVendida(int cantidadVendida) { 
        this.cantidadVendida = cantidadVendida; 
        this.total = cantidadVendida * precioUnitario; // Recalcular total
    }

    public double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(double precioUnitario) { 
        this.precioUnitario = precioUnitario; 
        this.total = cantidadVendida * precioUnitario; // Recalcular rreooer
    }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    // Método de compatibilidad para código existente
    public double getPrecioVenta() { return precioUnitario; }
    public void setPrecioVenta(double precio) { setPrecioUnitario(precio); }
}
