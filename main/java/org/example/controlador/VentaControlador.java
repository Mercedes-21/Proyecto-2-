package org.example.controlador;

import org.example.modelo.Venta;
import org.example.modelo.Producto;
import org.example.servicios.VentaServicio;
import org.example.servicios.ProductoServicio;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class VentaControlador {
    private final VentaServicio ventaServicio;
    private final ProductoServicio productoServicio;

    public VentaControlador() {
        this.ventaServicio = new VentaServicio();
        this.productoServicio = new ProductoServicio();
    }

    public boolean registrarVenta(Integer codigoProducto, Integer cantidad, LocalDate fechaVenta) {
        try {
            return ventaServicio.registrarVenta(codigoProducto, cantidad, fechaVenta);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Venta obtenerVenta(int idVenta) {
        try {
            return ventaServicio.obtenerVenta(idVenta);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Venta> listarVentas() {
        try {
            return ventaServicio.listarTodasLasVentas();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Venta> listarVentasPorProducto(int codigoProducto) {
        try {
            return ventaServicio.listarVentasPorProducto(codigoProducto);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean actualizarVenta(Integer idVenta, Integer codigoProducto, Integer cantidad,
                                 LocalDate fechaVenta, BigDecimal total) {
        try {
            Venta venta = new Venta(idVenta, codigoProducto, cantidad, fechaVenta, total);
            return ventaServicio.actualizarVenta(venta);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarVenta(int idVenta) {
        try {
            return ventaServicio.eliminarVenta(idVenta);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelarVenta(int idVenta) {
        try {
            return ventaServicio.cancelarVenta(idVenta);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Producto> listarProductosDisponibles() {
        try {
            return productoServicio.listarProductosDisponibles();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
