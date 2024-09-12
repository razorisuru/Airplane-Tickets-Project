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
@WebServlet(name = "AddUserController", urlPatterns = {"/AddUserController"})
public class AddUserController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");

        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        role = role.toLowerCase();
        String dp = request.getParameter("dp");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "{CALL admin_add(?,?,?,?,?,?,?,?)}";
            try (CallableStatement stmt = conn.prepareCall(sql)) {

                stmt.setString(1, fname);
                stmt.setString(2, lname);
                stmt.setString(3, username);
                stmt.setString(4, email);
                stmt.setString(5, password);
                stmt.setString(6, role);
                stmt.setString(7, dp);
                stmt.registerOutParameter(8, java.sql.Types.INTEGER);

                stmt.executeUpdate();

                int success = stmt.getInt(8);
                if (success == 1) {
                    request.setAttribute("Reg_msg", "User Added Successfully");
                    request.setAttribute("Reg_clz", "alert-success");
                    request.getRequestDispatcher("admin/AddUser.jsp").forward(request, response);

                } else {
                    request.setAttribute("Reg_msg", "SQL ERROR");
                    request.setAttribute("Reg_clz", "alert-danger");
                    request.getRequestDispatcher("admin/AddUser.jsp").forward(request, response);
                }
                DatabaseConnection.closeConnection(conn);
            }
        } catch (SQLException e) {
            request.setAttribute("Reg_msg", " " + e);
            request.setAttribute("Reg_clz", "alert-danger");
            request.getRequestDispatcher("admin/AddUser.jsp").forward(request, response);

        }
    }
}
