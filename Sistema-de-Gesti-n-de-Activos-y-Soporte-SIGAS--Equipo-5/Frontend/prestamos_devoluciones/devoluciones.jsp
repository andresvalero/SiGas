<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGAS - Préstamos y Devoluciones</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="devoluciones.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <div class="container-fluid p-0">
        <div class="d-flex">
            <div class="sidebar d-flex flex-column p-0">
                <h4 class="text-center mb-4 text-white fw-bold mt-3"><i class="bi bi-layers"></i> Admin Panel</h4>
                <a href="../dashboard_administrador/dashboard.html"><i class="bi bi-grid-1x2"></i> Inicio</a>
                <div class="px-3 py-2 text-muted small fw-bold mt-2">INFRAESTRUCTURA</div>
                <a href="../mapa_rack/racks.jsp"><i class="bi bi-hdd-rack"></i> Gestión de Racks</a>
                <a href="../gestion_inventario/inventario.jsp"><i class="bi bi-pc-display"></i> Catálogo de Equipos</a>
                <a href="../gestion_inventario/materiales.jsp"><i class="bi bi-box-seam"></i> Catálogo de Materiales</a>
                <div class="px-3 py-2 text-muted small fw-bold mt-2">OPERACIONES</div>
                <a href="../auditoria_QR/auditoria.jsp"><i class="bi bi-qr-code-scan"></i> Auditoría QR</a>
                <a href="devoluciones.jsp" class="active"><i class="bi bi-arrow-left-right"></i> Préstamos y Devoluciones</a>
                <a href="../reportes/reportes.jsp"><i class="bi bi-file-earmark-medical"></i> Reportes</a>
                <div class="px-3 py-2 text-muted small fw-bold mt-2">SISTEMA</div>
                <a href="../gestion_usuarios/usuarios.jsp"><i class="bi bi-people"></i> Usuarios</a>
                <div class="mt-auto mb-4"><a href="<%= request.getContextPath() %>/Logout"><i class="bi bi-box-arrow-left"></i> Cerrar Sesión</a></div>
            </div>

            <div class="main-content flex-grow-1 p-4 bg-light">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold mb-0">Gestión de Préstamos</h2>
                        <p class="text-muted">Control de salidas y retornos de equipo del laboratorio.</p>
                    </div>
                    <button class="btn btn-primary px-4 fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#modalPrestamo">
                        <i class="bi bi-plus-lg me-2"></i>Nuevo Préstamo
                    </button>
                </div>

                <% if(request.getParameter("registro") != null) { %><div class="alert alert-success fw-bold"><i class="bi bi-check-circle me-2"></i>Préstamo autorizado.</div><% } %>
                <% if(request.getParameter("devolucion") != null) { %><div class="alert alert-primary fw-bold"><i class="bi bi-info-circle me-2"></i>Equipo devuelto correctamente.</div><% } %>
                <% if(request.getParameter("reporte") != null) { %><div class="alert alert-danger fw-bold"><i class="bi bi-tools me-2"></i>Equipo enviado a mantenimiento.</div><% } %>

                <div class="card border-0 shadow-sm p-4 mx-auto mb-4">
                    <form action="devoluciones.jsp" method="GET" class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" name="buscar_qr" class="form-control border-start-0 py-2" placeholder="Escanea el QR del equipo para devolverlo rápido" required>
                        <button type="submit" class="btn btn-dark px-4 fw-bold">Buscar</button>
                    </form>

                    <%
                        String qrBusqueda = request.getParameter("buscar_qr");
                        if(qrBusqueda != null && !qrBusqueda.trim().isEmpty()) {
                            qrBusqueda = qrBusqueda.trim();
                            boolean encontrado = false;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
                                String sql = "SELECT p.ID_Prestamo, u.Nombre_Completo, u.Rol, e.Modelo FROM PRESTAMO p JOIN USUARIO u ON p.Matricula_ID = u.Matricula_ID JOIN EQUIPO e ON p.ID_Equipo_QR = e.ID_Equipo_QR WHERE p.ID_Equipo_QR = ? AND p.Estado_Prestamo = 'Activo'";
                                PreparedStatement ps = conn.prepareStatement(sql);
                                ps.setString(1, qrBusqueda);
                                ResultSet rs = ps.executeQuery();
                                
                                if(rs.next()) {
                                    encontrado = true;
                                    int idPrestamoActivo = rs.getInt("ID_Prestamo");
                    %>
                                    <div class="text-center mt-4">
                                        <h6 class="text-success fw-bold mb-3"><i class="bi bi-record-circle-fill"></i> Préstamo Encontrado</h6>
                                        <div class="d-flex align-items-center justify-content-center bg-white border border-success rounded-4 p-3 shadow-sm mx-auto" style="max-width: 500px;">
                                            <i class="bi bi-person-badge fs-1 text-secondary me-3"></i>
                                            <div class="text-start">
                                                <p class="mb-0 fw-bold"><%= rs.getString("Rol") %>: <%= rs.getString("Nombre_Completo") %></p>
                                                <p class="mb-0 text-muted small">Equipo: <%= rs.getString("Modelo") %> (QR: <%= qrBusqueda %>)</p>
                                            </div>
                                        </div>
                                        
                                        <div class="row g-3 mt-3 mx-auto" style="max-width: 500px;">
                                            <div class="col-md-6">
                                                <a href="<%= request.getContextPath() %>/DevolverEquipo?id_prestamo=<%= idPrestamoActivo %>&id_equipo=<%= qrBusqueda %>" class="btn btn-success w-100 py-3 fw-bold rounded-3">
                                                    <i class="bi bi-check2-circle me-2"></i> Devolver Bien
                                                </a>
                                            </div>
                                            <div class="col-md-6">
                                                <button class="btn btn-danger w-100 py-3 fw-bold rounded-3" data-bs-toggle="modal" data-bs-target="#modalFalla">
                                                    <i class="bi bi-tools me-2"></i> Reportar Falla
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="modal fade" id="modalFalla" tabindex="-1">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <form action="<%= request.getContextPath() %>/ReportarFalla" method="POST" class="modal-content border-0 shadow">
                                                <div class="modal-header bg-light border-0">
                                                    <h5 class="modal-title fw-bold">Reportar Daño o Falla</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body p-4 text-start">
                                                    <input type="hidden" name="id_equipo" value="<%= qrBusqueda %>">
                                                    <input type="hidden" name="id_prestamo" value="<%= idPrestamoActivo %>">
                                                    
                                                    <label class="form-label small fw-bold text-muted">Describa el problema del equipo:</label>
                                                    <textarea name="descripcion" class="form-control bg-light border-0 mb-4" rows="4" placeholder="Ej. El lente está rayado..." required></textarea>
                                                    
                                                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold" style="background-color: #0b5361; border: none;">
                                                        Confirmar Falla y Enviar a Mantenimiento
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                    <%
                                }
                                rs.close(); ps.close(); conn.close();
                            } catch(Exception e) {}
                            if(!encontrado) {
                    %>
                                <div class="alert alert-warning text-center fw-bold mt-4 mb-0">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i> No se encontró préstamo activo para: <%= qrBusqueda %>
                                </div>
                    <%
                            }
                        }
                    %>
                </div>

                <div class="card border-0 shadow-sm p-4">
                    <h5 class="fw-bold mb-4"><i class="bi bi-list-task me-2"></i>Historial General</h5>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr><th>Folio</th><th>Usuario</th><th>Equipo (QR)</th><th>Fecha Salida</th><th>Estado</th><th>Acciones</th></tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
                                        String sqlTabla = "SELECT p.ID_Prestamo, u.Nombre_Completo, p.ID_Equipo_QR, p.Fecha_Salida, p.Estado_Prestamo FROM PRESTAMO p JOIN USUARIO u ON p.Matricula_ID = u.Matricula_ID ORDER BY p.ID_Prestamo DESC";
                                        Statement stmt = conn.createStatement();
                                        ResultSet rsT = stmt.executeQuery(sqlTabla);
                                        while(rsT.next()){
                                            boolean activo = rsT.getString("Estado_Prestamo").equals("Activo");
                                %>
                                <tr>
                                    <td class="fw-bold text-primary">#<%= rsT.getInt("ID_Prestamo") %></td>
                                    <td><%= rsT.getString("Nombre_Completo") %></td>
                                    <td><span class="badge bg-secondary"><i class="bi bi-qr-code"></i> <%= rsT.getString("ID_Equipo_QR") %></span></td>
                                    <td><%= rsT.getDate("Fecha_Salida") %></td>
                                    <td>
                                        <% if(activo) { %><span class="badge bg-warning text-dark px-3">En Préstamo</span>
                                        <% } else if(rsT.getString("Estado_Prestamo").contains("Falla")) { %><span class="badge bg-danger px-3">Falla</span>
                                        <% } else { %><span class="badge bg-success px-3">Devuelto</span><% } %>
                                    </td>
                                    <td>
                                        <% if(activo) { %>
                                            <a href="#" onclick="confirmarDevolucion('<%= request.getContextPath() %>/DevolverEquipo?id_prestamo=<%= rsT.getInt("ID_Prestamo") %>&id_equipo=<%= rsT.getString("ID_Equipo_QR") %>')" class="btn btn-sm btn-outline-success fw-bold">Devolver Bien</a>
                                        <% } else { %>
                                            <span class="text-muted small"><i class="bi bi-check2-all"></i> Cerrado</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } rsT.close(); stmt.close(); conn.close(); } catch(Exception e){} %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <div class="modal fade" id="modalPrestamo" tabindex="-1">
        <div class="modal-dialog">
            <form action="<%= request.getContextPath() %>/NuevoPrestamo" method="POST" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Registrar Salida de Equipo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">USUARIO</label>
                        <select class="form-select" name="matricula" required>
                            <option value="" disabled selected>Selecciona un alumno o docente...</option>
                            <% 
                                try {
                                    Connection c1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
                                    ResultSet rs1 = c1.createStatement().executeQuery("SELECT Matricula_ID, Nombre_Completo FROM USUARIO WHERE Estatus = 'Activo'");
                                    while(rs1.next()){ out.print("<option value='"+rs1.getString("Matricula_ID")+"'>"+rs1.getString("Nombre_Completo")+" ("+rs1.getString("Matricula_ID")+")</option>"); }
                                    c1.close();
                                } catch(Exception e){}
                            %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">EQUIPO A PRESTAR</label>
                        <select class="form-select" name="id_equipo" required>
                            <option value="" disabled selected>Selecciona el QR del equipo...</option>
                            <% 
                                try {
                                    Connection c2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
                                    ResultSet rs2 = c2.createStatement().executeQuery("SELECT ID_Equipo_QR, Modelo FROM EQUIPO WHERE Estado = 'Disponible'");
                                    while(rs2.next()){ out.print("<option value='"+rs2.getString("ID_Equipo_QR")+"'>"+rs2.getString("ID_Equipo_QR")+" - "+rs2.getString("Modelo")+"</option>"); }
                                    c2.close();
                                } catch(Exception e){}
                            %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">FECHA LÍMITE</label>
                        <input type="date" class="form-control" name="fecha_limite" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary w-100 fw-bold">Autorizar Préstamo</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmarDevolucion(url) {
            Swal.fire({ title: '¿Recibir equipo?', text: "El equipo regresará al inventario como Disponible.", icon: 'info', showCancelButton: true, confirmButtonColor: '#198754', confirmButtonText: 'Sí, recibir' }).then((result) => {
                if (result.isConfirmed) { window.location.href = url; }
            });
        }
    </script>
</body>
</html>