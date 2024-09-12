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

        <title>Payment Gateway</title>

        <!-- Google font -->
        <link href="https://fonts.googleapis.com/css?family=Lato:400,700" rel="stylesheet">

        <!-- Bootstrap -->
        <link type="text/css" rel="stylesheet" href="assets/css/bootstrap.min.css" />

        <!-- Custom stlylesheet -->
        <link type="text/css" rel="stylesheet" href="assets/style.css" />
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">


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
                    String user_id = (String) request.getAttribute("user_id");
                    String flight_id = (String) request.getAttribute("flight_id");
                    String fare = (String) request.getAttribute("fare");
                    String psg = (String) request.getAttribute("psg");
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
            <div class="row center-row2  d-flex align-items-center justify-content-center">
                <div class="container-fluid py-3">
                    <div class="row">

                        <div class="col-12 col-sm-8 col-md-6 col-lg-4 mx-auto">
                            <h1 class="text-center text-light">PAY INVOICE</h1>
                            <!--<p>USER ID </p>-->
<!--                            <p>FLIGHT ID <%= flight_id%></p>
                            <p>PSG <%= psg%></p>-->
                            <div id="pay-invoice" class="card">
                                <div class="card-body">
                                    <label for="fname">Accepted Cards</label>
                                    <div class="icon-container">
                                        <i class="fa fa-cc-visa fa-3x" style="color:navy;"></i>
                                        <i class="fa fa-cc-amex fa-3x" style="color:blue;"></i>
                                        <i class="fa fa-cc-mastercard fa-3x" style="color:red;"></i>
                                        <i class="fa fa-cc-discover fa-3x" style="color:orange;"></i>
                                        <i class="fa fa-cc-stripe fa-3x" style="color:blue;"></i>
                                        
                                    </div>
                                    <hr>
                                    <% String Login_msg = (String) request.getAttribute("Login_msg");
                                        String Login_clz = (String) request.getAttribute("Login_clz");
                                        if (Login_msg != null && Login_clz != null) {
                                    %>

                                    <div class="alert <%= Login_clz%> alert-dismissible fade show mt-4" role="alert">
                                        <strong><h4>$<%= fare%></h4> <%= Login_msg%> </strong> 
                                        <!--<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>-->
                                    </div>
                                    <div class="text-center">
                                        <%
                                            }
                                        %>
                                        <form action="UserPaymentController" method="post" novalidate="novalidate" class="needs-validation" >
                                            <input class="form-control " name="psg" type="text" value="<%= psg%>" hidden>
                                            <input class="form-control " name="user_id" type="text" value="<%= user_id%>" hidden>
                                            <input class="form-control " name="flight_id" type="text" value="<%= flight_id%>" hidden>
                                            <input class="form-control " name="fare" type="text" value="<%= fare%>" hidden>
                                            <div class="form-group">
                                                <label for="cc-number" class="control-label mb-1">Card number</label>
                                                <input id="cc-number" name="cc_number" type="tel" class="form-control cc-number identified visa" required autocomplete="off"  >
                                                <span class="invalid-feedback">Enter a valid 12 to 16 digit card number</span>
                                            </div>
                                            <div class="row">
                                                <div class="col-6">
                                                    <div class="form-group">
                                                        <label for="cc-exp" class="control-label mb-1">Expiration</label>
                                                        <input id="cc-exp" name="cc_exp" type="text" class="form-control cc-exp" required placeholder="MM / YY" autocomplete="cc-exp">
                                                        <span class="invalid-feedback">Enter the expiration date</span>
                                                    </div>
                                                </div>
                                                <div class="col-6 p-0">
                                                    <label for="x_card_code" class="control-label mb-1">CVV</label>
                                                    <div class="row">
                                                        <div class="col pr-0">
                                                            <input id="x_card_code" name="cvv" type="password" class="form-control cc-cvc" required autocomplete="off">
                                                        </div><!-- log on to codeastro.com for more projects -->
                                                        <div class="col pr-0">                            
                                                            <span class="invalid-feedback order-last">Enter the 3-digit code on back</span>
                                                            <div class="input-group-append"><!-- log on to codeastro.com for more projects -->
                                                                <div class="input-group-text">
                                                                    <span class="fa fa-question-circle fa-lg" data-toggle="popover" data-container="body" data-html="true" data-title="CVV" 
                                                                          data-content="<div class='text-center one-card'>The 3 digit code on back of the card..<div class='visa-mc-cvc-preview'></div></div>"
                                                                          data-trigger="hover"></span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <br/>

                                            <div class='form-row'>
                                                <div class='col-md-12 mb-2'>
                                                    <button id="payment-button" type="submit"  name="pay_but"
                                                            class="btn btn-lg btn-primary btn-block">
                                                        <i class="fa fa-lock fa-lg"></i>&nbsp;
                                                        <span id="payment-button-amount">Pay </span>
                                                        <span id="payment-button-sending" style="display:none;">Sending…</span>
                                                    </button>
                                                </div>

                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>




                <script src="assets/js/popper.min.js"></script>
                <script src="assets/js/bootstrap.min.js"></script>
                <script src="assets/jquery-3.6.0.min.js"></script>
                <script src="assets/js/44f557ccce.js"></script>
                <script>
                    $(document).ready(function () {
                        $('.input-group input').focus(function () {
                            me = $(this);
                            $("label[for='" + me.attr('id') + "']").addClass("animate-label");
                        });
                        $('.input-group input').blur(function () {
                            me = $(this);
                            if (me.val() == "") {
                                $("label[for='" + me.attr('id') + "']").removeClass("animate-label");
                            }
                        });
                    });

                    $(function () {
                        $('[data-toggle="popover"]').popover()
                    })



                    $("#payment-button").click(function (e) {

                        var form = $(this).parents('form');

                        var cvv = $('#x_card_code').val();
                        var regCVV = /^[0-9]{3,4}$/;
                        var CardNo = $('#cc-number').val();
                        var regCardNo = /^[0-9]{12,16}$/;
                        var date = $('#cc-exp').val().split('/');
                        var regMonth = /^01|02|03|04|05|06|07|08|09|10|11|12$/;
                        var regYear = /^20|21|22|23|24|25|26|27|28|29|30|31$/;

                        if (form[0].checkValidity() === false) {
                            e.preventDefault();
                            e.stopPropagation();
                        } else {
                            if (!regCardNo.test(CardNo)) {

                                $("#cc-number").addClass('required');
                                $("#cc-number").focus();
                                alert(" Enter a valid 10 to 16 card number");
                                return false;
                            } else if (!regCVV.test(cvv)) {

                                $("#x_card_code").addClass('required');
                                $("#x_card_code").focus();
                                alert(" Enter a valid CVV");
                                return false;
                            } else if (!regMonth.test(date[0]) && !regMonth.test(date[1])) {

                                $("#cc_exp").addClass('required');
                                $("#cc_exp").focus();
                                alert(" Enter a valid exp date");
                                return false;
                            }



                            form.submit();
                        }

                        form.addClass('was-validated');
                    });
                </script>


                </body>

                </html>
