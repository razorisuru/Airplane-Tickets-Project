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

            @font-face {
                font-family: 'product sans';
                src: url('assets/css/Product Sans Bold.ttf');
            }
            h2.brand {
                /* font-style: italic; */
                font-size: 27px !important;
            }
            .vl {
                border-left: 6px solid #424242;
                height: 400px;
            }
            p.head {
                text-transform: uppercase;
                font-family: Tahoma, sans-serif;
                font-size: 17px;
                margin-bottom: 10px ;
                color: blue;  
            }
            p.txt {
                text-transform: uppercase;
                font-family: arial;
                font-size: 25px;
                font-weight: bolder;
            }
            .out {
                border-top-left-radius: 25px;
                border-bottom-left-radius: 25px;
                background: rgba(196, 255, 75, 0.49);
                backdrop-filter: blur(9.7px);
                -webkit-backdrop-filter: blur(9.7px);
                box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19); 
                padding-left: 25px;
                padding-right: 0px;
                padding-top: 20px;
            }
            h2 {
                font-weight: lighter !important;
                font-size: 35px !important;
                margin-bottom: 20px;  
                font-family :'product sans' !important;
                font-weight: bolder;
            }
            .text-light2 {
                color: #d9d9d9;
            }
            h3 {
                /* font-weight: lighter !important; */
                font-size: 21px !important;
                margin-bottom: 20px;  
                font-family: Tahoma, sans-serif;
                font-weight: lighter;
            }
            h1 {
                font-weight: lighter !important;
                font-size: 45px !important;
                margin-bottom: 20px;  
                font-family :'product sans' !important;
                font-weight: bolder;
            }


            .cd2 {
                background-color:#3979FF !important;
                padding:20px; 
                border-top-right-radius: 25px; 
                border-bottom-right-radius: 25px;
                backdrop-filter: blur(9.7px);
                -webkit-backdrop-filter: blur(9.7px);
                box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19); 
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
                    <h1 class="text-center text-light mt-4 mb-4">E-TICKETS</h1>
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

                    %>
                    <div class="row mb-5">                                                         
                        <div class="col-8 out">
                            <div class="row ">                                                     
                                <div class="col">
                                    <h2 class="text-light mb-0 brand">
                                        ABC Flight Booking #<%= ticket_id%></h2> 
                                </div>
                                <div class="col">
                                    <h2 class="mb-0">CLASS <%= checkResult.getString("class")%></h2>
                                </div>
                            </div>
                            <hr>
                            <%
                                try (PreparedStatement checkFlightStmt = conn.prepareStatement("SELECT * FROM flight WHERE flight_id=?")) {
                                    checkFlightStmt.setString(1, flight_id);

                                    ResultSet checkFlightResult = checkFlightStmt.executeQuery();

                                    while (checkFlightResult.next()) {

                            %>
                            <div class="row mb-3">  
                                <div class="col-4">
                                    <p class="head">Airline</p>
                                    <p class="txt"><%= checkFlightResult.getString("airline")%></p>
                                </div>            
                                <div class="col-4">
                                    <p class="head">from</p>
                                    <p class="txt"><%= checkFlightResult.getString("source")%></p>
                                </div>
                                <div class="col-4">
                                    <p class="head">to</p>
                                    <p class="txt"><%= checkFlightResult.getString("Destination")%></p>                
                                </div>
                            </div>
                            <%
                                try (PreparedStatement checkPsgStmt = conn.prepareStatement("SELECT * FROM passenger_profile WHERE passenger_id=?")) {
                                    checkPsgStmt.setString(1, passenger_id);

                                    ResultSet checkPsgResult = checkPsgStmt.executeQuery();

                                    while (checkPsgResult.next()) {

                            %>
                            <div class="row mb-3">
                                <div class="col-8">
                                    <p class="head">Passenger</p>
                                    <p class=" h5 text-uppercase">
                                        <%= checkPsgResult.getString("f_name")%> <%= checkPsgResult.getString("l_name")%>
                                    </p>                              
                                </div>
                                <div class="col-4">
                                    <p class="head">Mobile</p>
                                    <p class="txt"><%= checkPsgResult.getString("mobile")%></p>
                                </div> 
                                <%                        }
                                    } catch (SQLException ex) {
                                        out.println(ex);
                                    }
                                %>
                            </div>
                            <%
                                String dep_date = checkFlightResult.getString("departure").substring(0, 10);
                                String dep_time = checkFlightResult.getString("departure").substring(10, 16);
                                String arr_date = checkFlightResult.getString("arrival").substring(0, 10);
                                String arr_time = checkFlightResult.getString("arrival").substring(10, 16);
                            %>
                            <div class="row">
                                <div class="col-3">
                                    <p class="head">departure</p>
                                    <p class="txt mb-1"><%= dep_date%></p>
                                    <p class="h1 font-weight-bold mb-3"><%= dep_time%></p>  
                                </div>            
                                <div class="col-3">
                                    <p class="head">arrival</p>
                                    <p class="txt mb-1"><%= arr_date%></p>
                                    <p class="h1 font-weight-bold mb-3"><%= arr_time%></p>  
                                </div>
                                <%                        }
                                    } catch (SQLException ex) {
                                        out.println(ex);
                                    }
                                %>
                                <div class="col-3">
                                    <p class="head">gate</p>
                                    <p class="txt">A22</p>
                                </div>            
                                <div class="col-3">
                                    <p class="head">seat</p>
                                    <p class="txt"><%= checkResult.getString("seat_no")%></p>
                                </div>                
                            </div>                    
                        </div>
                        <div class="col-3 pl-0 cd2">
                            <div class="row">  
                                <div class="col">                                    
                                    <h2 class="text-light text-center brand">
                                        ABC Flight Booking</h2> 
                                </div>                                      
                            </div>                             
                            <div class="row justify-content-center">
                                <div class="col-12">                                    
                                    <img src="img/qr.png" class="mx-auto d-block img-fluid img-thumbnail"
                                        alt="">
                                </div>                                
                            </div>
                            <div class="row">
                                <h3 class="text-light2 text-center mt-2 mb-0">
                                    &nbsp Thank you for choosing us. </br> </br>
                                    Please be at the gate at boarding time</h3>   
                            </div>                            
                        </div>   

                        <div class="col-1">
                            <div class="nav-item dropdown btn btn-danger">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                                   aria-expanded="false">
                                    X
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-lg-end">
                                    <li><a class="dropdown-item" target="blank" href="PrintTicket.jsp?ticket_id=<%= ticket_id%>">Print</a></li>
                                    <li><a class="dropdown-item" href="TicketCancelController?ticket_id=<%= ticket_id%>" onclick="return confirm('Are you sure you want to cancel?')">Cancel</a></li>
                                    
                                </ul>
                            </div>            
                        </div>                          
                    </div>
                    <%                    }
                        } catch (SQLException ex) {
                            out.println(ex);
                        }
                    %>
                    <!--end while-->
                </div>
                <br>
            </div>
        </div>
     



        <script src="assets/js/popper.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>


    </body>

</html>
