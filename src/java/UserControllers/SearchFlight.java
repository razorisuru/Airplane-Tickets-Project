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
import java.sql.ResultSet;
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
@WebServlet(name = "SearchFlight", urlPatterns = {"/SearchFlight"})
public class SearchFlight extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");

        String cityFrom = request.getParameter("cityFrom");
        String cityTo = request.getParameter("cityTo");
        String departing_date = request.getParameter("departing_date");
        String returning_date = request.getParameter("returning_date");
        String passenger = request.getParameter("passenger");
//        String children_count = request.getParameter("children_count");
        String fclass = request.getParameter("fclass");
        String flightType = request.getParameter("flight-type");

//        out.println(cityFrom);
//        out.println(cityTo);
//        out.println(departing_date);
//        out.println(returning_date);
//        out.println(passenger);
//        out.println(fclass);
        if (cityFrom.equals(cityTo)) {
            request.setAttribute("Login_msg", "Can not select same city.");
            request.setAttribute("Login_clz", "alert-danger");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else {
            try (Connection conn = DatabaseConnection.getConnection()) {

                String checkSql = "SELECT * FROM flight WHERE source = ? and Destination = ? and DATE(departure) = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, cityFrom);
                checkStmt.setString(2, cityTo);
                checkStmt.setString(3, departing_date);

                ResultSet checkResult = checkStmt.executeQuery();

                if (checkResult.next()) {
                    request.setAttribute("passenger", passenger);
                    request.setAttribute("flightType", flightType);
                    request.setAttribute("departing_date", departing_date);
                    request.setAttribute("success", "1");
                    request.setAttribute("cityFrom", "" + cityFrom);
                    request.setAttribute("cityTo", "" + cityTo);

                    request.getRequestDispatcher("index.jsp").forward(request, response);

                } else {
                    request.setAttribute("Login_msg", "There are no Flights Available.");
                    request.setAttribute("Login_clz", "alert-danger");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                }
            } catch (SQLException ex) {
                request.setAttribute("Login_msg", ex);
                request.setAttribute("Login_clz", "alert-danger");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        }

    }

}
