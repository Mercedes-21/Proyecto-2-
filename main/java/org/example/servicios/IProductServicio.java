package org.example.servicios;

import org.example.modelo.Producto;

import java.util.List;

public interface IProductServicio {
    public boolean crearProducto(Producto producto);
    public Producto obtenerProducto(int codigo);
    public List<Producto> listarTodosLosProductos();
    public List<Producto> listarProductosPorCategoria(String categoria);
    public List<Producto> buscarProductos(String nombre);
    public boolean actualizarProducto(Producto producto);
    public boolean eliminarProducto(int codigo);
    public boolean actualizarInventario(int codigo, int cantidadCambio);
    public boolean verificarStock(int codigo, int cantidadRequerida);
    public List<Producto> listarProductosDisponibles();
}
