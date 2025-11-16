<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.example.modelo.Producto" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Producto - Cosméticos Mercy</title>
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
        <h2>Editar Producto</h2>

        <% Producto producto = (Producto) request.getAttribute("producto");
           if (producto != null) { %>

        <form action="${pageContext.request.contextPath}/productos" method="post" class="needs-validation" novalidate>
            <input type="hidden" name="_method" value="PUT">
            <input type="hidden" name="codigoProducto" value="<%= producto.getCodigoProducto() %>">

            <div class="mb-3">
                <label for="nombre" class="form-label">Nombre del Producto</label>
                <input type="text" class="form-control" id="nombre" name="nombre"
                       value="<%= producto.getNombreProducto() %>" required>
                <div class="invalid-feedback">
                    Por favor ingrese el nombre del producto.
                </div>
            </div>

            <div class="mb-3">
                <label for="precio" class="form-label">Precio Unitario (₡)</label>
                <input type="number" class="form-control" id="precio" name="precio"
                       value="<%= producto.getPrecioUnitario() %>"
                       step="0.01" min="0.01" required>
                <div class="invalid-feedback">
                    El precio debe ser mayor a 0.
                </div>
            </div>

            <div class="mb-3">
                <label for="cantidad" class="form-label">Cantidad</label>
                <input type="number" class="form-control" id="cantidad" name="cantidad"
                       value="<%= producto.getCantidad() %>"
                       min="0" required>
                <div class="invalid-feedback">
                    La cantidad no puede ser negativa.
                </div>
            </div>

            <div class="mb-3">
                <label for="categoria" class="form-label">Categoría</label>
                <select class="form-select" id="categoria" name="categoria" required>
                    <option value="">Seleccione una categoría</option>
                    <option value="Maquillaje" <%= "Maquillaje".equals(producto.getCategoria()) ? "selected" : "" %>>Maquillaje</option>
                    <option value="Skincare" <%= "Skincare".equals(producto.getCategoria()) ? "selected" : "" %>>Skincare</option>
                    <option value="Cabello" <%= "Cabello".equals(producto.getCategoria()) ? "selected" : "" %>>Cabello</option>
                    <option value="Fragancias" <%= "Fragancias".equals(producto.getCategoria()) ? "selected" : "" %>>Fragancias</option>
                    <option value="Cuidado Personal" <%= "Cuidado Personal".equals(producto.getCategoria()) ? "selected" : "" %>>Cuidado Personal</option>
                </select>
                <div class="invalid-feedback">
                    Por favor seleccione una categoría.
                </div>
            </div>

            <div class="mb-3">
                <label for="fechaIngreso" class="form-label">Fecha de Ingreso</label>
                <input type="date" class="form-control" id="fechaIngreso" name="fechaIngreso"
                       value="<%= producto.getFechaIngreso() %>" required>
                <div class="invalid-feedback">
                    Por favor seleccione una fecha válida.
                </div>
            </div>

            <button type="submit" class="btn btn-primary">Guardar Cambios</button>
            <a href="${pageContext.request.contextPath}/productos" class="btn btn-secondary">Cancelar</a>
        </form>

        <% } else { %>
            <div class="alert alert-danger" role="alert">
                No se encontró el producto solicitado.
            </div>
            <a href="${pageContext.request.contextPath}/productos" class="btn btn-primary">Volver a la lista</a>
        <% } %>
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
