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
import java.sql.ResultSet;
import java.sql.SQLException;
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
@WebServlet(name = "AddFlightController", urlPatterns = {"/AddFlightController"})
public class AddFlightController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);

        String dep_date = request.getParameter("dep_date");
        String dep_time = request.getParameter("dep_time");
        String arr_date = request.getParameter("arr_date");
        String arr_time = request.getParameter("arr_time");
        String dep_city = request.getParameter("dep_city");
        String arr_city = request.getParameter("arr_city");
        String duration = request.getParameter("duration");
        String price = request.getParameter("price");
        String airline_name = request.getParameter("airline_name");

        int ID = (Integer) session.getAttribute("ID");

//        out.println(source_date + " " + source_time+":00");
//        out.println(dest_date + " " + dest_time+":00");
//        out.println(ID);
//        out.println(dest_time);
//        out.println(dep_city);
//        out.println(arr_city);
//        out.println(duration);
//        out.println(price);
//        out.println(airline_name);
//        out.println(ID);
        if (dep_city.equals(arr_city)) {
            request.setAttribute("flight_msg", "Can not select same city.");
            request.setAttribute("flight_clz", "alert-danger");
            request.getRequestDispatcher("admin/AddFlight.jsp").forward(request, response);
        } else if(dep_city.equals("null")){
            request.setAttribute("flight_msg", "Empty Fields.");
            request.setAttribute("flight_clz", "alert-danger");
            request.getRequestDispatcher("admin/AddFlight.jsp").forward(request, response);
        }else {
            String airline_seats = "";
            try (Connection conn = DatabaseConnection.getConnection()) {

                String checkSql = "SELECT * FROM airline WHERE name = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, airline_name);

                ResultSet checkResult = checkStmt.executeQuery();

                if (checkResult.next()) {
                    airline_seats = checkResult.getString("seats");

                } else {
                    airline_seats = "13";
                }
            } catch (SQLException ex) {
                request.setAttribute("flight_msg", ex);
                request.setAttribute("flight_clz", "alert-danger");
                request.getRequestDispatcher("admin/login.jsp").forward(request, response);
            }
            try (Connection conn = DatabaseConnection.getConnection()) {

                String sql = "INSERT INTO flight(admin_id, departure, arrival, source, Destination, airline, Seats, duration, Price, status, issue) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, ID);
                stmt.setString(2, dep_date + " " + dep_time);
                stmt.setString(3, arr_date + " " + arr_time);
                stmt.setString(4, dep_city);
                stmt.setString(5, arr_city);
                stmt.setString(6, airline_name);
                stmt.setString(7, airline_seats);
                stmt.setString(8, duration);
                stmt.setString(9, price);
                stmt.setString(10, "");
                stmt.setString(11, "");

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    request.setAttribute("flight_msg", "Added.");
                    request.setAttribute("flight_clz", "alert-success");
                    request.getRequestDispatcher("admin/AddFlight.jsp").forward(request, response);

                } else {
                    request.setAttribute("flight_msg", "There are no Flights Available.");
                    request.setAttribute("flight_clz", "alert-danger");
                    request.getRequestDispatcher("admin/AddFlight.jsp").forward(request, response);
                }
            } catch (SQLException ex) {
                String err = ""+ex;
                if (err.equals("java.sql.SQLException: Departure date must be before arrival date")) {
                    request.setAttribute("flight_msg", "Departure date must be before arrival date");
                    request.setAttribute("flight_clz", "alert-danger");
                    request.getRequestDispatcher("admin/AddFlight.jsp").forward(request, response);
                } else {
                    request.setAttribute("flight_msg", "" + ex);
                    request.setAttribute("flight_clz", "alert-danger");
                    request.getRequestDispatcher("admin/AddFlight.jsp").forward(request, response);
                }

            }
        }

    }

}
