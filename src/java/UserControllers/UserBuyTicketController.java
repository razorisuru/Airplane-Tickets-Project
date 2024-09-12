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
import javax.servlet.http.HttpSession;

/**
 *
 * @author iduni
 */
@WebServlet(name = "UserBuyTicketController", urlPatterns = {"/UserBuyTicketController"})
public class UserBuyTicketController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);

        String passenger = request.getParameter("psg");
        int psg = Integer.parseInt(passenger);
        String user_id = request.getParameter("user_id");
        String flight_id = request.getParameter("flight_id");
        String fare = request.getParameter("fare");

        for (int i = 1; i <= psg; i++) {
            String fname = request.getParameter("fname" + i);
            String lname = request.getParameter("lname" + i);
            String mobile = request.getParameter("mobile" + i);
            String dob = request.getParameter("dob" + i);

//            out.println(fname);
//            out.println(lname);
//            out.println(mobile);
//            out.println(dob);
            try (Connection conn = DatabaseConnection.getConnection()) {
                String sql = "INSERT INTO Passenger_profile (user_id,flight_id, mobile,dob,f_name, l_name) VALUES (?,?,?,?,?,?)";
                PreparedStatement stmt = conn.prepareStatement(sql);

                stmt.setString(1, user_id);
                stmt.setString(2, flight_id);
                stmt.setString(3, mobile);
                stmt.setString(4, dob);
                stmt.setString(5, fname);
                stmt.setString(6, lname);

                int rowsInserted = stmt.executeUpdate();
//            if (rowsInserted > 0) {
//                request.setAttribute("user_id", user_id);
//                request.setAttribute("flight_id", flight_id);
//                request.setAttribute("psg", passenger);
//                request.setAttribute("Login_msg", "Pay for confirmation.");
//                request.setAttribute("Login_clz", "alert-success");
//                request.getRequestDispatcher("PaymentGateway.jsp").forward(request, response);
//
//            } else {
//                request.setAttribute("Login_msg", "Insertion Failed");
//                request.setAttribute("Login_clz", "alert-danger");
//                request.getRequestDispatcher("BuyTicket.jsp").forward(request, response);
//            }
//            DatabaseConnection.closeConnection(conn);

            } catch (SQLException e) {
                request.setAttribute("Login_msg", " " + e);
                request.setAttribute("Login_clz", "alert-danger");
                request.getRequestDispatcher("BuyTicket.jsp").forward(request, response);
            }
        }
        request.setAttribute("user_id", user_id);
        request.setAttribute("flight_id", flight_id);
        request.setAttribute("psg", passenger);
        request.setAttribute("fare", fare);
        request.setAttribute("Login_msg", "Pay for confirmation.");
        request.setAttribute("Login_clz", "alert-success");
        request.getRequestDispatcher("PaymentGateway.jsp").forward(request, response);
    }
}
