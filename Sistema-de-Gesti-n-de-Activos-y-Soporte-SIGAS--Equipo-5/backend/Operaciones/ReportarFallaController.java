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

@WebServlet("/ReportarFalla")
public class ReportarFallaController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String id_equipo = request.getParameter("id_equipo");
        int id_prestamo = Integer.parseInt(request.getParameter("id_prestamo"));
        String descripcion = request.getParameter("descripcion");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
            
            // 1. Insertar el reporte de falla en tu tabla REPORTE_FALLA
            String sqlFalla = "INSERT INTO REPORTE_FALLA (Descripcion_Dano, Fecha_Reporte, Estado_Resolucion, ID_Equipo_QR, ID_Prestamo) VALUES (?, CURRENT_DATE, 'Pendiente', ?, ?)";
            PreparedStatement ps1 = conn.prepareStatement(sqlFalla);
            ps1.setString(1, descripcion);
            ps1.setString(2, id_equipo);
            ps1.setInt(3, id_prestamo);
            ps1.executeUpdate();
            ps1.close();

            // 2. Cambiar equipo a "En Mantenimiento" en tu tabla EQUIPO
            String sqlEquipo = "UPDATE EQUIPO SET Estado = 'En Mantenimiento' WHERE ID_Equipo_QR = ?";
            PreparedStatement ps2 = conn.prepareStatement(sqlEquipo);
            ps2.setString(1, id_equipo);
            ps2.executeUpdate();
            ps2.close();

            // 3. Cerrar el préstamo indicando que volvió con falla en tu tabla PRESTAMO
            String sqlPrestamo = "UPDATE PRESTAMO SET Fecha_Devolucion = CURRENT_DATE, Estado_Prestamo = 'Devuelto con Falla' WHERE ID_Prestamo = ?";
            PreparedStatement ps3 = conn.prepareStatement(sqlPrestamo);
            ps3.setInt(1, id_prestamo);
            ps3.executeUpdate();
            ps3.close();

            conn.close();
            response.sendRedirect(request.getContextPath() + "/Frontend/prestamos_devoluciones/devoluciones.jsp?reporte=exito");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/prestamos_devoluciones/devoluciones.jsp?error=bd");
        }
    }
}
