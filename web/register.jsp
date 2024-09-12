<%-- 
    Document   : index
    Created on : Mar 18, 2024, 11:04:27 PM
    Author     : iduni
--%>

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


        <div class="container-fluid center-row1 vh-100" id="booking">
            <div class="row">
                <nav class="navbar sticky-top navbar-expand-lg ">
                    <div class="container-fluid">
                        <a class="navbar-brand" href="index.jsp">ABC Flight</a>
                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                                data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                                aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarSupportedContent">
                            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                                <!--                                <li class="nav-item">
                                                                    <a class="nav-link active" aria-current="page" href="index.jsp">Home</a>
                                                                </li>-->

                                <!-- <li class="nav-item">
                                        <a class="nav-link disabled" aria-disabled="true">Disabled</a>
                                </li> -->
                            </ul>
                            <!-- <form class="d-flex" role="search">
                                    <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                                    <button class="btn btn-outline-success" type="submit">Search</button>
                            </form> -->
                        </div>
                    </div>
                </nav>
            </div>
            <div class="row center-row2  d-flex align-items-center justify-content-center">
                <div class="col-md-4">
                    <div class="booking-cta">
                        <h1>Register Form</h1>
                        <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate laboriosam numquam at</p>
                    </div>
                </div>
                <div class="col-md-7 col-md-offset-1">
                    <div class="booking-form">
                        <form action="UserRegisterController" method="post" id="passwordForm">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>First Name</label>
                                        <input class="form-control" name="fname" type="text" placeholder="First Name">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Last Name</label>
                                        <input class="form-control" name="lname" type="text" placeholder="Last Name">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label>Username</label>
                                        <input class="form-control" name="username" type="text" placeholder="Username">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label>Email</label>
                                        <input class="form-control" name="email" type="email" placeholder="email">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label>Password</label>
                                        <input class="form-control" id="password" name="password" type="password" placeholder="password" >
                                    </div>
                                </div>
                            </div>
                            <div class="icheck-primary mb-2">
                                <input type="checkbox" id="agree" name="agree">
                                <label for="remember">
                                    Agree
                                </label>
                            </div>
                            <div class="form-btn">
                                <button type="submit" class="submit-btn" name="loginbtn">Register</button>
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

                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <script src="assets/js/popper.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script>
            document.getElementById("passwordForm").addEventListener("submit", function (event) {
                event.preventDefault(); // Prevent form submission

                var passwordInput = document.getElementById("password").value;

                if (validatePassword(passwordInput)) {
                    this.submit();
                } else {
                    alert("Password must be 8 characters long, contain at least one special character and one uppercase letter.");
                }
            });

            function validatePassword(password) {
                // Regular expressions to check for requirements
                var lengthRegex = /.{8,}/;
                var specialCharRegex = /[!@#$%^&*(),.?":{}|<>]/;
                var uppercaseRegex = /[A-Z]/;

                // Check if all requirements are met
                return lengthRegex.test(password) && specialCharRegex.test(password) && uppercaseRegex.test(password);
            }
        </script>

    </body>

</html>
