package org.example.controlador;

import org.example.modelo.Producto;
import org.example.servicios.ProductoServicio;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class ProductoControlador {
    private final ProductoServicio productoServicio;

    public ProductoControlador() {
        this.productoServicio = new ProductoServicio();
    }

    public boolean registrarProducto(String nombre, BigDecimal precio, int cantidad, String categoria, String descripcion) {
        try {
            Producto producto = new Producto();
            producto.setNombreProducto(nombre);
            producto.setPrecioUnitario(precio);
            producto.setCantidad(cantidad);
            producto.setCategoria(categoria);

            return productoServicio.crearProducto(producto);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Producto obtenerProducto(int codigo) {
        try {
            return productoServicio.obtenerProducto(codigo);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Producto> listarProductos() {
        try {
            return productoServicio.listarTodosLosProductos();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Producto> listarProductosPorCategoria(String categoria) {
        try {
            return productoServicio.listarProductosPorCategoria(categoria);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Producto> buscarProductos(String nombre) {
        try {
            return productoServicio.buscarProductos(nombre);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean actualizarProducto(Producto producto) {
        try {
            return productoServicio.actualizarProducto(producto);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarProducto(int codigo) {
        try {
            return productoServicio.eliminarProducto(codigo);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarInventario(int codigo, int cantidadCambio) {
        try {
            return productoServicio.actualizarInventario(codigo, cantidadCambio);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean verificarDisponibilidad(int codigo, int cantidadRequerida) {
        try {
            return productoServicio.verificarStock(codigo, cantidadRequerida);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Producto> listarTodosLosProductos() {
        try{
            return productoServicio.listarTodosLosProductos();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean crearProducto(Producto nuevoProducto) {
        try{
            return productoServicio.crearProducto(nuevoProducto);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
