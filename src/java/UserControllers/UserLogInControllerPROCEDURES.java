/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserControllers;

import AdminControllers.*;
import Models.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
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
@WebServlet(name = "UserLogInController", urlPatterns = {"/UserLogInController"})
public class UserLogInControllerPROCEDURES extends HttpServlet {

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
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            try (Connection conn = DatabaseConnection.getConnection()) {

                String checkSql = "CALL login_user(?, ?, ?)";
                CallableStatement callStmt = conn.prepareCall(checkSql);
                callStmt.setString(1, POSTemail);
                callStmt.setString(2, POSTpassword);
                callStmt.registerOutParameter(3, Types.INTEGER);

                callStmt.execute();

                int success = callStmt.getInt(3);

                if (success == 1) {
                    String getUserInfoSql = "SELECT id, username, email, fname, lname, dp FROM users WHERE email = ?";
                    PreparedStatement getUserInfoStmt = conn.prepareStatement(getUserInfoSql);
                    getUserInfoStmt.setString(1, POSTemail);

                    ResultSet userInfoResult = getUserInfoStmt.executeQuery();

                    if (userInfoResult.next()) {
                        String id = userInfoResult.getString("id");
                        String username = userInfoResult.getString("username");
                        String email = userInfoResult.getString("email");
                        String fname = userInfoResult.getString("fname");
                        String lname = userInfoResult.getString("lname");
                        String dp = userInfoResult.getString("dp");

                        HttpSession session = request.getSession();
                        session.setAttribute("ID", id);
                        session.setAttribute("UN", username);
                        session.setAttribute("FNAME", fname);
                        session.setAttribute("DP", dp);
                        session.setAttribute("sessionToken", sessionToken);
                        response.sendRedirect("index.jsp");
                        if (remember == null) {
                            session.setMaxInactiveInterval(30 * 60);
                        }
                    }
                } else {
                    request.setAttribute("Login_msg", "Incorrect Username and Password.");
                    request.setAttribute("Login_clz", "alert-danger");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } catch (SQLException ex) {
                request.setAttribute("Login_msg", ex);
                request.setAttribute("Login_clz", "alert-danger");
                request.getRequestDispatcher("alogin.jsp").forward(request, response);
            }
        }

    }
}
