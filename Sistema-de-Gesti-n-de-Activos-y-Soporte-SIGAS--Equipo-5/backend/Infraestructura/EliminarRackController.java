package Backend.Infraestructura;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/EliminarRack")
public class EliminarRackController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id_rack = Integer.parseInt(request.getParameter("id_rack"));
        String url = "jdbc:mysql://localhost:3306/sigas_db";
        String usuario = "root";
        String password = "SIGAS123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, password);
            String sql = "DELETE FROM RACK_UBICACION WHERE ID_Rack = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id_rack);
            ps.executeUpdate();
            ps.close();
            conn.close();
            
            response.sendRedirect(request.getContextPath() + "/Frontend/mapa_rack/racks.jsp?eliminacion=exito");
        } catch (Exception e) {
            // Si el rack tiene equipos o materiales asignados, MySQL bloqueará la eliminación por seguridad (Llave Foránea)
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/mapa_rack/racks.jsp?error=foranea");
        }
    }
}
