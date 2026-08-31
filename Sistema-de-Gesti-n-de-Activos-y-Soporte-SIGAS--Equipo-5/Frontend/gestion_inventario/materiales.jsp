<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGAS - Catálogo de Materiales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { background-color: #f8fafc; font-family: Arial, sans-serif; overflow-x: hidden; overflow-y: scroll; }
        .sidebar { background-color: #111827; min-width: 280px; height: 100vh; position: sticky; top: 0; }
        .sidebar a { color: #9ca3af; text-decoration: none; padding: 10px 25px; display: block; transition: 0.3s; font-size: 0.9rem; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.05); color: white; }
        .sidebar a.active { background-color: #3b82f6; color: white; }
        .sidebar i { margin-right: 12px; font-size: 1.1rem; }
        .main-content { padding: 40px; }
        .card-table { background-color: white; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); border: none; padding: 25px; }
        .btn-add { background-color: #e6f4ea; color: #1e8e3e; font-weight: bold; border: none; }
        .btn-add:hover { background-color: #ceead6; color: #1e8e3e; }
        .search-bar { background-color: #f1f3f4; border: none; border-radius: 8px; }
        .table th { color: #5f6368; font-size: 0.85rem; text-transform: uppercase; }
        .icon-action { color: #5f6368; cursor: pointer; margin-right: 10px; transition: 0.2s; text-decoration: none; }
        .icon-action:hover { color: #111827; }
        .icon-delete:hover { color: #d93025; }
        .icon-edit:hover { color: #0a58ca; }
    </style>
</head>
<body>
    <% 
        // LÓGICA PARA CARGAR LOS RACKS EN LA LISTA DESPLEGABLE
        String rackOptions = "";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connRack = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
            Statement stmtRack = connRack.createStatement();
            ResultSet rsRack = stmtRack.executeQuery("SELECT * FROM RACK_UBICACION");
            while(rsRack.next()) {
                rackOptions += "<option value='" + rsRack.getInt("ID_Rack") + "'>" + rsRack.getString("Nombre_Ubicacion") + "</option>";
            }
            rsRack.close(); stmtRack.close(); connRack.close();
        } catch (Exception e) {}
    %>

    <div class="container-fluid p-0">
        <div class="d-flex">
            <div class="sidebar d-flex flex-column p-0">
                <h4 class="text-center mb-4 text-white fw-bold mt-3"><i class="bi bi-layers"></i> Admin Panel</h4>
                <a href="../dashboard_administrador/dashboard.html"><i class="bi bi-grid-1x2"></i> Inicio</a>
                <div class="px-3 py-2 text-muted small fw-bold mt-2">INFRAESTRUCTURA</div>
                <a href="../mapa_rack/racks.html"><i class="bi bi-hdd-rack"></i> Gestión de Racks</a>
                <a href="inventario.jsp"><i class="bi bi-pc-display"></i> Catálogo de Equipos</a>
                <a href="materiales.jsp" class="active"><i class="bi bi-box-seam"></i> Catálogo de Materiales</a>
                <div class="px-3 py-2 text-muted small fw-bold mt-2">OPERACIONES</div>
                <a href="../auditoria_QR/auditoria.html"><i class="bi bi-qr-code-scan"></i> Auditoría QR</a>
                <a href="../prestamos_devoluciones/devoluciones.html"><i class="bi bi-arrow-left-right"></i> Préstamos y Devoluciones</a>
                <a href="../reportes/reportes.html"><i class="bi bi-file-earmark-medical"></i> Reportes</a>
                <div class="px-3 py-2 text-muted small fw-bold mt-2">SISTEMA</div>
                <a href="#"><i class="bi bi-people"></i> Usuarios</a>
                <div class="mt-auto mb-4">
                    <a href="<%= request.getContextPath() %>/Logout"><i class="bi bi-box-arrow-left"></i> Cerrar Sesión</a>
                </div>
            </div>

            <div class="main-content flex-grow-1">
                <h2 class="fw-bold mb-4">Catálogo de Materiales y Refacciones</h2>

                <% if(request.getParameter("registro") != null) { %><div class="alert alert-success alert-dismissible fade show"><strong>¡Éxito!</strong> Material registrado.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>
                <% if(request.getParameter("eliminacion") != null) { %><div class="alert alert-danger alert-dismissible fade show"><strong>¡Eliminado!</strong> Material borrado.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>
                <% if(request.getParameter("edicion") != null) { %><div class="alert alert-primary alert-dismissible fade show"><strong>¡Actualizado!</strong> Datos guardados.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>
                <% if(request.getParameter("error") != null) { %><div class="alert alert-danger alert-dismissible fade show"><strong>Error:</strong> No se pudo procesar la base de datos.<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div><% } %>

                <div class="card-table">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="input-group" style="width: 350px;">
                            <span class="input-group-text bg-transparent border-0"><i class="bi bi-search text-muted"></i></span>
                            <input type="text" class="form-control search-bar" placeholder="Buscar por Nombre...">
                        </div>
                        <button class="btn btn-add px-4 py-2" data-bs-toggle="modal" data-bs-target="#modalAgregarMaterial">
                            <i class="bi bi-plus-lg"></i> Agregar Material
                        </button>
                    </div>

                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>NOMBRE DE LA PIEZA</th>
                                <th>DESCRIPCIÓN</th>
                                <th>STOCK</th>
                                <th>RACK (ID)</th>
                                <th>ACCIONES</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                try {
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT * FROM MATERIAL");
                                    while(rs.next()) {
                                        int idMat = rs.getInt("ID_Material");
                                        String nombre = rs.getString("Nombre_Pieza");
                                        String desc = rs.getString("Descripcion");
                                        int stock = rs.getInt("Cantidad_Stock");
                                        int idRack = rs.getInt("ID_Rack");
                                        String badgeClass = stock > 5 ? "bg-success" : (stock > 0 ? "bg-warning" : "bg-danger");
                            %>
                            <tr>
                                <td class="fw-bold"><%= idMat %></td>
                                <td><%= nombre %></td>
                                <td class="text-muted small"><%= desc %></td>
                                <td><span class="badge <%= badgeClass %> px-3 py-2"><%= stock %></span></td>
                                <td><i class="bi bi-hdd-rack text-muted"></i> Rack #<%= idRack %></td>
                                <td>
                                    <a href="#" class="icon-action icon-edit" onclick="abrirModalEditar('<%= idMat %>', '<%= nombre %>', '<%= desc %>', '<%= stock %>', '<%= idRack %>')"><i class="bi bi-pencil"></i></a>
                                    <a href="#" class="icon-action icon-delete text-danger" onclick="confirmarEliminacion(event, '<%= request.getContextPath() %>/EliminarMaterial?id_material=<%= idMat %>')"><i class="bi bi-trash"></i></a>
                                </td>
                            </tr>
                            <%
                                    }
                                    rs.close(); stmt.close(); conn.close();
                                } catch (Exception e) {}
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalAgregarMaterial" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title fw-bold">Registrar Nuevo Material</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <form action="<%= request.getContextPath() %>/AgregarMaterial" method="POST">
                    <div class="modal-body">
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">NOMBRE DE LA PIEZA</label><input type="text" class="form-control" name="nombre_pieza" required></div>
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">DESCRIPCIÓN</label><textarea class="form-control" name="descripcion" rows="2" required></textarea></div>
                        <div class="row">
                            <div class="col-md-6 mb-3"><label class="form-label fw-bold text-muted small">CANTIDAD EN STOCK</label><input type="number" class="form-control" name="cantidad_stock" min="0" required></div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold text-muted small">ASIGNAR RACK</label>
                                <select class="form-select" name="id_rack" required>
                                    <option value="" disabled selected>Selecciona un Rack...</option>
                                    <%= rackOptions %>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button><button type="submit" class="btn btn-primary">Guardar</button></div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalEditarMaterial" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title fw-bold">Editar Material</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <form action="<%= request.getContextPath() %>/EditarMaterial" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="id_material" id="edit_id_material_hidden">
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">ID MATERIAL</label><input type="text" class="form-control bg-light" id="edit_id_material_display" readonly></div>
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">NOMBRE DE LA PIEZA</label><input type="text" class="form-control" name="nombre_pieza" id="edit_nombre_pieza" required></div>
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">DESCRIPCIÓN</label><textarea class="form-control" name="descripcion" id="edit_descripcion" rows="2" required></textarea></div>
                        <div class="row">
                            <div class="col-md-6 mb-3"><label class="form-label fw-bold text-muted small">CANTIDAD EN STOCK</label><input type="number" class="form-control" name="cantidad_stock" id="edit_cantidad_stock" min="0" required></div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold text-muted small">ASIGNAR RACK</label>
                                <select class="form-select" name="id_rack" id="edit_id_rack" required>
                                    <%= rackOptions %>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button><button type="submit" class="btn btn-primary">Guardar Cambios</button></div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmarEliminacion(event, url) {
            event.preventDefault(); 
            Swal.fire({ title: '¿Estás seguro?', text: "Se eliminará permanentemente.", icon: 'warning', showCancelButton: true, confirmButtonColor: '#d33', confirmButtonText: 'Sí, eliminar', cancelButtonText: 'Cancelar' }).then((result) => { if (result.isConfirmed) { window.location.href = url; } })
        }
        function abrirModalEditar(id, nombre, desc, stock, rack) {
            document.getElementById('edit_id_material_hidden').value = id;
            document.getElementById('edit_id_material_display').value = id;
            document.getElementById('edit_nombre_pieza').value = nombre;
            document.getElementById('edit_descripcion').value = desc;
            document.getElementById('edit_cantidad_stock').value = stock;
            document.getElementById('edit_id_rack').value = rack;
            var modalEdit = new bootstrap.Modal(document.getElementById('modalEditarMaterial'));
            modalEdit.show();
        }
    </script>
</body>
</html>