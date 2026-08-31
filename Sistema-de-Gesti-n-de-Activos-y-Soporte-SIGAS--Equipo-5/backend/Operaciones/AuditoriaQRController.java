package Backend.Operaciones;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AuditoriaQR")
public class AuditoriaQRController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String id_qr = request.getParameter("id_qr");

        String url = "jdbc:mysql://localhost:3306/sigas_db";
        String usuario = "root";
        String password = "SIGAS123";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, password);
            
            // Actualizamos la fecha de auditoría a la fecha actual del sistema (CURRENT_DATE)
            String sql = "UPDATE EQUIPO SET Ultima_Auditoria = CURRENT_DATE WHERE ID_Equipo_QR = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, id_qr);
            
            int filasAfectadas = ps.executeUpdate();
            ps.close();
            conn.close();
            
            // Si encontró el equipo y lo actualizó, mandamos éxito. Si no, mandamos error de que no existe.
            if(filasAfectadas > 0) {
                response.sendRedirect(request.getContextPath() + "/Frontend/auditoria_QR/auditoria.jsp?auditoria=exito&qr=" + id_qr);
            } else {
                response.sendRedirect(request.getContextPath() + "/Frontend/auditoria_QR/auditoria.jsp?error=noencontrado");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/auditoria_QR/auditoria.jsp?error=bd");
        }
    }
}