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
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author iduni
 */
@WebServlet(name = "UserRegisterController", urlPatterns = {"/UserRegisterController"})
public class UserRegisterController extends HttpServlet {

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

        if (fname.equals("") || lname.equals("") || username.equals("") || email.equals("") || password.equals("")) {
            request.setAttribute("Login_msg", "Empty Fields.");
            request.setAttribute("Login_clz", "alert-danger");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            try (Connection conn = DatabaseConnection.getConnection()) {
                String sql = "{CALL user_reg(?,?,?,?,?,?)}";
                try (CallableStatement stmt = conn.prepareCall(sql)) {

                    stmt.setString(1, fname);
                    stmt.setString(2, lname);
                    stmt.setString(3, username);
                    stmt.setString(4, email);
                    stmt.setString(5, password);
                    stmt.registerOutParameter(6, java.sql.Types.INTEGER);

                    stmt.executeUpdate();
                    
                    int success = stmt.getInt(6);
                    if (success==1) {
                        request.setAttribute("Login_msg", "Hello " + fname + " ! your registration is success.");
                        request.setAttribute("Login_clz", "alert-success");
                        request.getRequestDispatcher("login.jsp").forward(request, response);

                    } else {
                        request.setAttribute("Login_msg", "Insertion Failed");
                        request.setAttribute("Login_clz", "alert-danger");
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                    }
                    DatabaseConnection.closeConnection(conn);
                }
            } catch (SQLException e) {
                request.setAttribute("Login_msg", " " + e);
                request.setAttribute("Login_clz", "alert-danger");
                request.getRequestDispatcher("register.jsp").forward(request, response);
//            out.println(e);
            }
        }
    }
}
