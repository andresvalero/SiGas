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

@WebServlet("/NuevoPrestamo")
public class NuevoPrestamoController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String matricula = request.getParameter("matricula");
        String id_equipo = request.getParameter("id_equipo");
        String fecha_limite = request.getParameter("fecha_limite");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sigas_db", "root", "SIGAS123");
            
            // 1. Insertar el préstamo (Fecha Salida es HOY automático)
            String sqlPrestamo = "INSERT INTO PRESTAMO (Fecha_Salida, Fecha_Limite, Estado_Prestamo, Matricula_ID, ID_Equipo_QR) VALUES (CURRENT_DATE, ?, 'Activo', ?, ?)";
            PreparedStatement ps1 = conn.prepareStatement(sqlPrestamo);
            ps1.setString(1, fecha_limite);
            ps1.setString(2, matricula);
            ps1.setString(3, id_equipo);
            ps1.executeUpdate();
            ps1.close();

            // 2. Cambiar el estado del equipo para que ya no aparezca disponible
            String sqlEquipo = "UPDATE EQUIPO SET Estado = 'Prestado' WHERE ID_Equipo_QR = ?";
            PreparedStatement ps2 = conn.prepareStatement(sqlEquipo);
            ps2.setString(1, id_equipo);
            ps2.executeUpdate();
            ps2.close();
            
            conn.close();
            response.sendRedirect(request.getContextPath() + "/Frontend/prestamos_devoluciones/devoluciones.jsp?registro=exito");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Frontend/prestamos_devoluciones/devoluciones.jsp?error=bd");
        }
    }
}
