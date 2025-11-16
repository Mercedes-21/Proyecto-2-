<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.example.modelo.Producto" %>
<%@ page import="org.example.modelo.Venta" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Venta - Cosméticos Mercy</title>
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
        <h2>Detalle de Venta</h2>

        <div class="card">
            <div class="card-body">
                <h5 class="card-title">Venta #${venta.idVenta}</h5>
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Producto:</strong> ${venta.nombreProducto}</p>
                        <p><strong>Cantidad:</strong> ${venta.cantidad}</p>
                        <p><strong>Precio Unitario:</strong> ₡${venta.precioUnitario}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Fecha:</strong> ${venta.fechaVenta}</p>
                        <p><strong>Total:</strong> ₡${venta.total}</p>
                        <p><strong>Estado:</strong>
                            <span class="badge ${venta.estado eq 'ACTIVA' ? 'bg-success' : 'bg-warning'}">
                                ${venta.estado}
                            </span>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-4">
            <c:if test="${venta.estado eq 'ACTIVA'}">
                <button onclick="cancelarVenta(${venta.idVenta})" class="btn btn-warning">
                    Cancelar Venta
                </button>
            </c:if>
            <a href="${pageContext.request.contextPath}/ventas" class="btn btn-secondary">
                Volver a Lista
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function cancelarVenta(idVenta) {
            if (confirm('¿Está seguro de cancelar esta venta?')) {
                fetch('${pageContext.request.contextPath}/ventas/cancelar', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'idVenta=' + idVenta
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('Error al cancelar la venta');
                    }
                });
            }
        }
    </script>
</body>
</html>
