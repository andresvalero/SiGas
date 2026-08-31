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

@WebServlet("/AgregarEquipo")
public class EquipoController extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 1. Recibir los datos del formulario HTML (los names del modal)
        String idQr = request.getParameter("id_qr");
        String numeroSerie = request.getParameter("numero_serie");
        String marca = request.getParameter("marca");
        String modelo = request.getParameter("modelo");
        String estado = request.getParameter("estado");
        
        // 2. Conectarse a MySQL
        String dbURL = "jdbc:mysql://localhost:3306/sigas_db";
        String dbUser = "root";
        String dbPass = "SIGAS123"; 
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            // 3. Insertar usando los nombres EXACTOS de tus columnas
            String sql = "INSERT INTO EQUIPO (ID_Equipo_QR, Num_Serie, Marca, Modelo, Estado) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, idQr);
            stmt.setString(2, numeroSerie); 
            stmt.setString(3, marca);
            stmt.setString(4, modelo);
            stmt.setString(5, estado);
            
            stmt.executeUpdate();
            
            stmt.close();
            conn.close();
            
            // 4. CORRECCIÓN: Regresar a inventario.jsp (antes decía equipos.jsp)
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_inventario/inventario.jsp?registro=exito");
            
        } catch (Exception e) {
            e.printStackTrace();
            // CORRECCIÓN: También aquí actualizamos la ruta para el error
            response.sendRedirect(request.getContextPath() + "/Frontend/gestion_inventario/inventario.jsp?error=bd");
        }
    }
}
