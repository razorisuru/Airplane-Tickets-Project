<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="Models.DatabaseConnection"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Main Sidebar Container -->
<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="${pageContext.request.contextPath}/admin/index.jsp" class="brand-link">
        <img src="${pageContext.request.contextPath}/admin/dist/img/AdminLTELogo.png" alt="AdminLTE Logo" class="brand-image img-circle elevation-3"
             style="opacity: .8">
        <span class="brand-text"><b>ABC</b> Flight</span>
    </a>

    <!-- Sidebar -->
    <%
        String dp_name = (String) session.getAttribute("DP_NAME");
        String dp = (String) session.getAttribute("DP");
    %>
    <div class="sidebar">
        <!-- Sidebar user panel (optional) -->
        <div class="user-panel mt-3 pb-3 mb-3 d-flex">
            <div class="image">
                <img src="${pageContext.request.contextPath}/admin/dist/img/dp/<%= dp%>" class="img-circle elevation-2" alt="User Image">
            </div>

            <div class="info">
                <a href="${pageContext.request.contextPath}/admin/ProfileUpdate.jsp" class="d-block"><%= dp_name%></a>
            </div>
        </div>

        <!-- SidebarSearch Form -->
        <div class="form-inline">
            <div class="input-group" data-widget="sidebar-search">
                <input class="form-control form-control-sidebar" type="search" placeholder="Search" aria-label="Search">
                <div class="input-group-append">
                    <button class="btn btn-sidebar">
                        <i class="fas fa-search fa-fw"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Sidebar Menu -->
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
                <!-- Add icons to the links using the .nav-icon class
                   with font-awesome or any other icon font library -->
                <li class="nav-item menu-open">
                    <a href="#" class="nav-link active">
                        <i class="nav-icon fas fa-tachometer-alt"></i>
                        <p>
                            Users
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/users.jsp" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Users</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/admin.jsp" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Admin</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/AddUser.jsp" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Add User</p>
                            </a>
                        </li>
                    </ul>
                </li>
                <li class="nav-item menu-open">
                    <a href="#" class="nav-link active">
                        <i class="nav-icon fas fa-tachometer-alt"></i>
                        <p>
                            Flights
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <%
                        int flightCount = 0;
                        try (Connection conn = DatabaseConnection.getConnection()) {
                            String checkSql = "SELECT COUNT(*) AS total_flights FROM flight";
                            PreparedStatement checkStmt = conn.prepareStatement(checkSql);

                            ResultSet checkResult = checkStmt.executeQuery();

                            if (checkResult.next()) {
                                flightCount = checkResult.getInt("total_flights");
                            }
                        } catch (SQLException ex) {
                            System.out.println(ex);
                        }
                    %>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/flights.jsp" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Flights</p>
                                <span class="right badge badge-danger"><%= flightCount%></span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/AddFlight.jsp" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Add Flight</p>
                            </a>
                        </li>

                    </ul>
                </li>

                <li class="nav-item menu-open">
                    <a href="#" class="nav-link active">
                        <i class="nav-icon fas fa-tachometer-alt"></i>
                        <p>
                            Airlines
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <%
                        int airlineCount = 0;
                        try (Connection conn = DatabaseConnection.getConnection()) {
                            String checkSql = "SELECT COUNT(*) AS total_flights FROM airline";
                            PreparedStatement checkStmt = conn.prepareStatement(checkSql);

                            ResultSet checkResult = checkStmt.executeQuery();

                            if (checkResult.next()) {
                                airlineCount = checkResult.getInt("total_flights");
                            }
                        } catch (SQLException ex) {
                            System.out.println(ex);
                        }
                    %>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/airlines.jsp" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Airlines</p>
                                <span class="right badge badge-danger"><%= airlineCount%></span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/AddAirline.jsp" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Add Airline</p>
                            </a>
                        </li>

                    </ul>
                </li>
                
                <li class="nav-item menu-open">
                    <a href="#" class="nav-link active">
                        <i class="nav-icon fas fa-tachometer-alt"></i>
                        <p>
                            Audits
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/admin/FlightAudit.jsp" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Flight Audit</p>
                                <span class="right badge badge-danger"></span>
                            </a>
                        </li>
                        

                    </ul>
                </li>



            </ul>
        </nav>
        <!-- /.sidebar-menu -->
    </div>
    <!-- /.sidebar -->
</aside>