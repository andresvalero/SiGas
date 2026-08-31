<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGAS - Gestión de Racks</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="racks.css">
</head>
<body>
    <div class="container-fluid p-0">
        <div class="d-flex">
            <div class="sidebar d-flex flex-column p-0">
                <h4 class="text-center mb-4 text-white fw-bold mt-3">
                    <i class="bi bi-layers"></i> Admin Panel
                </h4>
                
                <a href="../dashboard_administrador/dashboard.html"><i class="bi bi-grid-1x2"></i> Inicio</a>
                
                <div class="nav-label">INFRAESTRUCTURA</div>
                <a href="../mapa_rack/racks.jsp" class="active"><i class="bi bi-hdd-rack"></i> Gestión de Racks</a>
                <a href="../gestion_inventario/inventario.jsp"><i class="bi bi-pc-display"></i> Catálogo de Equipos</a>
                <a href="../gestion_inventario/materiales.jsp"><i class="bi bi-box-seam"></i> Catálogo de Materiales</a>
                
                <div class="nav-label">OPERACIONES</div>
                <a href="../auditoria_QR/auditoria.html"><i class="bi bi-qr-code-scan"></i> Auditoría QR</a>
                <a href="../prestamos_devoluciones/devoluciones.html"><i class="bi bi-arrow-left-right"></i> Préstamos y Devoluciones</a>
                <a href="../reportes/reportes.html"><i class="bi bi-file-earmark-medical"></i> Reportes</a>
                
                <div class="nav-label">SISTEMA</div>
                <a href="../gestion_usuarios/usuarios.jsp"><i class="bi bi-people"></i> Usuarios</a>
                
                <div class="mt-auto mb-4">
                    <a href="<%= request.getContextPath() %>/Logout"><i class="bi bi-box-arrow-left"></i> Cerrar Sesión</a>
                </div>
            </div>

            <div class="main-content flex-grow-1 p-4 bg-light">
                <header class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold mb-0 text-dark">Gestión de Racks e Infraestructura</h2>
                        <p class="text-muted">Administración física del laboratorio LS5.</p>
                    </div>
                    <button class="btn btn-primary shadow-sm px-4" data-bs-toggle="modal" data-bs-target="#modalAgregarRack">
                        <i class="bi bi-plus-lg me-2"></i>Nuevo Rack
                    </button>
                </header>

                <% if(request.getParameter("registro") != null) { %><div class="alert alert-success alert-dismissible fade show"><strong>¡Éxito!</strong> Rack registrado.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>
                <% if(request.getParameter("eliminacion") != null) { %><div class="alert alert-danger alert-dismissible fade show"><strong>¡Eliminado!</strong> Rack borrado.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>
                <% if(request.getParameter("edicion") != null) { %><div class="alert alert-primary alert-dismissible fade show"><strong>¡Actualizado!</strong> Datos guardados.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>

                <div class="row g-4 mb-5">
                    <% 
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM RACK_UBICACION");
                            while(rs.next()) {
                                int idRack = rs.getInt("ID_Rack");
                                String nombre = rs.getString("Nombre_Ubicacion");
                    %>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm p-4 rack-card">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="d-flex align-items-center">
                                    <div class="icon-container-rack me-3">
                                        <i class="bi bi-hdd-stack fs-4"></i>
                                    </div>
                                    <div>
                                        <h5 class="fw-bold mb-0">RACK-<%= idRack %></h5>
                                        <small class="text-muted"><%= nombre %></small>
                                    </div>
                                </div>
                                <div class="d-flex gap-2">
                                    <a href="#" class="text-primary" onclick="abrirModalEditar('<%= idRack %>', '<%= nombre %>')"><i class="bi bi-pencil fs-5"></i></a>
                                    <a href="#" class="text-danger" onclick="confirmarEliminacion(event, '<%= request.getContextPath() %>/EliminarRack?id_rack=<%= idRack %>')"><i class="bi bi-trash fs-5"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                            rs.close(); stmt.close(); conn.close();
                        } catch (Exception e) {}
                    %>
                </div>

                <div class="card border-0 shadow-sm p-4 mt-4 bg-white">
                    <h5 class="fw-bold mb-4 text-secondary"><i class="bi bi-search me-2"></i>Vista Docente: Disponibilidad</h5>
                    <div class="d-flex gap-3 mb-4">
                        <button class="btn btn-rack-selector active flex-fill py-3 shadow-none">
                            <span class="fw-bold d-block">RACK 1</span>
                            <small class="text-success">● 12 Equipos Libres</small>
                        </button>
                        <button class="btn btn-rack-selector flex-fill py-3 shadow-none">
                            <span class="fw-bold d-block text-muted">RACK 2</span>
                            <small class="text-warning">⚠️ 2 Equipos Libres</small>
                        </button>
                    </div>
                    <div class="list-container p-4">
                        <p class="text-muted small mb-0">Esta sección permite a los docentes ver rápidamente qué equipos están disponibles sin entrar a la base de datos completa.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalAgregarRack" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title fw-bold">Registrar Nuevo Rack</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <form action="<%= request.getContextPath() %>/AgregarRack" method="POST">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted small">UBICACIÓN O NOMBRE</label>
                            <input type="text" class="form-control" name="nombre_ubicacion" required>
                        </div>
                    </div>
                    <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button><button type="submit" class="btn btn-primary">Guardar</button></div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalEditarRack" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title fw-bold">Editar Rack</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <form action="<%= request.getContextPath() %>/EditarRack" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="id_rack" id="edit_id_rack_hidden">
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">NOMBRE O UBICACIÓN</label><input type="text" class="form-control" name="nombre_ubicacion" id="edit_nombre_ubicacion" required></div>
                    </div>
                    <div class="modal-footer"><button type="submit" class="btn btn-primary">Guardar Cambios</button></div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmarEliminacion(event, url) {
            event.preventDefault(); 
            Swal.fire({ title: '¿Borrar Rack?', text: "Se eliminará la ubicación del sistema.", icon: 'warning', showCancelButton: true, confirmButtonColor: '#d33', confirmButtonText: 'Sí, eliminar' }).then((result) => { if (result.isConfirmed) { window.location.href = url; } })
        }
        function abrirModalEditar(id, nombre) {
            document.getElementById('edit_id_rack_hidden').value = id;
            document.getElementById('edit_nombre_ubicacion').value = nombre;
            new bootstrap.Modal(document.getElementById('modalEditarRack')).show();
        }
    </script>
</body>
</html>