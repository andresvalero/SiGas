package Backend.Usuarios;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/EditarUsuario")
public class EditarUsuarioController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String matricula = request.getParameter("matricula");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String rol = request.getParameter("rol");
        String estatus = request.getParameter("estatus");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
            String sql = "UPDATE USUARIO SET Nombre_Completo = ?, Correo = ?, Rol = ?, Estatus = ? WHERE Matricula_ID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, correo);
            ps.setString(3, rol);
            ps.setString(4, estatus);
            ps.setString(5, matricula);
            
            ps.executeUpdate();
            ps.close();
            conn.close();
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_usuarios/usuarios.jsp?edicion=exito");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_usuarios/usuarios.jsp?error=bd");
        }
    }
}