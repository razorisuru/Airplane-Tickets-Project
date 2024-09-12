/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package AdminControllers;

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
@WebServlet(name = "AddAirlineController", urlPatterns = {"/AddAirlineController"})
public class AddAirlineController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");

        String airline_name = request.getParameter("airline_name");
        String seats = request.getParameter("seats");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO airline(name,seats) VALUES (?,?)";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, airline_name);
            stmt.setString(2, seats);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                request.setAttribute("msg", "Airline Added Successfully");
                request.setAttribute("clz", "alert-success");
                request.getRequestDispatcher("admin/AddAirline.jsp").forward(request, response);

            } else {
                request.setAttribute("msg", "SQL ERROR");
                request.setAttribute("clz", "alert-danger");
                request.getRequestDispatcher("admin/AddAirline.jsp").forward(request, response);
            }
            DatabaseConnection.closeConnection(conn);

        } catch (SQLException e) {
            request.setAttribute("msg", " "+e);
            request.setAttribute("clz", "alert-danger");
            request.getRequestDispatcher("admin/AddAirline.jsp").forward(request, response);
        }
    }
}
