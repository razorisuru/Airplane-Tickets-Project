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


            div.out {
                padding: 30px;
                background: rgba(196, 255, 75, 0.49);
                border-radius: 16px;
                /*box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);*/
                backdrop-filter: blur(9.7px);
                -webkit-backdrop-filter: blur(9.7px);
                border: 1px solid rgba(196, 255, 75, 0.92);
                box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19); 
                border-top-left-radius: 20px;
                border-bottom-right-radius: 20px;
            }
            .city {
                font-size: 24px;
            }
            p {
                margin-bottom: 10px;
            }
            .alert {
                /* font-family: 'Courier New', Courier, monospace; */
                font-weight: bold;
            }
            .date {
                font-size: 24px;
            }
            .time {
                font-size: 27px;
                margin-bottom: 0px;
            }
            .stat {
                font-size: 17px;
            }
            h1 {
                font-weight: lighter !important;
                font-size: 45px !important;
                margin-bottom: 20px;  
                font-weight: bolder;
            }


        </style>

    </head>

    <body>


        <div class="container-fluid " id="booking" style="background: rgb(2,0,36);
             background: linear-gradient(90deg, rgba(2,0,36,1) 0%, rgba(9,121,112,1) 0%, rgba(0,228,255,1) 100%);">
            <div class="row">
                <%
                    int ID = (Integer) session.getAttribute("ID");
                    String fname = (String) session.getAttribute("FNAME");
                    String lname = (String) session.getAttribute("LNAME");
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
                                        <a class="nav-link" href="MyFlights.jsp">My Flights</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="tickets.jsp">Tickets</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link  text-danger" href="UserLogOutController">Logout</a>
                                    </li>
                                    <% }%>

                                </ul>
                            </div>

                        </div>

                    </div>
                </nav>
            </div>
            <div class="container">
                <h1 class="text-center text-light ">FLIGHT STATUS</h1>
                <!--start while-->
                <%
                    String ticket_id = "";
                    String passenger_id = "";
                    String flight_id = "";
                    String user_id = "";

                    try (Connection conn = DatabaseConnection.getConnection()) {

                        String checkSql = "SELECT * FROM ticket WHERE user_id=?";
                        PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                        checkStmt.setInt(1, ID);

                        ResultSet checkResult = checkStmt.executeQuery();

                        while (checkResult.next()) {
                            ticket_id = checkResult.getString("ticket_id");
                            passenger_id = checkResult.getString("passenger_id");
                            flight_id = checkResult.getString("flight_id");
                            user_id = checkResult.getString("user_id");

                %>
                <div class="row out mb-5 ">
                    <div class="col-md-4 order-lg-3 order-md-1"> 
                        <div class="row">
                            <div class="col-1 p-0 m-0">
                                <i class="fa fa-circle mt-4 text-success" style="float: right;" aria-hidden="true"></i>
                            </div>                            
                            <div class="col-10 p-0 m-0 mt-3" style="float: right;">
                                <hr class="bg-success">
                            </div>                            
                            <div class="col-1 p-0 m-0">
                                <i class="fa fa-2x fa-fighter-jet mt-3 text-success" aria-hidden="true"></i>
                            </div>                                    
                        </div>                            

                    </div>
                    <%    try (PreparedStatement checkFlightStmt = conn.prepareStatement("SELECT * FROM flight WHERE flight_id=?")) {
                            checkFlightStmt.setString(1, flight_id);

                            ResultSet checkFlightResult = checkFlightStmt.executeQuery();

                            while (checkFlightResult.next()) {
                                String dep_date = checkFlightResult.getString("departure").substring(0, 10);
                                String dep_time = checkFlightResult.getString("departure").substring(10, 16);
                                String arr_date = checkFlightResult.getString("arrival").substring(0, 10);
                                String arr_time = checkFlightResult.getString("arrival").substring(10, 16);

                    %>
                    <div class="col-md-3 col-6 order-md-2 pl-0 text-center 
                         order-lg-2 card-dep">
                        <p class="city"><%= checkFlightResult.getString("source")%></p>
                        <p class="stat">Scheduled Departure:</p>
                        <p class="date"><%= dep_date%></p>                
                        <p class="time"><%= dep_time%></p>
                    </div>        
                    <div class="col-md-3 col-6 order-md-4 pr-0 text-center 
                         order-lg-4 card-arr" style="float: right;">
                        <p class="city"><%= checkFlightResult.getString("Destination")%></p>
                        <p class="stat">Scheduled Arrival:</p>
                        <p class="date"><%= arr_date%></p>                
                        <p class="time"><%= arr_time%></p>          
                    </div>
                    <% String status = checkFlightResult.getString("status");
                        if (status.equals("arr")) { %>
                    <div class="col-lg-2 order-md-12">
                        <div class="alert alert-success mt-5 text-center" role="alert">
                            Arrived
                        </div>
                    </div>  
                    <% } else { %>
                    <div class="col-lg-2 order-md-12">
                        <div class="alert alert-danger mt-5 text-center" role="alert">
                            Departure
                        </div>
                    </div> 
                    <%                       }
                            }
                        } catch (SQLException ex) {
                            out.println(ex);
                        }
                    %>
                    <!--end while-->
                </div> 
                <%                        }
                    } catch (SQLException ex) {
                        out.println(ex);
                    }
                %>
                <!--end while-->
            </div>  
            <br>

        </div>




        <script src="assets/js/popper.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>


    </body>

</html>
