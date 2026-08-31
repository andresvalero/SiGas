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

@WebServlet("/DevolverEquipo")
public class DevolverEquipoController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id_prestamo = Integer.parseInt(request.getParameter("id_prestamo"));
        String id_equipo = request.getParameter("id_equipo");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
            
            // 1. Marcar préstamo como devuelto con la fecha de hoy
            String sqlPrestamo = "UPDATE PRESTAMO SET Fecha_Devolucion = CURRENT_DATE, Estado_Prestamo = 'Devuelto' WHERE ID_Prestamo = ?";
            PreparedStatement ps1 = conn.prepareStatement(sqlPrestamo);
            ps1.setInt(1, id_prestamo);
            ps1.executeUpdate();
            ps1.close();

            // 2. Regresar el equipo a disponible
            String sqlEquipo = "UPDATE EQUIPO SET Estado = 'Disponible' WHERE ID_Equipo_QR = ?";
            PreparedStatement ps2 = conn.prepareStatement(sqlEquipo);
            ps2.setString(1, id_equipo);
            ps2.executeUpdate();
            ps2.close();
            
            conn.close();
            response.sendRedirect(request.getContextPath() + "/Frontend/prestamos_devoluciones/devoluciones.jsp?devolucion=exito");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/prestamos_devoluciones/devoluciones.jsp?error=bd");
        }
    }
}
