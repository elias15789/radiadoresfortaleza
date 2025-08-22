import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validar correo
        if (!validarCorreo(email)) {
            request.setAttribute("error", "El correo electrónico no es válido. No debe contener números ni mayúsculas.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Validar contraseña
        if (!validarContraseña(password)) {
            request.setAttribute("error", "La contraseña debe contener al menos una mayúscula, una minúscula, un número, un carácter especial y tener al menos 8 caracteres.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Verificar credenciales en la base de datos
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Sys_Radiadores_Fort", "root", "");

            String sql = "SELECT * FROM usuario WHERE email=? AND contrasena=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String nombreUsuario = rs.getString("email");
                String rol = null;
                try {
                    rol = rs.getString("rol");
                } catch (Exception ignored) { }
                // Normalizar a códigos esperados por la UI/servicios
                String rolNormalizado;
                if (rol == null || rol.trim().isEmpty()) {
                    rolNormalizado = "ADMIN"; // compatibilidad por defecto
                } else {
                    String r = rol.trim().toUpperCase();
                    if ("ADMINISTRADOR".equals(r) || "ADMIN".equals(r)) {
                        rolNormalizado = "ADMIN";
                    } else if ("ALMACENERO".equals(r) || "ALMACEN".equals(r)) {
                        rolNormalizado = "ALMACENERO";
                    } else if ("VENDEDOR".equals(r) || "VENTAS".equals(r)) {
                        rolNormalizado = "VENDEDOR";
                    } else if ("ASESOR DE VENTAS".equals(r) || "ASESOR_VENTAS".equals(r) || "ASESOR".equals(r)) {
                        rolNormalizado = "ASESOR_VENTAS";
                    } else {
                        rolNormalizado = r; // fallback, ya en mayúsculas
                    }
                }
                request.getSession().setAttribute("nombreUsuario", nombreUsuario);
                request.getSession().setAttribute("rolUsuario", rolNormalizado);

                String destino;
                switch (rolNormalizado) {
                    case "ALMACENERO":
                        destino = "AlmacenServlet";
                        break;
                    case "VENDEDOR":
                    case "ASESOR_VENTAS":
                        destino = "VentaServlet";
                        break;
                    default:
                        destino = "panel.jsp";
                }
                response.sendRedirect(destino);
            } else {
                request.setAttribute("error", "Usuario o contraseña incorrectos");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private boolean validarCorreo(String email) {
        String regex = "^[a-z+_.-]+@(.+)$"; // Solo minúsculas, no números
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(email);
        return matcher.matches();
    }

    private boolean validarContraseña(String contraseña) {
        String regex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(contraseña);
        return matcher.matches();
    }
}
