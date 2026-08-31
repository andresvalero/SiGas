<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>SIGAS - Gestión de Usuarios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="usuarios.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <div class="d-flex">
        <div class="sidebar">
            <h4 class="text-center text-white py-4">Admin Panel</h4>
            <a href="../dashboard_administrador/dashboard.html"><i class="bi bi-grid-1x2"></i> Inicio</a>
            <div class="nav-label">INFRAESTRUCTURA</div>
            <a href="../mapa_rack/racks.jsp"><i class="bi bi-hdd-rack"></i> Gestión de Racks</a>
            <a href="../gestion_inventario/inventario.jsp"><i class="bi bi-pc-display"></i> Catálogo de Equipos</a>
            <a href="../gestion_inventario/materiales.jsp"><i class="bi bi-box-seam"></i> Catálogo de Materiales</a>
            <div class="nav-label">SISTEMA</div>
            <a href="usuarios.jsp" class="active"><i class="bi bi-people"></i> Usuarios</a>
            <div class="mt-auto p-4"><a href="<%= request.getContextPath() %>/Logout" class="text-muted"><i class="bi bi-box-arrow-left"></i> Salir</a></div>
        </div>

        <div class="main-content flex-grow-1">
            <div class="d-flex justify-content-between mb-4">
                <h2>Directorio de Usuarios</h2>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">Nuevo Registro</button>
            </div>

            <div class="card-table">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Matrícula</th><th>Nombre</th><th>Correo</th><th>Rol</th><th>Estatus</th><th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
                                ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM USUARIO");
                                while(rs.next()){
                        %>
                        <tr>
                            <td><%= rs.getString("Matricula_ID") %></td>
                            <td><%= rs.getString("Nombre_Completo") %></td>
                            <td><%= rs.getString("Correo") %></td>
                            <td><%= rs.getString("Rol") %></td>
                            <td><span class="badge <%= rs.getString("Estatus").equals("Activo") ? "bg-success" : "bg-danger" %>"><%= rs.getString("Estatus") %></span></td>
                            <td>
                                <a href="#" onclick="editUser('<%= rs.getString("Matricula_ID") %>', '<%= rs.getString("Nombre_Completo") %>', '<%= rs.getString("Correo") %>', '<%= rs.getString("Rol") %>', '<%= rs.getString("Estatus") %>')"><i class="bi bi-pencil me-2"></i></a>
                                <a href="#" class="text-danger" onclick="confirmDel('<%= rs.getString("Matricula_ID") %>')"><i class="bi bi-trash"></i></a>
                            </td>
                        </tr>
                        <% } conn.close(); } catch(Exception e){} %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="<%= request.getContextPath() %>/AgregarUsuario" method="POST" class="modal-content">
                <div class="modal-header"><h5>Registrar Persona</h5></div>
                <div class="modal-body">
                    <input type="text" name="matricula" class="form-control mb-3" placeholder="Matrícula" required>
                    <input type="text" name="nombre" class="form-control mb-3" placeholder="Nombre Completo" required>
                    <input type="email" name="correo" class="form-control mb-3" placeholder="Correo Institucional" required>
                    <select name="rol" class="form-select">
                        <option value="Alumno">Alumno</option>
                        <option value="Docente">Docente</option>
                    </select>
                </div>
                <div class="modal-footer"><button type="submit" class="btn btn-primary">Guardar</button></div>
            </form>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="<%= request.getContextPath() %>/EditarUsuario" method="POST" class="modal-content">
                <div class="modal-header"><h5>Editar Datos</h5></div>
                <div class="modal-body">
                    <input type="text" name="matricula" id="e_mat" class="form-control mb-3" readonly>
                    <input type="text" name="nombre" id="e_nom" class="form-control mb-3" required>
                    <input type="email" name="correo" id="e_cor" class="form-control mb-3" required>
                    <select name="rol" id="e_rol" class="form-select mb-3">
                        <option value="Alumno">Alumno</option><option value="Docente">Docente</option><option value="Admin">Admin</option>
                    </select>
                    <select name="estatus" id="e_est" class="form-select">
                        <option value="Activo">Activo</option><option value="Inactivo">Inactivo</option>
                    </select>
                </div>
                <div class="modal-footer"><button type="submit" class="btn btn-primary">Actualizar</button></div>
            </form>
        </div>
    </div>

    <script>
        function editUser(m, n, c, r, e) {
            document.getElementById('e_mat').value = m;
            document.getElementById('e_nom').value = n;
            document.getElementById('e_cor').value = c;
            document.getElementById('e_rol').value = r;
            document.getElementById('e_est').value = e;
            new bootstrap.Modal(document.getElementById('editModal')).show();
        }
        function confirmDel(m) {
            Swal.fire({title:'¿Eliminar?', text:'Esta acción no se puede deshacer', icon:'warning', showCancelButton:true}).then(r => {
                if(r.isConfirmed) location.href='<%= request.getContextPath() %>/EliminarUsuario?matricula='+m;
            });
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>