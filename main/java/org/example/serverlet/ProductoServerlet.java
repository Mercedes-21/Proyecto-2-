package org.example.serverlet;

import org.example.controlador.ProductoControlador;
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

@WebServlet(name = "ProductoServerlet", urlPatterns = {"/productos/*"})
public class ProductoServerlet extends HttpServlet {
    private final ProductoControlador productoControlador;

    public ProductoServerlet() {
        this.productoControlador = new ProductoControlador();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todos los productos
                List<Producto> productos = productoControlador.listarTodosLosProductos();
                request.setAttribute("productos", productos);
                request.getRequestDispatcher("/WEB-INF/views/productos/lista.jsp").forward(request, response);
            } else if (pathInfo.equals("/nuevo")) {
                // Mostrar formulario de nuevo producto
                request.setAttribute("now", LocalDate.now().toString());
                request.getRequestDispatcher("/WEB-INF/views/productos/nuevo.jsp").forward(request, response);
            } else if (pathInfo.startsWith("/editar/")) {
                // Obtener producto para editar
                String codigoStr = pathInfo.substring("/editar/".length());
                if (codigoStr.trim().isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Código de producto no especificado");
                    return;
                }
                try {
                    int codigo = Integer.parseInt(codigoStr.trim());
                    Producto producto = productoControlador.obtenerProducto(codigo);
                    if (producto == null) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Producto no encontrado");
                        return;
                    }
                    request.setAttribute("producto", producto);
                    request.getRequestDispatcher("/WEB-INF/views/productos/editar.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Código de producto inválido");
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
                // Es una actualización (editar)
                handleEdit(request, response);
            } else if ("DELETE".equals(action)) {
                // Es una eliminación
                handleDelete(request, response);
            } else {
                // Es una creación (nuevo)
                handleCreate(request, response);
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la solicitud");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Validar parámetros
        String nombre = request.getParameter("nombre");
        String precioStr = request.getParameter("precio");
        String cantidadStr = request.getParameter("cantidad");
        String categoria = request.getParameter("categoria");
        String fechaIngresoStr = request.getParameter("fechaIngreso");

        if (nombre == null || nombre.trim().isEmpty() ||
            precioStr == null || precioStr.trim().isEmpty() ||
            cantidadStr == null || cantidadStr.trim().isEmpty() ||
            categoria == null || categoria.trim().isEmpty() ||
            fechaIngresoStr == null || fechaIngresoStr.trim().isEmpty()) {

            request.setAttribute("error", "Todos los campos son requeridos");
            request.setAttribute("now", LocalDate.now().toString());
            request.getRequestDispatcher("/WEB-INF/views/productos/nuevo.jsp").forward(request, response);
            return;
        }

        try {
            BigDecimal precio = new BigDecimal(precioStr);
            int cantidad = Integer.parseInt(cantidadStr);
            LocalDate fechaIngreso = LocalDate.parse(fechaIngresoStr);

            if (precio.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("El precio debe ser mayor a 0");
            }
            if (cantidad < 0) {
                throw new IllegalArgumentException("La cantidad no puede ser negativa");
            }

            Producto nuevoProducto = new Producto();
            nuevoProducto.setNombreProducto(nombre);
            nuevoProducto.setPrecioUnitario(precio);
            nuevoProducto.setCantidad(cantidad);
            nuevoProducto.setCategoria(categoria);
            nuevoProducto.setFechaIngreso(fechaIngreso);

            boolean resultado = productoControlador.crearProducto(nuevoProducto);

            if (resultado) {
                response.sendRedirect(request.getContextPath() + "/productos");
            } else {
                request.setAttribute("error", "Error al crear el producto");
                request.setAttribute("now", LocalDate.now().toString());
                request.getRequestDispatcher("/WEB-INF/views/productos/nuevo.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "El precio y la cantidad deben ser números válidos");
            request.setAttribute("now", LocalDate.now().toString());
            request.getRequestDispatcher("/WEB-INF/views/productos/nuevo.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("now", LocalDate.now().toString());
            request.getRequestDispatcher("/WEB-INF/views/productos/nuevo.jsp").forward(request, response);
        }
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Obtener y validar parámetros
            String codigoStr = request.getParameter("codigoProducto");
            String nombre = request.getParameter("nombre");
            String precioStr = request.getParameter("precio");
            String cantidadStr = request.getParameter("cantidad");
            String categoria = request.getParameter("categoria");
            String fechaIngresoStr = request.getParameter("fechaIngreso");

            if (codigoStr == null || codigoStr.trim().isEmpty() ||
                nombre == null || nombre.trim().isEmpty() ||
                precioStr == null || precioStr.trim().isEmpty() ||
                cantidadStr == null || cantidadStr.trim().isEmpty() ||
                categoria == null || categoria.trim().isEmpty() ||
                fechaIngresoStr == null || fechaIngresoStr.trim().isEmpty()) {

                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Todos los campos son requeridos");
                return;
            }

            int codigo = Integer.parseInt(codigoStr);
            BigDecimal precio = new BigDecimal(precioStr);
            int cantidad = Integer.parseInt(cantidadStr);
            LocalDate fechaIngreso = LocalDate.parse(fechaIngresoStr);

            if (precio.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("El precio debe ser mayor a 0");
            }
            if (cantidad < 0) {
                throw new IllegalArgumentException("La cantidad no puede ser negativa");
            }

            Producto producto = new Producto();
            producto.setCodigoProducto(codigo);
            producto.setNombreProducto(nombre);
            producto.setPrecioUnitario(precio);
            producto.setCantidad(cantidad);
            producto.setCategoria(categoria);
            producto.setFechaIngreso(fechaIngreso);

            boolean resultado = productoControlador.actualizarProducto(producto);

            if (resultado) {
                response.sendRedirect(request.getContextPath() + "/productos");
            } else {
                request.setAttribute("error", "Error al actualizar el producto");
                request.setAttribute("producto", producto);
                request.getRequestDispatcher("/WEB-INF/views/productos/editar.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String codigoStr = request.getParameter("codigo");
            if (codigoStr == null || codigoStr.trim().isEmpty()) {
                request.setAttribute("mensaje", "Error: Código de producto no especificado");
                doGet(request, response);
                return;
            }

            int codigo = Integer.parseInt(codigoStr);
            boolean resultado = productoControlador.eliminarProducto(codigo);

            if (resultado) {
                request.setAttribute("mensaje", "Producto eliminado correctamente");
            } else {
                request.setAttribute("mensaje", "Error al eliminar el producto");
            }

            // Redirigir a la lista de productos
            doGet(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "Error: Código de producto inválido");
            doGet(request, response);
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/")) {
            try {
                int codigo = Integer.parseInt(pathInfo.substring(1));
                String nombre = request.getParameter("nombre");
                BigDecimal precio = new BigDecimal(request.getParameter("precio"));
                int cantidad = Integer.parseInt(request.getParameter("cantidad"));
                String categoria = request.getParameter("categoria");
                LocalDate fechaIngreso = LocalDate.parse(request.getParameter("fechaIngreso"));

                Producto producto = new Producto();
                producto.setCodigoProducto(codigo);
                producto.setNombreProducto(nombre);
                producto.setPrecioUnitario(precio);
                producto.setCantidad(cantidad);
                producto.setCategoria(categoria);
                producto.setFechaIngreso(fechaIngreso);

                boolean resultado = productoControlador.actualizarProducto(producto);

                response.setContentType("application/json");
                response.getWriter().write("{\"success\": " + resultado + "}");
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            }
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/")) {
            try {
                int codigo = Integer.parseInt(pathInfo.substring(1));
                boolean resultado = productoControlador.eliminarProducto(codigo);

                response.setContentType("application/json");
                response.getWriter().write("{\"success\": " + resultado + "}");
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            }
        }
    }
}
