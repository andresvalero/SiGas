import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Configuración de tu base de datos local
    private static final String DB_URL = "jdbc:mysql://localhost:3306/sigas_db";
    private static final String DB_USER = "root"; 
    private static final String DB_PASSWORD = "SIGAS123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        // Obtenemos la ruta base exacta de tu proyecto automáticamente
        String contextPath = request.getContextPath();

        if (correo == null || correo.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(contextPath + "/Frontend/pantalla_login/login.html?error=campos_vacios");
            return;
        }

        // Validación estricta de correo institucional
        if (!correo.endsWith("@saltillo.tecnm.mx")) {
            response.sendRedirect(contextPath + "/Frontend/pantalla_login/login.html?error=correo_invalido");
            return;
        }

        // Conexión real a la base de datos
        try {
            // Cargar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            // Consultar si el correo y la contraseña coinciden en la tabla USUARIO
            String sql = "SELECT Nombre_Completo, Rol FROM USUARIO WHERE Correo = ? AND Contrasena_Hash = ? AND Estatus = 'Activo'";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, correo);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Si rs.next() es verdadero, encontró al usuario
                String nombreUsuario = rs.getString("Nombre_Completo");
                String rolUsuario = rs.getString("Rol");
                
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", nombreUsuario);
                session.setAttribute("rol", rolUsuario);
                
                // Redirigir al dashboard con la ruta correcta
                response.sendRedirect(contextPath + "/Frontend/dashboard_administrador/dashboard.html");
            } else {
                // No lo encontró, credenciales inválidas
                response.sendRedirect(contextPath + "/Frontend/pantalla_login/login.html?error=credenciales_invalidas");
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            // Error de conexión
            response.sendRedirect(contextPath + "/Frontend/pantalla_login/login.html?error=error_servidor");
        }
    }
}