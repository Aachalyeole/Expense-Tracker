<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Form</title>
    <script>
        function redirectToLogin() {
            alert("Registration successful!");
            window.location.href = "login.html"; // Redirect to login.html
        }
    </script>
</head>
<body>
    <h2>Registration Form</h2>
    <%
        // Retrieve form parameters
        String name = request.getParameter("name");
        String phoneNo = request.getParameter("phoneno");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate if all fields are provided
        if (name != null && phoneNo != null && email != null && password != null) {
            // Database connection parameters
            String dbUrl = "jdbc:mysql://localhost:3306/expense_tracker";
            String dbUser = "root";
            String dbPassword = "Aish@123";

            try {
                // Load MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Create connection to the database
                Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

                // SQL query to insert user data
                String sql = "INSERT INTO users (name, phoneno, email, password) VALUES (?, ?, ?, ?)";
                
                // Prepare statement
                PreparedStatement statement = conn.prepareStatement(sql);
                statement.setString(1, name);
                statement.setString(2, phoneNo);
                statement.setString(3, email);
                statement.setString(4, password);

                // Execute the statement
                int rowsInserted = statement.executeUpdate();
                if (rowsInserted > 0) {
                    // Redirect to login.html after displaying alert
                    out.println("<script>redirectToLogin();</script>");
                }

                // Close resources
                statement.close();
                conn.close();
            } catch (ClassNotFoundException | SQLException e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
                StackTraceElement[] stackTraceElements = e.getStackTrace();
                for (StackTraceElement stackTraceElement : stackTraceElements) {
                    out.println("<p>" + stackTraceElement.toString() + "</p>");
                }
            }
        }
    %>
</body>
</html>
