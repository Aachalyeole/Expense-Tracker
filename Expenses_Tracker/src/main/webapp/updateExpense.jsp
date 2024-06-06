<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Update Expense</title>
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
    <h2 class="text-center">Update Expense</h2>
    
    <% 
    // Handle form submission
    String idStr = request.getParameter("id");
    String category = request.getParameter("category");
    String amountStr = request.getParameter("amount");
    String comments = request.getParameter("comments");
    boolean isSuccess = false;
    String errorMessage = "";

    if (idStr != null && category != null && amountStr != null) {
      try {
        int id = Integer.parseInt(idStr);
        double amount = Double.parseDouble(amountStr);

        // Database connection settings
        String jdbcURL = "jdbc:mysql://localhost:3306/expense_tracker";
        String jdbcUsername = "root";
        String jdbcPassword = "Aish@123"; // Change to your MySQL password

        // Load JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish connection
        Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        // Prepare SQL statement to update the expense data
        String sql = "UPDATE Expenses SET category = ?, amount = ?, comments = ?, updated_at = NOW() WHERE id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, category);
        statement.setDouble(2, amount);
        statement.setString(3, comments);
        statement.setInt(4, id);

        // Execute the statement
        int rowsUpdated = statement.executeUpdate();
        if (rowsUpdated > 0) {
          isSuccess = true;
        }

        // Close connection
        statement.close();
        connection.close();

      } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "There was an error updating the expense.";
      }
    }
    %>
    
    <% if (isSuccess) { %>
      <div class="alert alert-success" role="alert">
        Expense updated successfully!
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
