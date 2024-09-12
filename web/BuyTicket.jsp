<%-- 
    Document   : index
    Created on : Mar 18, 2024, 11:04:27 PM
    Author     : iduni
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="Models.DatabaseConnection"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

        <title>Buy Ticekts</title>

        <!-- Google font -->
        <link href="https://fonts.googleapis.com/css?family=Lato:400,700" rel="stylesheet">

        <!-- Bootstrap -->
        <link type="text/css" rel="stylesheet" href="assets/css/bootstrap.min.css" />

        <!-- Custom stlylesheet -->
        <link type="text/css" rel="stylesheet" href="assets/style.css" />

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
                  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
                  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
                <![endif]-->
        <style>

            .center-row2 {

                min-height: 92vh; /* Adjust as needed */
            }
        </style>

    </head>

    <body>


        <div class="container-fluid " id="booking">
            <div class="row">
                <%
                    String fname = (String) session.getAttribute("FNAME");
                    String lname = (String) session.getAttribute("LNAME");
                    String flight_id = request.getParameter("flight_id");
                    String passenger = request.getParameter("passenger");
                    String fare = request.getParameter("fare");
                    int psg = Integer.parseInt(passenger);
                    String user_id = String.valueOf(session.getAttribute("ID"));
                %>
                <nav class="navbar sticky-top navbar-expand-lg " >
                    <div class="container-fluid">
                        <a class="navbar-brand" href="index.jsp">ABC Flight</a>

                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                                data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                                aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse " id="navbarSupportedContent">
                            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                                <!--                                <li class="nav-item me-2">
                                                                    <a class="nav-link active" aria-current="page" href="index.jsp">Home</a>
                                                                </li>-->
                            </ul>
                            <div class="ms-auto">
                                <ul class="navbar-nav">

                                    <%
                                        if (fname == null) {
                                    %>
                                    <li class="nav-item">
                                        <a class="nav-link" href="register.jsp">Register</a>
                                    </li>
                                    <li class="nav-item dropdown ">
                                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                                           aria-expanded="false">
                                            Login
                                        </a>
                                        <ul class="dropdown-menu dropdown-menu-end dropdown-menu-lg-end">
                                            <li><a class="dropdown-item" href="login.jsp">User</a></li>
                                            <li><a class="dropdown-item" href="admin/">Admin</a></li>
                                        </ul>
                                    </li>
                                    <%
                                    } else {
                                    %>
                                    <li class="nav-item">
                                        <a class="nav-link" href="myflights.jsp">My Flights</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="tickets.jsp">Tickets</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link  text-danger" href="UserLogOutController">Logout</a>
                                    </li>
                                    <% } %>

                                </ul>
                            </div>

                        </div>

                    </div>
                </nav>
            </div>
            <div class="row center-row2  d-flex align-items-center justify-content-center">
                <div class="col-md-4">
                    <div class="booking-cta">
                        <%
                            if (fname != null) {
                        %>
                        <h4>Welcome <%= fname + " " + lname%></h4>
                        <% } %>
                        <h1>Buy your flight tickets</h1>
                        <!--<p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate laboriosam numquam at</p>-->
                    </div>
                </div>
                <div class="col-md-7">
                    <div class="booking-form">
                        <form action="UserBuyTicketController" method="post">
                            <input class="form-control " name="psg" type="text" value="<%= passenger%>" hidden>
                            <!--getting city names-->
                            <%
                                String cityFrom = "";
                                String cityTo = "";
                                try (Connection conn = DatabaseConnection.getConnection()) {
                                    String sql = "SELECT * FROM flight where flight_id =?";
                                    PreparedStatement checkStmt = conn.prepareStatement(sql);
                                    checkStmt.setString(1, flight_id);
                                    ResultSet checkResult = checkStmt.executeQuery();

                                    while (checkResult.next()) {
                                        cityFrom = checkResult.getString("source");
                                        cityTo = checkResult.getString("Destination");
                                    }
                                } catch (SQLException ex) {
                                    System.out.println(ex);
                                }
                            %>
                            <input class="form-control " name="user_id" type="text" value="<%= user_id%>" hidden>
                            <input class="form-control " name="flight_id" type="text" value="<%= flight_id%>" hidden>
                            <input class="form-control " name="fare" type="text" value="<%= fare%>" hidden>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>From</label>
                                        <input class="form-control " name="cityFrom" type="text" value="<%= cityFrom%>" disabled>
                                        <span class="select-arrow"></span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>To</label>
                                        <input class="form-control" name="cityTo" type="text" value="<%= cityTo%>" disabled>
                                        <span class="select-arrow"></span>

                                    </div>
                                </div>
                            </div>
                                        <hr>
                            <% 
                                for (int i = 1; i <= psg; i++) {
                            %>
                            <h5 class="text-center">Passenger <%=i %></h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Fname</label>
                                        <input class="form-control " name="fname<%=i %>" type="text" value="<%= fname%>" >
                                        <span class="select-arrow"></span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Lname</label>
                                        <input class="form-control" name="lname<%=i %>" type="text" value="<%= lname%>" >
                                        <span class="select-arrow"></span>

                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Mobile</label>
                                        <input class="form-control" name="mobile<%=i %>" type="number" value="<%= passenger%>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>DOB</label>
                                        <input class="form-control" name="dob<%=i %>" type="date" required>
                                    </div>
                                </div>
                            </div>
                                    <hr>
                            <% }
                            %>
                            <!--                            <div class="row">
                                                            <div class="col-md-4">
                                                                <div class="form-group">
                                                                    <label>Adults</label>
                                                                    <input class="form-control" name="adult_count" type="number" placeholder="Adult Count" required>
                                                                    <span class="select-arrow"></span>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <div class="form-group">
                                                                    <label>Children</label>
                                                                    <input class="form-control" name="children_count" type="number" placeholder="Children Count" required>
                                                                    <span class="select-arrow"></span>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <div class="form-group">
                                                                    <label>Class</label>
                                                                    <select class="form-control" name="fclass" required>
                                                                        <option value="economy">Economy class</option>
                                                                        <option value="business">Business class</option>
                                                                        <option value="first">First class</option>
                                                                    </select>
                                                                    <span class="select-arrow"></span>
                                                                </div>
                                                            </div>
                                                        </div>-->
                            <div class="form-btn">
                                <button name="buy_ticket" class="submit-btn">Buy Tickets</button>
                            </div>
                        </form>
                        <% String Login_msg = (String) request.getAttribute("Login_msg");
                            String Login_clz = (String) request.getAttribute("Login_clz");
                            if (Login_msg != null && Login_clz
                                    != null) {
                        %>

                        <div class="alert <%= Login_clz%> alert-dismissible fade show mt-4" role="alert">
                            <strong><%= Login_msg%></strong> 
                            <!--<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>-->
                        </div>
                        <div class="text-center">
                            <%
                                }
                            %>
                            <% String success = (String) request.getAttribute("success");
                                if (success
                                        != null) {
                            %>
                            <div class="alert alert-success alert-dismissible fade show mt-4" role="alert">
                                <strong>Flights Available </strong> 
                                <a class="btn btn-sm btn-success ms-2" href="#flight">See The Flight</a>
                            </div>

                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </div>




        <script src="assets/js/popper.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>


    </body>

</html>
