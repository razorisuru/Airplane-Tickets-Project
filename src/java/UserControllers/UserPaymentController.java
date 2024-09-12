/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserControllers;

import Models.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
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
@WebServlet(name = "UserPaymentController", urlPatterns = {"/UserPaymentController"})
public class UserPaymentController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);

        String user_id = request.getParameter("user_id");
        String flight_id = request.getParameter("flight_id");
        String psg = request.getParameter("psg");
        String cc_number = request.getParameter("cc_number");
        String cc_exp = request.getParameter("cc_exp");
        String cvv = request.getParameter("cvv");
        String fare = request.getParameter("fare");
        String fname = (String) session.getAttribute("FNAME");
        String lname = (String) session.getAttribute("LNAME");

//        out.println(fname);
//        out.println(lname);
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO payment (card_no ,user_id , flight_id, expire_date, cvv, amount) VALUES (?,?,?,?,?,?)";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, cc_number);
            stmt.setString(2, user_id);
            stmt.setString(3, flight_id);
            stmt.setString(4, cc_exp);
            stmt.setString(5, cvv);
            stmt.setString(6, fare);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                try (CallableStatement callStmt = conn.prepareCall("{CALL ticket_transaction(?)}")) {
                    callStmt.setString(1, psg);
                    callStmt.execute(); // If the procedure returns a result set, use executeQuery() instead

                    // If the stored procedure returns a result set, you can retrieve it using:
                    // ResultSet resultSet = callStmt.getResultSet();
                } catch (SQLException ex) {
                    request.setAttribute("Login_msg", "PRO " + ex);
                    request.setAttribute("Login_clz", "alert-danger");
                    request.getRequestDispatcher("PaymentGateway.jsp").forward(request, response);
                }

//                request.setAttribute("Login_msg", "Payment Success.");
//                request.setAttribute("Login_clz", "alert-success");
//                request.getRequestDispatcher("tickets.jsp").forward(request, response);
                response.sendRedirect("tickets.jsp");

            } else {
                request.setAttribute("Login_msg", "Insertion Failed");
                request.setAttribute("Login_clz", "alert-danger");
                request.getRequestDispatcher("PaymentGateway.jsp").forward(request, response);
            }
            DatabaseConnection.closeConnection(conn);

        } catch (SQLException e) {
            request.setAttribute("Login_msg", " " + e);
            request.setAttribute("Login_clz", "alert-danger");
            request.getRequestDispatcher("PaymentGateway.jsp").forward(request, response);
        }

    }
}
