<%-- 
    Document   : index
    Created on : Mar 11, 2024, 9:55:40 PM
    Author     : iduni
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="Models.DatabaseConnection"%>
<%@page import="Models.DatabaseConnection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
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
        <jsp:param name="title" value="Flights" />
    </jsp:include>

    <body class="hold-transition sidebar-mini layout-fixed">
        <div class="wrapper">

            

            <jsp:include page="IncludeNav.jsp" />

            <jsp:include page="IncludeSideBar.jsp" />

            <!-- Content Wrapper. Contains page content -->
            <div class="content-wrapper">
                <jsp:include page="IncludeBreadCrumb.jsp">
                    <jsp:param name="path" value="Flights" />
                </jsp:include>
                <!-- /.content-header -->

                <!-- Main content -->
                <section class="content">
                    <div class="container-fluid">
                        <!-- Small boxes (Stat box) -->
                        <div class="row">
                            <!-- ./col -->
                            <div class="col-md-12">
                                <% String msg = (String) request.getAttribute("msg");
                                    String clz = (String) request.getAttribute("clz");
                                    if (msg != null && clz != null) {
                                %>

                                <div class="alert <%= clz%> alert-dismissible fade show mt-4" role="alert">
                                    <strong><%= msg%></strong> 

                                </div>
                                <%
                                    }
                                %>
                            </div>
                            <div class="col-md-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">All Flights</h3>
                                        <div class="card-tools">
                                            <div class="input-group input-group-sm" style="width: 250px;">
                                                <input type="text" name="table_search" class="form-control float-right" placeholder="Search">
                                                <div class="input-group-append">
                                                    <button type="submit" class="btn btn-default">
                                                        <i class="fas fa-search"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- /.card-header -->
                                    <div class="card-body table-responsive p-0" style="height: 600px;">
                                        <table class="table table-hover table-head-fixed text-nowrap">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>First Name</th>
                                                    <th>Last Name</th>
                                                    <th>Username</th>
                                                    <th>Email</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    try (Connection conn = DatabaseConnection.getConnection()) {

                                                        String checkSql = "SELECT * FROM admin";
                                                        PreparedStatement checkStmt = conn.prepareStatement(checkSql);

                                                        ResultSet checkResult = checkStmt.executeQuery();

                                                        while (checkResult.next()) {
                                                            String id = checkResult.getString("id");
                                                %>
                                                <tr>
                                                    <td><%= checkResult.getString("id")%></td>
                                                    <td><%= checkResult.getString("fname")%></td>
                                                    <td><%= checkResult.getString("lname")%></td>
                                                    <td><%= checkResult.getString("username")%></td>
                                                    <td><%= checkResult.getString("email")%></td>
<!--                                                    <td><a class="btn btn-sm btn-success"  href="update.jsp?id=<%=id%>">Edit</a>
                                                        <a class="btn btn-sm btn-danger" href="${pageContext.request.contextPath}/FlightDeleteController?id=<%=id%>" onclick="return confirm('Are you sure you want to delete?')">Delete</a>
                                                    </td> -->
                                                </tr>

                                                <%

                                                        }
                                                    } catch (SQLException ex) {
                                                        System.out.println(ex);
                                                    }
                                                %>
                                            </tbody>
                                        </table>
                                    </div>
                                    <!-- /.card-body -->
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <!-- ./col -->

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
    </body>

</html>