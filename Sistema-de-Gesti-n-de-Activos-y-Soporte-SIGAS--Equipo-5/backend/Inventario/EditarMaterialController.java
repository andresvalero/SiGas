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

@WebServlet("/EditarMaterial")
public class EditarMaterialController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int id_material = Integer.parseInt(request.getParameter("id_material"));
        String nombre_pieza = request.getParameter("nombre_pieza");
        String descripcion = request.getParameter("descripcion");
        int cantidad = Integer.parseInt(request.getParameter("cantidad_stock"));
        int id_rack = Integer.parseInt(request.getParameter("id_rack"));

        String url = "jdbc:mysql://localhost:3306/sigas_db";
        String usuario = "root";
        String password = "SIGAS123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, password);
            String sql = "UPDATE MATERIAL SET Nombre_Pieza = ?, Descripcion = ?, Cantidad_Stock = ?, ID_Rack = ? WHERE ID_Material = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nombre_pieza);
            ps.setString(2, descripcion);
            ps.setInt(3, cantidad);
            ps.setInt(4, id_rack);
            ps.setInt(5, id_material);
            
            ps.executeUpdate();
            ps.close();
            conn.close();
            
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_inventario/materiales.jsp?edicion=exito");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_inventario/materiales.jsp?error=bd");
        }
    }
}
