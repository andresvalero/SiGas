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

@WebServlet("/AgregarUsuario")
public class AgregarUsuarioController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String matricula = request.getParameter("matricula");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String rol = request.getParameter("rol");
        // Contraseña genérica para cumplir con el NOT NULL de la BD
        String passGen = "12345"; 

        String url = "jdbc:mysql://localhost:3306/sigas_db";
        String usuarioBD = "root";
        String passwordBD = "SIGAS123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usuarioBD, passwordBD);
            String sql = "INSERT INTO USUARIO (Matricula_ID, Nombre_Completo, Correo, Contrasena_Hash, Rol) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, matricula);
            ps.setString(2, nombre);
            ps.setString(3, correo);
            ps.setString(4, passGen);
            ps.setString(5, rol);
            
            ps.executeUpdate();
            ps.close();
            conn.close();
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_usuarios/usuarios.jsp?registro=exito");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_usuarios/usuarios.jsp?error=bd");
        }
    }
}
