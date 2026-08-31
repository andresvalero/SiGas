<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGAS - Reportes</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="reportes.css">
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
                <a href="../prestamos_devoluciones/devoluciones.jsp"><i class="bi bi-arrow-left-right"></i> Préstamos y Devoluciones</a>
                <a href="reportes.jsp" class="active"><i class="bi bi-file-earmark-medical"></i> Reportes</a>
                
                <div class="px-3 py-2 text-muted small fw-bold mt-2">SISTEMA</div>
                <a href="../gestion_usuarios/usuarios.jsp"><i class="bi bi-people"></i> Usuarios</a>
                
                <div class="mt-auto mb-4">
                    <a href="<%= request.getContextPath() %>/Logout"><i class="bi bi-box-arrow-left"></i> Cerrar Sesión</a>
                </div>
            </div>

            <div class="main-content flex-grow-1 p-4 bg-light">
                <header class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold mb-0">Reportes de Fallas y Daños</h2>
                        <p class="text-muted">Equipos enviados a mantenimiento tras la devolución.</p>
                    </div>
                    <div class="d-flex gap-2">
                        <button class="btn btn-outline-secondary btn-sm" onclick="window.print()"><i class="bi bi-printer me-1"></i> Imprimir</button>
                    </div>
                </header>

                <% if(request.getParameter("resolucion") != null) { %>
                    <script>
                        document.addEventListener("DOMContentLoaded", function() {
                            Swal.fire({ title: '¡Reparación Completa!', text: 'El equipo ha sido marcado como Resuelto y devuelto al Inventario como Disponible.', icon: 'success', confirmButtonColor: '#0b5361' });
                        });
                    </script>
                <% } %>

                <div class="card border-0 shadow-sm overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-white border-bottom">
                                <tr>
                                    <th class="ps-4 py-3 text-muted small fw-bold">EQUIPO / SN</th>
                                    <th class="py-3 text-muted small fw-bold">REPORTADO POR</th>
                                    <th class="py-3 text-muted small fw-bold">FECHA REPORTE</th>
                                    <th class="py-3 text-muted small fw-bold">DESCRIPCIÓN DE FALLA</th>
                                    <th class="py-3 text-muted small fw-bold">ESTADO</th>
                                    <th class="py-3 text-end pe-4 text-muted small fw-bold">ACCIONES</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
                                        
                                        String sql = "SELECT r.ID_Reporte, r.Descripcion_Dano, r.Fecha_Reporte, r.Estado_Resolucion, r.ID_Equipo_QR, " +
                                                     "e.Modelo, u.Nombre_Completo " +
                                                     "FROM REPORTE_FALLA r " +
                                                     "JOIN EQUIPO e ON r.ID_Equipo_QR = e.ID_Equipo_QR " +
                                                     "JOIN PRESTAMO p ON r.ID_Prestamo = p.ID_Prestamo " +
                                                     "JOIN USUARIO u ON p.Matricula_ID = u.Matricula_ID " +
                                                     "ORDER BY r.Fecha_Reporte DESC";
                                                     
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery(sql);
                                        boolean hayDatos = false;
                                        
                                        while(rs.next()) {
                                            hayDatos = true;
                                            String estado = rs.getString("Estado_Resolucion");
                                            String nombreCompleto = rs.getString("Nombre_Completo");
                                            
                                            String iniciales = "";
                                            String[] partesNombre = nombreCompleto.split(" ");
                                            if(partesNombre.length >= 2) {
                                                iniciales = partesNombre[0].substring(0,1) + partesNombre[1].substring(0,1);
                                            } else {
                                                iniciales = nombreCompleto.substring(0,2);
                                            }
                                            iniciales = iniciales.toUpperCase();
                                %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold text-dark"><%= rs.getString("Modelo") %></div>
                                        <div class="text-muted small"><i class="bi bi-qr-code"></i> <%= rs.getString("ID_Equipo_QR") %></div>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm me-2 <%= estado.equals("Pendiente") ? "bg-danger text-white" : "bg-primary text-white" %>">
                                                <%= iniciales %>
                                            </div>
                                            <div class="small fw-bold"><%= nombreCompleto %></div>
                                        </div>
                                    </td>
                                    <td class="small text-muted"><%= rs.getDate("Fecha_Reporte") %></td>
                                    <td class="small">
                                        <span class="text-truncate d-inline-block" style="max-width: 250px;" title="<%= rs.getString("Descripcion_Dano") %>">
                                            <%= rs.getString("Descripcion_Dano") %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if(estado.equals("Pendiente")) { %>
                                            <span class="badge rounded-pill bg-danger-light text-danger"><i class="bi bi-exclamation-circle"></i> Pendiente</span>
                                        <% } else if (estado.equals("En Reparacion") || estado.equals("En Reparación")) { %>
                                            <span class="badge rounded-pill bg-warning-light text-warning"><i class="bi bi-tools"></i> En Reparación</span>
                                        <% } else { %>
                                            <span class="badge rounded-pill bg-success-light text-success" style="background-color: #dcfce7;"><i class="bi bi-check-circle"></i> Resuelto</span>
                                        <% } %>
                                    </td>
                                    <td class="text-end pe-4">
                                        <% if(!estado.equals("Resuelto")) { %>
                                            <button class="btn btn-outline-success btn-sm fw-bold" onclick="confirmarResolucion('<%= request.getContextPath() %>/ResolverReporte?id_reporte=<%= rs.getInt("ID_Reporte") %>&id_equipo=<%= rs.getString("ID_Equipo_QR") %>')">
                                                Resolver
                                            </button>
                                        <% } else { %>
                                            <span class="text-muted small"><i class="bi bi-check2-all"></i> Cerrado</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <% 
                                        } 
                                        if(!hayDatos) {
                                %>
                                    <tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-inbox fs-1 d-block mb-2"></i> No hay reportes de fallas registrados en el sistema.</td></tr>
                                <%
                                        }
                                        rs.close(); stmt.close(); conn.close(); 
                                    } catch(Exception e) { 
                                        out.print("<tr><td colspan='6' class='text-danger text-center'>Error de conexión con la BD. " + e.getMessage() + "</td></tr>");
                                    } 
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmarResolucion(url) {
            Swal.fire({
                title: '¿Marcar equipo como Resuelto?',
                text: "El reporte se cerrará y el equipo volverá a estar Disponible en el inventario principal.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#198754',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, resolver',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = url;
                }
            })
        }
    </script>
</body>
</html>