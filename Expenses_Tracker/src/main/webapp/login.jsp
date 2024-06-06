<%@ page import="java.sql.*, java.util.*,  java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
</head>
<body>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    // Database connection parameters (Consider moving this to a separate configuration file)
    String dbUrl = "jdbc:mysql://localhost:3306/expense_tracker";
    String dbUser = "root";
    String dbPassword = "Aish@123";

    // Check login attempts and lockout time
    int loginAttempts = (session.getAttribute("loginAttempts") != null) ? (int) session.getAttribute("loginAttempts") : 0;
    long lockoutTime = (session.getAttribute("lockoutTime") != null) ? (long) session.getAttribute("lockoutTime") : 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        if (System.currentTimeMillis() > lockoutTime || lockoutTime == 0) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Successful login
                String username = rs.getString("email");
                session.setAttribute("isLoggedIn", true); // Set isLoggedIn attribute upon successful login
                session.setAttribute("username",username); // Set username attribute upon successful login
                response.sendRedirect("viewExpenses.jsp");
            } else {
                // Failed login attempt
                loginAttempts++;
                session.setAttribute("loginAttempts", loginAttempts);

                if (loginAttempts >= 4) {
                    // Lock the user account for 5 minutes
                    long fiveMinutesInMillis = 5 * 60 * 1000;
                    long newLockoutTime = System.currentTimeMillis() + fiveMinutesInMillis;
                    session.setAttribute("lockoutTime", newLockoutTime);
                    out.println("<script>alert('Too many unsuccessful login attempts. Your account is temporarily locked for 5 minutes.'); window.location.href='login.html';</script>");
                } else {
                    // Display an error message and allow the user to try again
                    out.println("<script>alert('Invalid credentials. Attempt #" + loginAttempts + "'); window.location.href='login1.html';</script>");
                }
            }

            rs.close();
            ps.close();
        } else {
            // Account locked due to too many unsuccessful login attempts
            out.println("<script>alert('Too many unsuccessful login attempts. Your account is temporarily locked. Please try again after 5 minutes.'); window.location.href='login.html';</script>");
        }

        con.close();
    } catch (Exception e) {
        // Handle exceptions gracefully (e.g., log error details for debugging)
        e.printStackTrace();
        out.println("<script>alert('An error occurred: " + e.getMessage() + "'); window.location.href='login.html';</script>");
    }
%>
</body>
</html>
