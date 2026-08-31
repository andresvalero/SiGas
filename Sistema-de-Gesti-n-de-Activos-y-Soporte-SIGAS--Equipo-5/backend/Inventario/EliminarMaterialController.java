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

@WebServlet("/EliminarMaterial")
public class EliminarMaterialController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id_material = Integer.parseInt(request.getParameter("id_material"));
        String url = "jdbc:mysql://localhost:3306/sigas_db";
        String usuario = "root";
        String password = "SIGAS123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, password);
            String sql = "DELETE FROM MATERIAL WHERE ID_Material = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id_material);
            ps.executeUpdate();
            ps.close();
            conn.close();
            
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_inventario/materiales.jsp?eliminacion=exito");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_inventario/materiales.jsp?error=bd");
        }
    }
}
