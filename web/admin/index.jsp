<%-- 
    Document   : index
    Created on : Mar 11, 2024, 9:55:40 PM
    Author     : iduni
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Models.DatabaseConnection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
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
        <jsp:param name="title" value="Home" />
    </jsp:include>

    <body class="hold-transition sidebar-mini layout-fixed">
        <div class="wrapper">



            <jsp:include page="IncludeNav.jsp" />

            <jsp:include page="IncludeSideBar.jsp" />
            <div class="content-wrapper">
                <!-- Content Wrapper. Contains page content -->
                <jsp:include page="IncludeBreadCrumb.jsp">
                    <jsp:param name="path" value="Dashboard" />
                </jsp:include>
                <!-- /.content-header -->

                <%
                    int TotFlights = 0;
                    int TotPsg = 0;
                    int TotAirline = 0;
                    int TotUsers = 0;

                    try (Connection conn = DatabaseConnection.getConnection()) {
                        String[] queries = {
                            "SELECT COUNT(*) AS TotFlights FROM flight",
                            "SELECT COUNT(*) AS TotPsg FROM passenger_profile",
                            "SELECT COUNT(*) AS TotAirline FROM airline",
                            "SELECT COUNT(*) AS TotUsers FROM users"
                        };

                        for (int i = 0; i < queries.length; i++) {
                            PreparedStatement checkStmt = conn.prepareStatement(queries[i]);
                            ResultSet checkResult = checkStmt.executeQuery();
                            if (checkResult.next()) {
                                switch (i) {
                                    case 0:
                                        TotFlights = checkResult.getInt("TotFlights");
                                        break;
                                    case 1:
                                        TotPsg = checkResult.getInt("TotPsg");
                                        break;
                                    case 2:
                                        TotAirline = checkResult.getInt("TotAirline");
                                        break;
                                    case 3:
                                        TotUsers = checkResult.getInt("TotUsers");
                                        break;
                                }
                            }
                            checkStmt.close();
                        }
                    } catch (SQLException ex) {
                        out.println(ex);
                    }

                %>

                <!-- Main content -->
                <section class="content">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-lg-3 col-6">
                                <!-- small box -->
                                <div class="small-box bg-info">
                                    <div class="inner">
                                        <h3><%= TotFlights%></h3>

                                        <p>Flights</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-bag"></i>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/admin/flights.jsp" class="small-box-footer">More info <i class="fas fa-arrow-circle-right"></i></a>
                                </div>
                            </div>
                            <!-- ./col -->
                            <div class="col-lg-3 col-6">
                                <!-- small box -->
                                <div class="small-box bg-success">
                                    <div class="inner">
                                        <h3><%= TotPsg%></h3>

                                        <p>Passengers</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-stats-bars"></i>
                                    </div>
                                    <a href="#" class="small-box-footer">More info <i class="fas fa-arrow-circle-right"></i></a>
                                </div>
                            </div>
                            <!-- ./col -->
                            <div class="col-lg-3 col-6">
                                <!-- small box -->
                                <div class="small-box bg-warning">
                                    <div class="inner">
                                        <h3><%= TotAirline%></h3>

                                        <p>Airlines</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-person-add"></i>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/admin/airlines.jsp" class="small-box-footer">More info <i class="fas fa-arrow-circle-right"></i></a>
                                </div>
                            </div>
                            <!-- ./col -->
                            <div class="col-lg-3 col-6">
                                <!-- small box -->
                                <div class="small-box bg-danger">
                                    <div class="inner">
                                        <h3><%= TotUsers%></h3>

                                        <p>Users</p>
                                    </div>
                                    <div class="icon">
                                        <i class="ion ion-pie-graph"></i>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/admin/users.jsp" class="small-box-footer">More info <i class="fas fa-arrow-circle-right"></i></a>
                                </div>
                            </div>
                            <!-- ./col -->
                        </div>
                        <div class="row">
                            <div class="col-lg-6 col-12">
                                <div class="card">
                                    <div class="card-header border-transparent">
                                        <h3 class="card-title">Latest Flights</h3>

                                        <div class="card-tools">
                                            <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <!--                                            <button type="button" class="btn btn-tool" data-card-widget="remove">
                                                                                            <i class="fas fa-times"></i>
                                                                                        </button>-->
                                        </div>
                                    </div>
                                    <!-- /.card-header -->
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-hover table-head-fixed text-nowrap" id="dataTable2">
                                                <thead>
                                                    <tr>
                                                        
                                                        <th>From</th>
                                                        <th>Date</th> 
                                                        <th>To</th>
                                                        <th>Date</th> 
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        try (Connection conn = DatabaseConnection.getConnection()) {

                                                            String checkSql = "SELECT * from flight ORDER by flight_id DESC LIMIT 5";
                                                            PreparedStatement checkStmt = conn.prepareStatement(checkSql);

                                                            ResultSet checkResult = checkStmt.executeQuery();

                                                            while (checkResult.next()) {
                                                                
                                                    %>
                                                    <tr>
                                                        <td><%= checkResult.getString("source")%></td>
                                                        <td><%= checkResult.getString("departure")%></td>
                                                        <td><%= checkResult.getString("destination")%></td>
                                                        <td><%= checkResult.getString("arrival")%></td>
                                                        
                                                    </tr>

                                                    <%

                                                            }
                                                        } catch (SQLException ex) {
                                                            out.println(ex);
                                                        }
                                                    %>
                                                </tbody>
                                            </table>
                                        </div>
                                        <!-- /.table-responsive -->
                                    </div>
                                    <!-- /.card-body -->
                                    <div class="card-footer clearfix">
                                        <a href="${pageContext.request.contextPath}/admin/AddFlight.jsp" class="btn btn-sm btn-info float-left">Add New Flight</a>
                                        <a href="${pageContext.request.contextPath}/admin/flights.jsp" class="btn btn-sm btn-secondary float-right">View All Flight</a>
                                    </div>
                                    <!-- /.card-footer -->
                                </div>
                            </div>
                            <!-- ./col -->
                            <div class="col-lg-6 col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">Recent Passengers</h3>

                                        <div class="card-tools">
                                            <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <!--                                            <button type="button" class="btn btn-tool" data-card-widget="remove">
                                                                                            <i class="fas fa-times"></i>
                                                                                        </button>-->
                                        </div>
                                    </div>
                                    <!-- /.card-header -->
                                    <div class="card-body p-0">
                                        <ul class="products-list product-list-in-card pl-2 pr-2">
                                            <%
                                                try (Connection conn = DatabaseConnection.getConnection()) {

                                                    String user_id = request.getParameter("id");
                                                    String checkSql = "SELECT * from view_passenger_details LIMIT 5";
                                                    PreparedStatement checkStmt = conn.prepareStatement(checkSql);

                                                    ResultSet checkResult = checkStmt.executeQuery();

                                                    while (checkResult.next()) {

                                            %>
                                            <li class="item">
                                                <div class="product-img">
                                                    <img src="dist/img/default-150x150.png" alt="Product Image" class="img-size-50">
                                                </div>
                                                <div class="product-info">
                                                    <a href="#" class="product-title"><%= checkResult.getString("first_name")%> <%= checkResult.getString("last_name")%>
                                                        <span class="badge badge-warning float-right"><%= checkResult.getString("mobile")%></span></a>
                                                    <span class="product-description">
                                                        <%= checkResult.getString("airline")%>
                                                    </span>
                                                </div>
                                            </li>
                                            <%                                }
                                                } catch (SQLException ex) {
                                                    out.println(ex);
                                                }
                                            %>
                                        </ul>
                                    </div>
                                    <!-- /.card-body -->
                                    <div class="card-footer text-center">
                                        <a href="${pageContext.request.contextPath}/products/products.jsp" class="uppercase">View All Products</a>
                                    </div>
                                    <!-- /.card-footer -->
                                </div>
                            </div>
                            <!-- ./col -->

                        </div>
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

            <!-- ./wrapper -->
        </div>
        <jsp:include page="IncludeFooter.jsp" />
    </body>

</html>
