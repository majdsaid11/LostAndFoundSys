package lostfound;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    // HASHINKG SHA-256
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {

            // تحقق من حساب الـ staff 
            if ("staff@lostfound.ae".equalsIgnoreCase(email) && "admin123".equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("userEmail", email);
                session.setAttribute("userRole", "staff");
                response.sendRedirect("staffDashboard.jsp");
                return;
            }

            // تحقق من الطلاب داخلdb
            String sql = "SELECT * FROM USERS WHERE EMAIL = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
/*based on what return VARCHAR lenght as it is and since we have both passwords hashed and regulur
will ensure that the regular password like 202211797 will comparison correctly */
            if (rs.next()) {
                String storedPassword = rs.getString("PASSWORD_HASH").trim();
String hashedInput = hashPassword(password).trim();
                String role = rs.getString("ROLE");

                // WORKS FOR OLD PASSWORDS WITHOUT HASHIN G AND THE NEW WITH HASHING 
                if (storedPassword.equals(hashedInput) || storedPassword.equals(password)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userRole", role);

                    if ("staff".equalsIgnoreCase(role)) {
                        response.sendRedirect("staffDashboard.jsp");
                    } else {
                        response.sendRedirect("studentDashboard.jsp");
                    }
                } else {
                    request.setAttribute("loginError", "❌ Invalid email or password.");
                    RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                    rd.forward(request, response);
                }

            } else {
                request.setAttribute("loginError", "❌ No account found for this email.");
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "⚠️ Database error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles login for staff and students with password hashing";
    }
}
