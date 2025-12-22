package lostfound;

import java.io.*;
import java.sql.*;
import java.time.LocalDate;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet(urlPatterns = {"/LostItemServlet"})
@MultipartConfig(maxFileSize = 16177215) // Allow 16MB images
public class LostItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String userEmail = (session != null)
                ? (String) session.getAttribute("userEmail")
                : "unknown@ajmanuni.ac.ae";
        String role = (session != null && session.getAttribute("userRole") != null)
                ? (String) session.getAttribute("userRole")
                : "student";

        String action = request.getParameter("action");

        // ======================= DELETE =======================
        if ("delete".equalsIgnoreCase(action)) {
            String itemId = request.getParameter("itemId");
            if (itemId != null && !itemId.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    String sql;
                    if ("staff".equalsIgnoreCase(role)) {
                        sql = "DELETE FROM ITEMS WHERE ITEM_ID=?";
                    } else {
                        sql = "DELETE FROM ITEMS WHERE ITEM_ID=? AND POSTED_BY=?";
                    }

                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(itemId));
                    if (!"staff".equalsIgnoreCase(role)) {
                        ps.setString(2, userEmail);
                    }

                    int rows = ps.executeUpdate();
                    if (rows > 0)
                        request.setAttribute("message", "✅ Item deleted successfully!");
                    else
                        request.setAttribute("message", "⚠️ You are not authorized to delete this item.");

                    if ("staff".equalsIgnoreCase(role)) {
    response.sendRedirect("staffDashboard.jsp");
} else {
    response.sendRedirect("studentDashboard.jsp");
}
                    return;

                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("message", "⚠️ Database error while deleting: " + e.getMessage());
                }
            }
        }

        // ======================= ADD =======================
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String location = request.getParameter("location"); // 🆕 الموقع
        String status = "staff".equalsIgnoreCase(role) ? "found" : "lost";
        LocalDate datePosted = LocalDate.now();

        Part filePart = request.getPart("image");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO ITEMS (TITLE, DESCRIPTION, CATEGORY, LOCATION, IMAGE, STATUS, DATE_POSTED, POSTED_BY) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, category);
            ps.setString(4, location);

            if (filePart != null && filePart.getSize() > 0) {
                ps.setBlob(5, filePart.getInputStream());
            } else {
                ps.setNull(5, Types.BLOB);
            }

            ps.setString(6, status);
            ps.setDate(7, java.sql.Date.valueOf(datePosted));
            ps.setString(8, userEmail);

            ps.executeUpdate();

            request.setAttribute("message", "✅ Item added successfully!");
            RequestDispatcher rd = request.getRequestDispatcher(
                    "staff".equalsIgnoreCase(role) ? "staffDashboard.jsp" : "studentDashboard.jsp");
            rd.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "⚠️ Database error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher(
                    "staff".equalsIgnoreCase(role) ? "staffDashboard.jsp" : "studentDashboard.jsp");
            rd.forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles adding/deleting lost & found items with image upload (BLOB) and location support";
    }
}
