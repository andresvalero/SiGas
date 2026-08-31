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

@WebServlet("/EditarRack")
public class EditarRackController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int id_rack = Integer.parseInt(request.getParameter("id_rack"));
        String nombre_ubicacion = request.getParameter("nombre_ubicacion");

        String url = "jdbc:mysql://localhost:3306/sigas_db";
        String usuario = "root";
        String password = "SIGAS123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, password);
            String sql = "UPDATE RACK_UBICACION SET Nombre_Ubicacion = ? WHERE ID_Rack = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nombre_ubicacion);
            ps.setInt(2, id_rack);
            
            ps.executeUpdate();
            ps.close();
            conn.close();
            
            response.sendRedirect(request.getContextPath() + "/Frontend/mapa_rack/racks.jsp?edicion=exito");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/mapa_rack/racks.jsp?error=bd");
        }
    }
}
