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

        <title>Booking Form</title>

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


        <div class="container-fluid vh-100" id="booking">
            <div class="row">
                <%
                    String fname = (String) session.getAttribute("FNAME");
                    String lname = (String) session.getAttribute("LNAME");
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

                                    <%                                        if (fname == null) {
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
                                        <a class="nav-link" href="MyFlights.jsp">My Flights</a>
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
                        <h1>Book your flight today</h1>
                        <!--<p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate laboriosam numquam at</p>-->
                    </div>
                </div>
                <div class="col-md-7">
                    <div class="booking-form">
                        <form action="SearchFlight" method="post">
                            <div class="form-group">
                                <div class="form-checkbox">
                                    <label for="roundtrip">
                                        <input type="radio" id="roundtrip" name="flight-type" value="roundtrip" checked>
                                        <span></span>Roundtrip
                                    </label>
                                    <label for="one-way">
                                        <input type="radio" id="one-way" name="flight-type" value="one-way">
                                        <span></span>One way
                                    </label>
                                    <!--   <label for="multi-city">
                                          <input type="radio" id="multi-city" name="flight-type">
                                          <span></span>Multi-City
                                  </label> -->
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>From</label>
                                        <%
                                            try (Connection conn = DatabaseConnection.getConnection()) {
                                                String sql = "SELECT city FROM cities";
                                                PreparedStatement checkStmt = conn.prepareStatement(sql);

                                                ResultSet checkResult = checkStmt.executeQuery();

                                                out.println("<select name=\"cityFrom\" class=\"form-control\" required>");
                                                while (checkResult.next()) {
                                                    String cityName = checkResult.getString("city");
                                                    out.println("<option value=\"" + cityName + "\">" + cityName + "</option>");
                                                }

                                                out.println("</select>");

                                            } catch (SQLException ex) {
                                                out.println(ex);
                                            }
                                        %>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>To</label>
                                        <%
                                            try (Connection conn = DatabaseConnection.getConnection()) {
                                                String sql = "SELECT city FROM cities";
                                                PreparedStatement checkStmt = conn.prepareStatement(sql);

                                                ResultSet checkResult = checkStmt.executeQuery();

                                                out.println("<select name=\"cityTo\" class=\"form-control\" required>");
                                                while (checkResult.next()) {
                                                    String cityName = checkResult.getString("city");
                                                    out.println("<option value=" + cityName + ">" + cityName + "</option>");
                                                }

                                                out.println("</select>");

                                            } catch (SQLException ex) {
                                                out.println(ex);
                                            }
                                        %>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Departing</label>
                                        <input class="form-control" name="departing_date" type="date" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Return</label>
                                        <input class="form-control" name="returning_date" type="date" required>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Passenger</label>
                                        <input class="form-control" name="passenger" type="number" placeholder="Adult Count" value="1" required>
                                        <span class="select-arrow"></span>
                                    </div>
                                </div>
                                <!--                                <div class="col-md-4">
                                                                    <div class="form-group">
                                                                        <label>Children</label>
                                                                        <input class="form-control" name="children_count" type="number" placeholder="Children Count" required>
                                                                        <span class="select-arrow"></span>
                                                                    </div>
                                                                </div>-->
                                <div class="col-md-6">
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
                            </div>
                            <div class="form-btn">
                                <button name="search_flight" class="submit-btn">Search flight</button>
                            </div>
                        </form>
                        <% String Login_msg = (String) request.getAttribute("Login_msg");
                            String Login_clz = (String) request.getAttribute("Login_clz");
                            if (Login_msg != null && Login_clz != null) {
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
                                if (success != null) {
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
        <%
            String cityFrom = (String) request.getAttribute("cityFrom");
            String cityTo = (String) request.getAttribute("cityTo");
            String departing_date = (String) request.getAttribute("departing_date");
            String passenger = (String) request.getAttribute("passenger");            
            String flightType = (String) request.getAttribute("flightType");

            if (success != null) {
        %>
        <div class="container-fluid vh-100 d-flex align-items-center justify-content-center" id="flight">
            <div class="container ">
                <div class=" row  ">
                    <div class=" text-center">
                        <h1 class="mt-4"> Flights from <b><%= cityFrom%></b> to <b><%= cityTo%></b></h1>
                    </div>
                    <div class=" text-center mt-4 ">
                        <table class="table table-bordered table-hover ">
                            <thead class="tbl">
                                <tr class="text-center">
                                    <th scope="col">Airline</th>
                                    <th scope="col">Departure</th>
                                    <th scope="col">Arrival</th>
                                    <th scope="col">Status</th>
                                    <th scope="col">Fare</th>
                                    <th scope="col">Buy</th>
                                </tr>
                            </thead>
                            <%
                                try (Connection conn = DatabaseConnection.getConnection()) {

                                    String checkSql = "SELECT * FROM flight WHERE source = ? and Destination = ? and DATE(departure) = ?";
                                    PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                                    checkStmt.setString(1, cityFrom);
                                    checkStmt.setString(2, cityTo);
                                    checkStmt.setString(3, departing_date);

                                    ResultSet checkResult = checkStmt.executeQuery();

                                    while (checkResult.next()) {
                                        String flight_id = checkResult.getString("flight_id");
                                        String price = checkResult.getString("price");
                                        float prc = Float.parseFloat(price);
                                        float psg = Float.parseFloat(passenger);
                                        float fare=0;
                                        if(flightType.equals("one-way")){
                                            fare = prc*psg;
                                        }else{
                                            fare = (prc*psg)*2;
                                        }
                                       
                            %>
                            <tr class="tbl">
                                <td><%= checkResult.getString("airline")%></td>
                                <td><%= checkResult.getString("departure")%></td>
                                <td><%= checkResult.getString("arrival")%></td>
                                <td><%= checkResult.getString("status")%></td>                         
                                <td><%= fare %> $</td>
                                <%
                                    if (fname != null) {
                                %>
                                <td><a class="btn btn-sm btn-success" onclick="return confirm('Are you sure you want to buy?')" href="BuyTicket.jsp?flight_id=<%= flight_id%>&passenger=<%= passenger%>&fare=<%= fare%>">Buy</a>
                                </td> 
                                <% } else {
                                %>
                                <td><a class="btn btn-sm btn-danger" href="login.jsp?id=<%= flight_id%>">Login to buy</a>
                                </td> 
                                <% } %>
                            </tr>

                            <%

                                    }
                                } catch (SQLException ex) {
                                    out.println(ex);
                                }
                            %>
                        </table>

                    </div>
                </div>
            </div>
        </div>

        <%
            }
        %>



        <script src="assets/js/popper.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>


    </body>

</html>
