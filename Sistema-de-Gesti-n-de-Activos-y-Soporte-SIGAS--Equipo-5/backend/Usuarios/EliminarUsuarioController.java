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

@WebServlet("/EliminarUsuario")
public class EliminarUsuarioController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String matricula = request.getParameter("matricula");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
            String sql = "DELETE FROM USUARIO WHERE Matricula_ID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, matricula);
            ps.executeUpdate();
            ps.close();
            conn.close();
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_usuarios/usuarios.jsp?eliminacion=exito");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_usuarios/usuarios.jsp?error=foranea");
        }
    }
}
