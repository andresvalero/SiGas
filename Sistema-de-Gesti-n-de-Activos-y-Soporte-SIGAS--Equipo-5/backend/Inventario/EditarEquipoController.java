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

@WebServlet("/EditarEquipo")
public class EditarEquipoController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Esto evita problemas con los acentos
        request.setCharacterEncoding("UTF-8");
        
        // Recibimos los datos del formulario de edición
        String id_qr = request.getParameter("id_qr"); // El ID no se cambia, se usa para buscar
        String marca = request.getParameter("marca");
        String modelo = request.getParameter("modelo");
        String numero_serie = request.getParameter("numero_serie");
        String estado = request.getParameter("estado");

        String url = "jdbc:mysql://localhost:3306/sigas_db";
        String usuario = "root";
        String password = "SIGAS123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, password);
            
            // Sentencia SQL para actualizar (UPDATE)
            String sql = "UPDATE EQUIPO SET Marca = ?, Modelo = ?, Num_Serie = ?, Estado = ? WHERE ID_Equipo_QR = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, marca);
            ps.setString(2, modelo);
            ps.setString(3, numero_serie);
            ps.setString(4, estado);
            ps.setString(5, id_qr); // El ID va al final en el WHERE
            
            ps.executeUpdate();
            
            ps.close();
            conn.close();
            
            // Redirige de vuelta con mensaje de éxito
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_inventario/inventario.jsp?edicion=exito");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_inventario/inventario.jsp?error=bd");
        }
    }
}