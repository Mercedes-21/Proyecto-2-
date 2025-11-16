package org.example.serverlet;

import org.example.controlador.VentaControlador;
import org.example.controlador.ProductoControlador;
import org.example.modelo.Venta;
import org.example.modelo.Producto;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "VentaServerlet", urlPatterns = {"/ventas/*"})
public class VentaServerlet extends HttpServlet {
    private final VentaControlador ventaControlador;
    private final ProductoControlador productoControlador;

    public VentaServerlet() {
        this.ventaControlador = new VentaControlador();
        this.productoControlador = new ProductoControlador();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todas las ventas
                List<Venta> ventas = ventaControlador.listarVentas();
                request.setAttribute("ventas", ventas);
                request.getRequestDispatcher("/WEB-INF/views/ventas/lista.jsp").forward(request, response);
            } else if (pathInfo.equals("/nuevo")) {
                // Mostrar formulario de nueva venta
                List<Producto> productos = productoControlador.listarTodosLosProductos();
                request.setAttribute("productos", productos);
                request.setAttribute("now", LocalDate.now().toString());
                request.getRequestDispatcher("/WEB-INF/views/ventas/nuevo.jsp").forward(request, response);
            } else if (pathInfo.startsWith("/editar/")) {
                // Obtener venta para editar
                String idStr = pathInfo.substring("/editar/".length());
                if (idStr.trim().isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de venta no especificado");
                    return;
                }
                try {
                    int idVenta = Integer.parseInt(idStr.trim());
                    Venta venta = ventaControlador.obtenerVenta(idVenta);
                    if (venta == null) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Venta no encontrada");
                        return;
                    }
                    List<Producto> productos = productoControlador.listarTodosLosProductos();
                    request.setAttribute("productos", productos);
                    request.setAttribute("venta", venta);
                    request.getRequestDispatcher("/WEB-INF/views/ventas/editar.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de venta inválido");
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la solicitud");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("_method");
            if ("PUT".equals(action)) {
                handleEdit(request, response);
            } else if ("DELETE".equals(action)) {
                handleDelete(request, response);
            } else {
                handleCreate(request, response);
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la solicitud");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String codigoProductoStr = request.getParameter("codigoProducto");
        String cantidadStr = request.getParameter("cantidad");
        String fechaVentaStr = request.getParameter("fechaVenta");

        if (codigoProductoStr == null || codigoProductoStr.trim().isEmpty() ||
            cantidadStr == null || cantidadStr.trim().isEmpty() ||
            fechaVentaStr == null || fechaVentaStr.trim().isEmpty()) {

            request.setAttribute("error", "Todos los campos son requeridos");
            List<Producto> productos = productoControlador.listarTodosLosProductos();
            request.setAttribute("productos", productos);
            request.setAttribute("now", LocalDate.now().toString());
            request.getRequestDispatcher("/WEB-INF/views/ventas/nuevo.jsp").forward(request, response);
            return;
        }

        try {
            int codigoProducto = Integer.parseInt(codigoProductoStr);
            int cantidad = Integer.parseInt(cantidadStr);
            LocalDate fechaVenta = LocalDate.parse(fechaVentaStr);

            // Verificar stock disponible
            Producto producto = productoControlador.obtenerProducto(codigoProducto);
            if (producto == null || producto.getCantidad() < cantidad) {
                request.setAttribute("error", "No hay suficiente stock disponible");
                List<Producto> productos = productoControlador.listarTodosLosProductos();
                request.setAttribute("productos", productos);
                request.setAttribute("now", LocalDate.now().toString());
                request.getRequestDispatcher("/WEB-INF/views/ventas/nuevo.jsp").forward(request, response);
                return;
            }

            boolean resultado = ventaControlador.registrarVenta(codigoProducto, cantidad, fechaVenta);

            if (resultado) {
                response.sendRedirect(request.getContextPath() + "/ventas");
            } else {
                request.setAttribute("error", "Error al registrar la venta");
                List<Producto> productos = productoControlador.listarTodosLosProductos();
                request.setAttribute("productos", productos);
                request.setAttribute("now", LocalDate.now().toString());
                request.getRequestDispatcher("/WEB-INF/views/ventas/nuevo.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Los valores ingresados no son válidos");
            List<Producto> productos = productoControlador.listarTodosLosProductos();
            request.setAttribute("productos", productos);
            request.setAttribute("now", LocalDate.now().toString());
            request.getRequestDispatcher("/WEB-INF/views/ventas/nuevo.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            List<Producto> productos = productoControlador.listarTodosLosProductos();
            request.setAttribute("productos", productos);
            request.setAttribute("now", LocalDate.now().toString());
            request.getRequestDispatcher("/WEB-INF/views/ventas/nuevo.jsp").forward(request, response);
        }
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idVentaStr = request.getParameter("idVenta");
            String codigoProductoStr = request.getParameter("codigoProducto");
            String cantidadStr = request.getParameter("cantidad");
            String fechaVentaStr = request.getParameter("fechaVenta");

            if (idVentaStr == null || idVentaStr.trim().isEmpty() ||
                codigoProductoStr == null || codigoProductoStr.trim().isEmpty() ||
                cantidadStr == null || cantidadStr.trim().isEmpty() ||
                fechaVentaStr == null || fechaVentaStr.trim().isEmpty()) {

                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Todos los campos son requeridos");
                return;
            }

            int idVenta = Integer.parseInt(idVentaStr);
            int codigoProducto = Integer.parseInt(codigoProductoStr);
            int cantidad = Integer.parseInt(cantidadStr);
            LocalDate fechaVenta = LocalDate.parse(fechaVentaStr);

            // Verificar stock disponible
            Producto producto = productoControlador.obtenerProducto(codigoProducto);
            Venta ventaActual = ventaControlador.obtenerVenta(idVenta);

            if (producto == null ||
                (cantidad > ventaActual.getCantidadVendida() &&
                 producto.getCantidad() < (cantidad - ventaActual.getCantidadVendida()))) {
                request.setAttribute("error", "No hay suficiente stock disponible");
                request.setAttribute("venta", ventaActual);
                List<Producto> productos = productoControlador.listarTodosLosProductos();
                request.setAttribute("productos", productos);
                request.getRequestDispatcher("/WEB-INF/views/ventas/editar.jsp").forward(request, response);
                return;
            }

            Venta venta = new Venta();
            venta.setIdVenta(idVenta);
            venta.setCodigoProducto(codigoProducto);
            venta.setCantidadVendida(cantidad);
            venta.setFechaVenta(fechaVenta);
            BigDecimal total = BigDecimal.ZERO;
            // El total se calculará en el servicio

            boolean resultado = ventaControlador.actualizarVenta(idVenta, codigoProducto, cantidad, fechaVenta, total);

            if (resultado) {
                response.sendRedirect(request.getContextPath() + "/ventas");
            } else {
                request.setAttribute("error", "Error al actualizar la venta");
                request.setAttribute("venta", venta);
                List<Producto> productos = productoControlador.listarTodosLosProductos();
                request.setAttribute("productos", productos);
                request.getRequestDispatcher("/WEB-INF/views/ventas/editar.jsp").forward(request, response);
            }
        } catch ( IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idVentaStr = request.getParameter("idVenta");
            if (idVentaStr == null || idVentaStr.trim().isEmpty()) {
                request.setAttribute("mensaje", "Error: ID de venta no especificado");
                doGet(request, response);
                return;
            }

            int idVenta = Integer.parseInt(idVentaStr);
            boolean resultado = ventaControlador.eliminarVenta(idVenta);

            if (resultado) {
                request.setAttribute("mensaje", "Venta eliminada correctamente");
            } else {
                request.setAttribute("mensaje", "Error al eliminar la venta");
            }

            doGet(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "Error: ID de venta inválido");
            doGet(request, response);
        }
    }
}
