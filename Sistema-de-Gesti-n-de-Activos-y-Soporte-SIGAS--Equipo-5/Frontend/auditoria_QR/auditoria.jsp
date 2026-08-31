<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGAS - Auditoría QR</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <link rel="stylesheet" href="auditoria.css">
</head>
<body style="overflow-y: scroll; background-color: #f8fafc;">
    <div class="container-fluid p-0">
        <div class="d-flex">
            <div class="sidebar d-flex flex-column p-0">
                <h4 class="text-center mb-4 text-white fw-bold mt-3"><i class="bi bi-layers"></i> Admin Panel</h4>
                
                <a href="../dashboard_administrador/dashboard.html"><i class="bi bi-grid-1x2"></i> Inicio</a>
                
                <div class="px-3 py-2 text-muted small fw-bold mt-2" style="font-size: 0.7rem; letter-spacing: 1px;">INFRAESTRUCTURA</div>
                <a href="../mapa_rack/racks.jsp"><i class="bi bi-hdd-rack"></i> Gestión de Racks</a>
                <a href="../gestion_inventario/inventario.jsp"><i class="bi bi-pc-display"></i> Catálogo de Equipos</a>
                <a href="../gestion_inventario/materiales.jsp"><i class="bi bi-box-seam"></i> Catálogo de Materiales</a>
                
                <div class="px-3 py-2 text-muted small fw-bold mt-2" style="font-size: 0.7rem; letter-spacing: 1px;">OPERACIONES</div>
                <a href="auditoria.jsp" class="active"><i class="bi bi-qr-code-scan"></i> Auditoría QR</a>
                <a href="../prestamos_devoluciones/devoluciones.html"><i class="bi bi-arrow-left-right"></i> Préstamos y Devoluciones</a>
                <a href="../reportes/reportes.html"><i class="bi bi-file-earmark-medical"></i> Reportes</a>
                
                <div class="px-3 py-2 text-muted small fw-bold mt-2" style="font-size: 0.7rem; letter-spacing: 1px;">SISTEMA</div>
                <a href="../gestion_usuarios/usuarios.jsp"><i class="bi bi-people"></i> Usuarios</a>
                
                <div class="mt-auto mb-4">
                    <a href="<%= request.getContextPath() %>/Logout"><i class="bi bi-box-arrow-left"></i> Cerrar Sesión</a>
                </div>
            </div>

            <div class="main-content flex-grow-1 p-4 text-center">
                <h2 class="fw-bold mb-1">Auditoría de Inventario mediante QR</h2>
                <p class="text-muted mb-4">Simula el escaneo del código para verificar su presencia física en el laboratorio.</p>

                <div class="scanner-container mx-auto" style="max-width: 600px;">
                    <div class="card border-0 shadow-sm p-4">
                        <h5 class="fw-bold mb-3">Auditoría en Tiempo Real</h5>
                        
                        <div class="camera-view mb-4 position-relative rounded-3 bg-dark d-flex align-items-center justify-content-center text-white" style="height: 300px; overflow: hidden;">
                            <div class="scan-overlay"></div>
                            <div class="text-center opacity-50">
                                <i class="bi bi-camera-fill fs-1 mb-2"></i>
                                <p class="mb-0 small">Simulador de Cámara Activo...</p>
                            </div>
                        </div>

                        <% if(request.getParameter("auditoria") != null) { %>
                            <div class="alert alert-success d-flex align-items-center justify-content-center py-2 mb-3" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>
                                <div>¡Equipo <b><%= request.getParameter("qr") %></b> auditado hoy!</div>
                            </div>
                        <% } %>
                        <% if(request.getParameter("error") != null) { %>
                            <div class="alert alert-danger d-flex align-items-center justify-content-center py-2 mb-3" role="alert">
                                <i class="bi bi-x-circle-fill me-2"></i>
                                <div>Error: El código no existe en la base de datos.</div>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/AuditoriaQR" method="POST">
                            <div class="mb-3 text-start">
                                <label class="form-label small fw-bold text-muted">ID DEL EQUIPO DETECTADO</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="bi bi-qr-code"></i></span>
                                    <input type="text" name="id_qr" class="form-control text-center py-2 fw-bold" placeholder="Ej. QR-10044" required autofocus>
                                    <button type="submit" class="btn btn-primary fw-bold px-4">Procesar</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>