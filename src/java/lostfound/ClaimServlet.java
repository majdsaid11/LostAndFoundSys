package lostfound;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "ClaimServlet", urlPatterns = {"/ClaimServlet"})
public class ClaimServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session != null && session.getAttribute("userRole") != null)
                ? (String) session.getAttribute("userRole")
                : "student";
        /*i used this formmat for if statment to update the email variablee imedatly*/
        String email = (session != null) ? (String) session.getAttribute("userEmail") : null;
        String action = request.getParameter("action");

        // ================= STAFF ACTIONS =================
        if ("approve".equalsIgnoreCase(action) || "reject".equalsIgnoreCase(action)) {
            String claimIdStr = request.getParameter("claimId");
            if (claimIdStr != null && !claimIdStr.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    String status = "approve".equalsIgnoreCase(action) ? "Approved" : "Rejected";
                    PreparedStatement ps = conn.prepareStatement(
                            "UPDATE CLAIMS SET CLAIM_STATUS=? WHERE CLAIM_ID=?");
                    ps.setString(1, status);
                    ps.setInt(2, Integer.parseInt(claimIdStr));
                    ps.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            // send info to StaffDahboard
            response.sendRedirect("staffDashboard.jsp");
            return;
        }

        // ================= STUDENT ACTION: Claim Item =================
      if ("student".equalsIgnoreCase(role) && (email == null || email.isEmpty())) {
    response.sendRedirect("login.jsp");
    return;
}

        int itemId = Integer.parseInt(request.getParameter("itemId"));
        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement psUser = conn.prepareStatement("SELECT USER_ID FROM USERS WHERE EMAIL=?");
            psUser.setString(1, email);
            ResultSet rsUser = psUser.executeQuery();
            int userId = 0;
            if (rsUser.next()) userId = rsUser.getInt("USER_ID");

            PreparedStatement psCheck = conn.prepareStatement(
                    "SELECT * FROM CLAIMS WHERE ITEM_ID=? AND USER_ID=?");
            psCheck.setInt(1, itemId);
            psCheck.setInt(2, userId);
            ResultSet rsCheck = psCheck.executeQuery();

            if (rsCheck.next()) {
                request.setAttribute("message", "⚠️ You already claimed this item!");
            } else {
                PreparedStatement psInsert = conn.prepareStatement(
                        "INSERT INTO CLAIMS (ITEM_ID, USER_ID, VERIFICATION_DETAILS, CLAIM_STATUS) VALUES (?, ?, ?, ?)");
                psInsert.setInt(1, itemId);
                psInsert.setInt(2, userId);
                psInsert.setString(3, "Looks like mine");
                psInsert.setString(4, "Pending");
                psInsert.executeUpdate();
                request.setAttribute("message", "✅ Claim submitted successfully!");
            }

            RequestDispatcher rd = request.getRequestDispatcher("studentDashboard.jsp");
            rd.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "⚠️ Database error: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("studentDashboard.jsp");
            rd.forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles item claims by students and approvals/rejections by staff";
    }
}
