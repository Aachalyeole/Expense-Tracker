<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Delete Expense</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
    }
    .container {
      margin-top: 50px;
    }
    .alert {
      margin-top: 20px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2 class="text-center">Delete Expense</h2>
    
    <% 
    // Handle expense deletion
    String idStr = request.getParameter("id");
    boolean isSuccess = false;
    String errorMessage = "";

    if (idStr != null) {
      try {
        int id = Integer.parseInt(idStr);

        // Database connection settings
        String jdbcURL = "jdbc:mysql://localhost:3306/expense_tracker";
        String jdbcUsername = "root";
        String jdbcPassword = "Aish@123"; // Change to your MySQL password

        // Load JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish connection
        Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        // Prepare SQL statement to delete the expense
        String sql = "DELETE FROM Expenses WHERE id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, id);

        // Execute the statement
        int rowsDeleted = statement.executeUpdate();
        if (rowsDeleted > 0) {
          isSuccess = true;
        }

        // Close connection
        statement.close();
        connection.close();

      } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "There was an error deleting the expense.";
      }
    }
    %>
    
    <% if (isSuccess) { %>
      <div class="alert alert-success" role="alert">
        Expense deleted successfully!
      </div>
    <% } else if (errorMessage != "") { %>
      <div class="alert alert-danger" role="alert">
        <%= errorMessage %>
      </div>
    <% } %>

    <div class="mt-3">
      <a href="viewExpenses.jsp" class="btn btn-secondary">Back to Expense List</a>
    </div>
  </div>
  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
