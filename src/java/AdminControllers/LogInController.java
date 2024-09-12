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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author iduni
 */
@WebServlet(name = "LogInController", urlPatterns = {"/LogInController"})
public class LogInController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");
        String sessionToken = UUID.randomUUID().toString();

        String POSTemail = request.getParameter("email");
        String POSTpassword = request.getParameter("password");
        String remember = request.getParameter("remember");

        if (POSTemail.equals("") || POSTpassword.equals("")) {
            request.setAttribute("Login_msg", "Empty Fields.");
            request.setAttribute("Login_clz", "alert-danger");
            request.getRequestDispatcher("admin/login.jsp").forward(request, response);
        } else {
            try (Connection conn = DatabaseConnection.getConnection()) {

                String sql = "{CALL admin_login(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
                try (CallableStatement stmt = conn.prepareCall(sql)) {
                    stmt.setString(1, POSTemail);
                    stmt.setString(2, POSTpassword);
                    stmt.registerOutParameter(3, java.sql.Types.BOOLEAN);
                    stmt.registerOutParameter(4, java.sql.Types.INTEGER);
                    stmt.registerOutParameter(5, java.sql.Types.VARCHAR);
                    stmt.registerOutParameter(6, java.sql.Types.VARCHAR);
                    stmt.registerOutParameter(7, java.sql.Types.VARCHAR);
                    stmt.registerOutParameter(8, java.sql.Types.VARCHAR);
                    stmt.registerOutParameter(9, java.sql.Types.VARCHAR);
                    stmt.execute();

                    boolean success = stmt.getBoolean(3);
                    if (success) {
                        int id = stmt.getInt(4);
                        String username = stmt.getString(7);
                        String fname = stmt.getString(5);
                        String lname = stmt.getString(6);
                        String dp = stmt.getString(9);

                        HttpSession session = request.getSession();
                        session.setAttribute("ID", id);
                        session.setAttribute("UN", username);
                        session.setAttribute("DP_NAME", fname + " " + lname);
                        session.setAttribute("DP", dp);
                        session.setAttribute("sessionToken", sessionToken);
                        response.sendRedirect("admin/index.jsp");
                        if (remember == null) {
                            session.setMaxInactiveInterval(30 * 60);
                        }

                    } else {
                        request.setAttribute("Login_msg", "Incorrect Username and Password.");
                        request.setAttribute("Login_clz", "alert-danger");
                        request.getRequestDispatcher("admin/login.jsp").forward(request, response);
                    }
                }
            } catch (SQLException ex) {
                request.setAttribute("Login_msg", ex);
                request.setAttribute("Login_clz", "alert-danger");
                request.getRequestDispatcher("admin/login.jsp").forward(request, response);
            }
        }

    }
}
