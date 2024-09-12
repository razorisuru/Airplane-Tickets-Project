<%-- 
    Document   : index
    Created on : Mar 11, 2024, 9:55:40 PM
    Author     : iduni
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    session = request.getSession(false); // Do not create a new session if it doesn't exist

    if (session == null || session.getAttribute("ID") == null) {
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html lang="en">

    <jsp:include page="IncludeHead.jsp">
        <jsp:param name="title" value="Add User" />
    </jsp:include>

    <body class="hold-transition sidebar-mini layout-fixed">
        <div class="wrapper">



            <jsp:include page="IncludeNav.jsp" />

            <jsp:include page="IncludeSideBar.jsp" />

            <!-- Content Wrapper. Contains page content -->
            <div class="content-wrapper">
                <!-- Content Header (Page header) -->
                <jsp:include page="IncludeBreadCrumb.jsp">
                    <jsp:param name="path" value="Add User" />
                </jsp:include>


                <!-- Main content -->
                <section class="content">
                    <div class="container-fluid">
                        <!-- Small boxes (Stat box) -->
                        <div class="row">
                            <!-- ./col -->
                            <div class="col-md-12">
                                <% String Reg_msg = (String) request.getAttribute("Reg_msg");
                                    String Reg_clz = (String) request.getAttribute("Reg_clz");
                                    if (Reg_msg != null && Reg_clz != null) {
                                %>

                                <div class="alert <%= Reg_clz%> alert-dismissible fade show mt-4" role="alert">
                                    <strong><%= Reg_msg%></strong> 
                                    <!--<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>-->
                                </div>

                                <%
                                    }
                                %>
                            </div>
                        </div>
                        <div class="row">
                            <!-- ./col -->
                            <div class="col-md-12">
                                <!-- general form elements -->
                                <div class="card card-primary">
                                    <div class="card-header">
                                        <h3 class="card-title">Add User</h3>
                                    </div>
                                    <!-- /.card-header -->
                                    <!-- form start -->
                                    <form action="${pageContext.request.contextPath}/AddUserController" method="POST" id="passwordForm">
                                        <div class="card-body">

                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-6">
                                                        <label for="exampleInputFirstName">First Name</label>
                                                        <input type="text" class="form-control" name="fname" placeholder="First Name">
                                                    </div>
                                                    <div class="col-6">
                                                        <label for="exampleInputlastName">Last Name</label>
                                                        <input type="text" class="form-control" name="lname" placeholder="Last Name">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="exampleInputUsername">Username</label>
                                                <input type="text" class="form-control" name="username" id="exampleInputUsername" placeholder="Enter Username">
                                            </div>
                                            <div class="form-group">
                                                <label for="exampleInputEmail1">Email address</label>
                                                <input type="email" class="form-control" name="email" id="exampleInputEmail1" placeholder="Enter email">
                                            </div>
                                            <div class="form-group">
                                                <label for="exampleInputPassword1">New Password</label>
                                                <input type="password" class="form-control" id="password" name="password" id="exampleInputPassword1" placeholder="Password">
                                            </div>
                                            <div class="form-group">
                                                <label>Role</label>
                                                <select class="form-control" name="role">
                                                    <option value="admin">Admin</option>
                                                    <option value="employee">Employee</option>
                                                    <option selected name="user">User</option>                                       
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="exampleInputFile">Profile Picture</label>
                                                <div class="input-group">
                                                    <div class="custom-file">
                                                        <input type="file" class="custom-file-input" name="dp" id="exampleInputFile">
                                                        <label class="custom-file-label" for="exampleInputFile">Choose file</label>
                                                    </div>

                                                </div>
                                            </div>

                                        </div>
                                        <!-- /.card-body -->

                                        <div class="card-footer">
                                            <button type="submit" class="btn btn-primary">Submit</button>
                                        </div>
                                    </form>
                                </div>
                                <!-- /.card -->
                            </div>
                            <!-- /.row -->
                            <!-- Main row -->
                            <div class="row">

                                <!-- /.row (main row) -->
                            </div><!-- /.container-fluid -->
                        </div>
                </section>
                <!-- /.content -->
            </div>
            <!-- /.content-wrapper -->
            <footer class="main-footer">
                <strong>Copyright &copy; 2021-2024 <a href="https://razorisuru.com">RaZoR ISURU</a>.</strong>
                All rights reserved.
                <div class="float-right d-none d-sm-inline-block">

                </div>
            </footer>

            <!-- Control Sidebar -->
            <aside class="control-sidebar control-sidebar-dark">
                <!-- Control sidebar content goes here -->
            </aside>
            <!-- /.control-sidebar -->
        </div>
        <!-- ./wrapper -->

        <jsp:include page="IncludeFooter.jsp" />
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
