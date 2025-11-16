<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.example.modelo.Venta" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Ventas - Cosméticos Mercy</title>
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Lista de Ventas</h2>
            <a href="${pageContext.request.contextPath}/ventas/nuevo" class="btn btn-primary">Nueva Venta</a>
        </div>

        <%-- Mensaje de éxito/error --%>
        <% if (request.getAttribute("mensaje") != null) { %>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <%= request.getAttribute("mensaje") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <table class="table table-striped">
            <thead>
                <tr>
                    <th>ID Venta</th>
                    <th>Código Producto</th>
                    <th>Cantidad</th>
                    <th>Total</th>
                    <th>Fecha Venta</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% List<Venta> ventas = (List<Venta>) request.getAttribute("ventas");
                   if (ventas != null) {
                       for (Venta v : ventas) { %>
                    <tr>
                        <td><%= v.getIdVenta() %></td>
                        <td><%= v.getCodigoProducto() %></td>
                        <td><%= v.getCantidadVendida() %></td>
                        <td>₡<%= v.getTotal() %></td>
                        <td><%= v.getFechaVenta() %></td>
                        <td>
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/ventas/editar/<%= v.getIdVenta() %>"
                                   class="btn btn-sm btn-primary">Editar</a>
                                <button type="button"
                                        class="btn btn-sm btn-danger ms-1"
                                        onclick="confirmarEliminar(<%= v.getIdVenta() %>)">
                                    Eliminar
                                </button>
                            </div>
                        </td>
                    </tr>
                <%     }
                   } %>
            </tbody>
        </table>
    </div>

    <!-- Modal de confirmación para eliminar -->
    <div class="modal fade" id="confirmarEliminarModal" tabindex="-1" aria-labelledby="confirmarEliminarModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmarEliminarModalLabel">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    ¿Está seguro que desea eliminar esta venta?
                </div>
                <div class="modal-footer">
                    <form id="formEliminar" action="${pageContext.request.contextPath}/ventas" method="post">
                        <input type="hidden" name="_method" value="DELETE">
                        <input type="hidden" name="idVenta" id="idVentaEliminar">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-danger">Eliminar</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Modal para confirmar eliminación
        function confirmarEliminar(idVenta) {
            document.getElementById('idVentaEliminar').value = idVenta;
            var modal = new bootstrap.Modal(document.getElementById('confirmarEliminarModal'));
            modal.show();
        }
    </script>
</body>
</html>
