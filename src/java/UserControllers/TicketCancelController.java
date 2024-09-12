/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserControllers;

import Models.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "TicketCancelController", urlPatterns = {"/TicketCancelController"})
public class TicketCancelController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");

        String ticket_id = request.getParameter("ticket_id");
//        out.println(ticket_id);

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "DELETE from ticket where ticket_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, ticket_id);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                request.setAttribute("Login_msg", "Successfully Canceled.");
                request.setAttribute("Login_clz", "alert-success");
                request.getRequestDispatcher("/tickets.jsp").forward(request, response);

            } else {
                request.setAttribute("Login_msg", "Data error.");
                request.setAttribute("Login_clz", "alert-warning");
                request.getRequestDispatcher("/tickets.jsp").forward(request, response);
            }
            DatabaseConnection.closeConnection(conn);

        } catch (SQLException e) {
            request.setAttribute("Login_msg", "" + e);
            request.setAttribute("Login_clz", "alert-danger");
            request.getRequestDispatcher("/tickets.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}
