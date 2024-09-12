/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package AdminControllers;

import Models.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author iduni
 */
@WebServlet(name = "ProfileUpdateController", urlPatterns = {"/ProfileUpdateController"})
public class ProfileUpdateController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");

        int ID = Integer.parseInt(request.getParameter("ID"));
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String dp = request.getParameter("dp");

        if (dp == null || dp.trim().isEmpty()) {
            dp = request.getParameter("dp_txt");
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "{CALL admin_update(?,?,?,?,?,?,?,?)}";
            try (CallableStatement stmt = conn.prepareCall(sql)) {

                stmt.setString(1, fname);
                stmt.setString(2, lname);
                stmt.setString(3, username);
                stmt.setString(4, email);
                stmt.setString(5, password);
                stmt.setString(6, dp);
                stmt.setInt(7, ID);
                stmt.registerOutParameter(8, java.sql.Types.INTEGER);

                stmt.executeUpdate();

                int success = stmt.getInt(8);
                if (success == 1) {
                    request.setAttribute("Reg_msg", "Update Successfully.");
                    request.setAttribute("Reg_clz", "alert-success");
                    request.getRequestDispatcher("admin/ProfileUpdate.jsp").forward(request, response);

                } else {
                    request.setAttribute("Reg_msg", "SQL ERROR");
                    request.setAttribute("Reg_clz", "alert-danger");
                    request.getRequestDispatcher("admin/ProfileUpdate.jsp").forward(request, response);
                }
                DatabaseConnection.closeConnection(conn);
            }
//            String sql = "UPDATE admin SET fname= ?, lname= ?, username= ?, email= ?, password= ?, dp= ? WHERE id = ?";
//            PreparedStatement stmt = conn.prepareStatement(sql);
//
//            stmt.setString(1, fname);
//            stmt.setString(2, lname);
//            stmt.setString(3, username);
//            stmt.setString(4, email);
//            stmt.setString(5, password);
//            stmt.setString(6, dp);
//            stmt.setInt(7, ID);
//
//            int rowsInserted = stmt.executeUpdate();
//            if (rowsInserted > 0) {
//                request.setAttribute("Reg_msg", "Update Successfully.");
//                request.setAttribute("Reg_clz", "alert-success");
//                request.getRequestDispatcher("admin/ProfileUpdate.jsp").forward(request, response);
//
//            } else {
//                request.setAttribute("Reg_msg", "SQL ERROR");
//                request.setAttribute("Reg_clz", "alert-danger");
//                request.getRequestDispatcher("admin/ProfileUpdate.jsp").forward(request, response);
//            }
//            DatabaseConnection.closeConnection(conn);

        } catch (SQLException e) {
            request.setAttribute("Reg_msg", "" + e);
            request.setAttribute("Reg_clz", "alert-danger");
            request.getRequestDispatcher("admin/ProfileUpdate.jsp").forward(request, response);
        }
    }
}
