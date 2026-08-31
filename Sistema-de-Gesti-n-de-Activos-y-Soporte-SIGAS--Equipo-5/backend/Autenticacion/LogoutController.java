import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/Logout")
public class LogoutController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Obtener la sesión actual si es que existe
        HttpSession session = request.getSession(false);
        
        // 2. Si hay una sesión activa, destruirla por completo
        if (session != null) {
            session.invalidate();
        }
        
        // 3. Regresar al guardia de la entrada (pantalla de login)
        String contextPath = request.getContextPath();
        response.sendRedirect(contextPath + "/Frontend/pantalla_login/login.html");
    }
}