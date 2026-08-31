package Backend.Inventario;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/EliminarEquipo")
public class EliminarEquipoController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id_qr = request.getParameter("id_qr");
        String url = "jdbc:mysql://localhost:3306/sigas_db";
        String usuario = "root";
        String password = "SIGAS123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, password);
            
            // Sentencia SQL para borrar el equipo usando su ID_QR
            String sql = "DELETE FROM EQUIPO WHERE ID_Equipo_QR = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, id_qr);
            
            ps.executeUpdate();
            
            ps.close();
            conn.close();
            
            // Redirige de vuelta al inventario con un mensaje de éxito
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_inventario/inventario.jsp?eliminacion=exito");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_inventario/inventario.jsp?error=bd");
        }
    }
}