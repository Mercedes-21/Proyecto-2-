<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.example.modelo.Producto" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Venta - Cosméticos Mercy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">Cosméticos Mercy</a>
            <div class="navbar-nav">
                <a class="nav-link" href="${pageContext.request.contextPath}/productos">Productos</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/ventas">Ventas</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h2>Nueva Venta</h2>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/ventas" method="post" class="needs-validation" novalidate>
            <div class="mb-3">
                <label for="codigoProducto" class="form-label">Producto</label>
                <select class="form-select" id="codigoProducto" name="codigoProducto" required>
                    <option value="">Seleccione un producto</option>
                    <% List<Producto> productos = (List<Producto>) request.getAttribute("productos");
                       if (productos != null) {
                           for (Producto p : productos) {
                               if (p.getCantidad() > 0) { %>
                        <option value="<%= p.getCodigoProducto() %>">
                            <%= p.getNombreProducto() %> - Precio: ₡<%= p.getPrecioUnitario() %>
                            - Stock: <%= p.getCantidad() %>
                        </option>
                    <%         }
                           }
                       } %>
                </select>
                <div class="invalid-feedback">
                    Por favor seleccione un producto.
                </div>
            </div>

            <div class="mb-3">
                <label for="cantidad" class="form-label">Cantidad</label>
                <input type="number" class="form-control" id="cantidad" name="cantidad"
                       min="1" required>
                <div class="invalid-feedback">
                    La cantidad debe ser mayor a 0.
                </div>
            </div>

            <div class="mb-3">
                <label for="fechaVenta" class="form-label">Fecha de Venta</label>
                <input type="date" class="form-control" id="fechaVenta" name="fechaVenta"
                       value="${now}" required>
                <div class="invalid-feedback">
                    Por favor seleccione una fecha válida.
                </div>
            </div>

            <button type="submit" class="btn btn-primary">Registrar Venta</button>
            <a href="${pageContext.request.contextPath}/ventas" class="btn btn-secondary">Cancelar</a>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms)
                .forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault()
                            event.stopPropagation()
                        }
                        form.classList.add('was-validated')
                    }, false)
                })
        })()
    </script>
</body>
</html>
