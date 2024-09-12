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
        <jsp:param name="title" value="Add Flight" />
    </jsp:include>

    <body class="hold-transition sidebar-mini layout-fixed">
        <div class="wrapper">



            <jsp:include page="IncludeNav.jsp" />

            <jsp:include page="IncludeSideBar.jsp" />

            <!-- Content Wrapper. Contains page content -->
            <div class="content-wrapper">
                <jsp:include page="IncludeBreadCrumb.jsp">
                    <jsp:param name="path" value="Add Flight" />
                </jsp:include>
                <!-- /.content-header -->

                <!-- Main content -->
                <section class="content">
                    <div class="container-fluid">
                        <!-- Small boxes (Stat box) -->
                        <div class="row">
                            <!-- ./col -->
                            <div class="col-md-12">
                                <% String flight_msg = (String) request.getAttribute("flight_msg");
                                    String flight_clz = (String) request.getAttribute("flight_clz");
                                    if (flight_msg != null && flight_clz != null) {
                                %>

                                <div class="alert <%= flight_clz%> alert-dismissible fade show mt-4" role="alert">
                                    <strong><%= flight_msg%></strong> 

                                </div>
                                <%
                                    }
                                %>
                            </div>
                            <div class="col-md-12">
                                <div class="card card-primary">
                                    <div class="card-header">
                                        <h3 class="card-title">Add Flight Details</h3>
                                    </div>
                                    <!-- /.card-header -->
                                    <!-- form start -->
                                    <form action="${pageContext.request.contextPath}/AddFlightController" method="POST">
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label></label>
                                                <label>DEPARTURE</label>
                                                <div class="row">
                                                    <div class="col-6">
                                                        <label>Date</label>
                                                        <input type="date" name="dep_date" class="form-control " required="">
                                                    </div>
                                                    <div class="col-6">
                                                        <label>Time</label>
                                                        <input type="time" name="dep_time" class="form-control " required="">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label></label>
                                                <label>ARRIVAL</label>
                                                <div class="row">
                                                    <div class="col-6">
                                                        <label>Date</label>
                                                        <input type="date" name="arr_date" class="form-control " required="">
                                                    </div>
                                                    <div class="col-6">
                                                        <label>Time</label>
                                                        <input type="time" name="arr_time" class="form-control " required="">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label></label>
                                                <div class="row">
                                                    <div class="col-6">
                                                        <label>Where From</label>
                                                        <%
                                                            try (Connection conn = DatabaseConnection.getConnection()) {
                                                                String sql = "SELECT city FROM cities";
                                                                PreparedStatement checkStmt = conn.prepareStatement(sql);

                                                                ResultSet checkResult = checkStmt.executeQuery();

                                                                out.println("<select name=\"dep_city\" class=\"form-control\" required>");
                                                                
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
                                                    <div class="col-6">
                                                        <label>Where To</label>
                                                        <%
                                                            try (Connection conn = DatabaseConnection.getConnection()) {
                                                                String sql = "SELECT city FROM cities";
                                                                PreparedStatement checkStmt = conn.prepareStatement(sql);

                                                                ResultSet checkResult = checkStmt.executeQuery();

                                                                out.println("<select name=\"arr_city\" class=\"form-control\" required>");
                                                                
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
                                            </div>
                                            <div class="form-group">
                                                <label></label>
                                                <div class="row">
                                                    <div class="col-6">
                                                        <label>Duration</label>
                                                        <input type="text" class="form-control" name="duration" id="dura" required="">
                                                    </div>
                                                    <div class="col-6">
                                                        <label>Price</label>
                                                        <input type="text" class="form-control" name="price" id="price" required="">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="exampleInputPassword1">Select Airline</label>
                                                <%
                                                    try (Connection conn = DatabaseConnection.getConnection()) {
                                                        String sql = "SELECT * FROM airline";
                                                        PreparedStatement checkStmt = conn.prepareStatement(sql);

                                                        ResultSet checkResult = checkStmt.executeQuery();

                                                        out.println("<select name=\"airline_name\" class=\"form-control\" required>");
                                                        
                                                        while (checkResult.next()) {
                                                            String Name = checkResult.getString("name");
                                                            out.println("<option value=\"" + Name + "\">" + Name + "</option>");
                                                        }

                                                        out.println("</select>");

                                                    } catch (SQLException ex) {
                                                        out.println(ex);
                                                    }
                                                %> 
                                            </div>

                                        </div>
                                        <!-- /.card-body -->

                                        <div class="card-footer">
                                            <button type="submit" class="btn btn-primary">Add Flight</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <!--                            <div class="col-md-12">
                                                            <div class="card card-primary">
                                                                <div class="card-header">
                                                                    <h3 class="card-title">Add Flight Details</h3>
                                                                </div>
                                                                 /.card-header 
                                                                <div class="card-body">
                                                                    <div class="bg-light form-out col-md-12">
                                                                        <h1 class="text-secondary text-center">ADD FLIGHT DETAILS</h1>
                            
                                                                        <form method="POST" class=" text-center" action="${pageContext.request.contextPath}/AddFlightController">
                            
                                                                            <div class="form-row mb-4">
                                                                                <div class="col-md-3 p-0">
                                                                                    <h5 class="mb-0 form-name">DEPARTURE</h5>
                                                                                </div>
                                                                                <div class="col">      
                                                                                    <input type="date" name="source_date" class="form-control " required="">
                                                                                </div>
                                                                                <div class="col">         
                                                                                    <input type="time" name="source_time" class="form-control " required="">
                                                                                </div>
                                                                            </div>
                            
                            
                                                                            <div class="form-row mb-4">
                                                                                <div class="col-md-3 ">
                                                                                    <h5 class="form-name mb-0">ARRIVAL</h5>
                                                                                </div>          
                                                                                <div class="col">
                                                                                    <input type="date" name="dest_date" class="form-control " required="">
                                                                                </div>
                                                                                <div class="col">
                                                                                    <input type="time" name="dest_time" class="form-control" required="">
                                                                                </div>
                                                                            </div>
                            
                                                                            <div class="form-row mb-4">
                                                                                <div class="col">                
                            
                            <%
                                try (Connection conn = DatabaseConnection.getConnection()) {
                                    String sql = "SELECT city FROM cities";
                                    PreparedStatement checkStmt = conn.prepareStatement(sql);

                                    ResultSet checkResult = checkStmt.executeQuery();

                                    out.println("<select name=\"dep_city\" class=\"form-control custom-select form-control-border mt-4\" required>");
                                    out.println("<option value=\"null\" selected>From</option>");
                                    while (checkResult.next()) {
                                        String cityName = checkResult.getString("city");
                                        out.println("<option value=\"" + cityName + "\">" + cityName + "</option>");
                                    }

                                    out.println("</select>");

                                } catch (SQLException ex) {
                                    System.out.println(ex);
                                }
                            %>

                        </div>
                        <div class="col">
                            <%
                                try (Connection conn = DatabaseConnection.getConnection()) {
                                    String sql = "SELECT city FROM cities";
                                    PreparedStatement checkStmt = conn.prepareStatement(sql);

                                    ResultSet checkResult = checkStmt.executeQuery();

                                    out.println("<select name=\"arr_city\" class=\"form-control custom-select form-control-border mt-4\" required>");
                                    out.println("<option value=\"null\" selected>To</option>");
                                    while (checkResult.next()) {
                                        String cityName = checkResult.getString("city");
                                        out.println("<option value=\"" + cityName + "\">" + cityName + "</option>");
                                    }

                                    out.println("</select>");

                                } catch (SQLException ex) {
                                    System.out.println(ex);
                                }
                            %>              
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="col">
                            <div class="input-group ">
                                <label for="dura">Duration</label>
                                <input type="text" class="form-control form-control-border" name="duration" id="dura" required="">
                            </div>              
                        </div>            
                        <div class="col">
                            <div class="input-group">
                                <label for="price">Price</label>
                                <input type="number" class="form-control form-control-border" name="price" id="price" required="">
                            </div>            
                        </div>

                    </div>   
                    <div class="row">
                            <%
                                try (Connection conn = DatabaseConnection.getConnection()) {
                                    String sql = "SELECT * FROM airline";
                                    PreparedStatement checkStmt = conn.prepareStatement(sql);

                                    ResultSet checkResult = checkStmt.executeQuery();

                                    out.println("<select name=\"airline_name\" class=\"airline form-control custom-select form-control-border col-md-12 mt-4\" required>");
                                    out.println("<option value=\"null\" selected>Airlines</option>");
                                    while (checkResult.next()) {
                                        String Name = checkResult.getString("name");
                                        out.println("<option value=\"" + Name + "\">" + Name + "</option>");
                                    }

                                    out.println("</select>");

                                } catch (SQLException ex) {
                                    System.out.println(ex);
                                }
                            %> 

                        </div>  

                        <button name="flight_but" type="submit" class="btn btn-success mt-5">
                            <div style="font-size: 1.5rem;">
                                <i class="fa fa-lg fa-arrow-right" aria-hidden="true"></i> Proceed
                            </div>
                        </button>
                    </form>
                </div>
            </div>
             /.card-body 
        </div>
    </div>-->
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
        <script>
            $(function () {
                //Initialize Select2 Elements
                $('.select2').select2()

                //Initialize Select2 Elements
                $('.select2bs4').select2({
                    theme: 'bootstrap4'
                })

                //Datemask dd/mm/yyyy
                $('#datemask').inputmask('dd/mm/yyyy', {'placeholder': 'dd/mm/yyyy'})
                //Datemask2 mm/dd/yyyy
                $('#datemask2').inputmask('mm/dd/yyyy', {'placeholder': 'mm/dd/yyyy'})
                //Money Euro
                $('[data-mask]').inputmask()

                //Date picker
                $('#reservationdate').datetimepicker({
                    format: 'L'
                });

                //Date and time picker
                $('#reservationdatetime').datetimepicker({icons: {time: 'far fa-clock'}});

                //Date range picker
                $('#reservation').daterangepicker()
                //Date range picker with time picker
                $('#reservationtime').daterangepicker({
                    timePicker: true,
                    timePickerIncrement: 30,
                    locale: {
                        format: 'MM/DD/YYYY hh:mm A'
                    }
                })
                //Date range as a button
                $('#daterange-btn').daterangepicker(
                        {
                            ranges: {
                                'Today': [moment(), moment()],
                                'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                                'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                                'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                                'This Month': [moment().startOf('month'), moment().endOf('month')],
                                'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                            },
                            startDate: moment().subtract(29, 'days'),
                            endDate: moment()
                        },
                        function (start, end) {
                            $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'))
                        }
                )

                //Timepicker
                $('#timepicker').datetimepicker({
                    format: 'LT'
                })

                //Bootstrap Duallistbox
                $('.duallistbox').bootstrapDualListbox()

                //Colorpicker
                $('.my-colorpicker1').colorpicker()
                //color picker with addon
                $('.my-colorpicker2').colorpicker()

                $('.my-colorpicker2').on('colorpickerChange', function (event) {
                    $('.my-colorpicker2 .fa-square').css('color', event.color.toString());
                })

                $("input[data-bootstrap-switch]").each(function () {
                    $(this).bootstrapSwitch('state', $(this).prop('checked'));
                })

            })
            // BS-Stepper Init
            document.addEventListener('DOMContentLoaded', function () {
                window.stepper = new Stepper(document.querySelector('.bs-stepper'))
            })

            // DropzoneJS Demo Code Start
            Dropzone.autoDiscover = false

            // Get the template HTML and remove it from the doumenthe template HTML and remove it from the doument
            var previewNode = document.querySelector("#template")
            previewNode.id = ""
            var previewTemplate = previewNode.parentNode.innerHTML
            previewNode.parentNode.removeChild(previewNode)

            var myDropzone = new Dropzone(document.body, {// Make the whole body a dropzone
                url: "/target-url", // Set the url
                thumbnailWidth: 80,
                thumbnailHeight: 80,
                parallelUploads: 20,
                previewTemplate: previewTemplate,
                autoQueue: false, // Make sure the files aren't queued until manually added
                previewsContainer: "#previews", // Define the container to display the previews
                clickable: ".fileinput-button" // Define the element that should be used as click trigger to select files.
            })

            myDropzone.on("addedfile", function (file) {
                // Hookup the start button
                file.previewElement.querySelector(".start").onclick = function () {
                    myDropzone.enqueueFile(file)
                }
            })

            // Update the total progress bar
            myDropzone.on("totaluploadprogress", function (progress) {
                document.querySelector("#total-progress .progress-bar").style.width = progress + "%"
            })

            myDropzone.on("sending", function (file) {
                // Show the total progress bar when upload starts
                document.querySelector("#total-progress").style.opacity = "1"
                // And disable the start button
                file.previewElement.querySelector(".start").setAttribute("disabled", "disabled")
            })

            // Hide the total progress bar when nothing's uploading anymore
            myDropzone.on("queuecomplete", function (progress) {
                document.querySelector("#total-progress").style.opacity = "0"
            })

            // Setup the buttons for all transfers
            // The "add files" button doesn't need to be setup because the config
            // `clickable` has already been specified.
            document.querySelector("#actions .start").onclick = function () {
                myDropzone.enqueueFiles(myDropzone.getFilesWithStatus(Dropzone.ADDED))
            }
            document.querySelector("#actions .cancel").onclick = function () {
                myDropzone.removeAllFiles(true)
            }
            // DropzoneJS Demo Code End
        </script>
    </body>

</html>
