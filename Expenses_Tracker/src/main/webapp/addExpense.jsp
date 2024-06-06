<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Expense</title>
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
    <h2 class="text-center">Add New Expense</h2>
    
    <% 
    // Handle form submission
    String category = request.getParameter("category");
    String amountStr = request.getParameter("amount");
    String comments = request.getParameter("comments");
    boolean isSuccess = false;
    String errorMessage = "";

    if (category != null && amountStr != null) {
      try {
        double amount = Double.parseDouble(amountStr);

        // Database connection settings
        String jdbcURL = "jdbc:mysql://localhost:3306/expense_tracker";
        String jdbcUsername = "root";
        String jdbcPassword = "Aish@123"; // Change to your MySQL password

        // Load JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish connection
        Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        // Prepare SQL statement
        String sql = "INSERT INTO Expenses (category, amount, comments) VALUES (?, ?, ?)";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, category);
        statement.setDouble(2, amount);
        statement.setString(3, comments);

        // Execute the statement
        int rowsInserted = statement.executeUpdate();
        if (rowsInserted > 0) {
          isSuccess = true;
        }

        // Close connection
        statement.close();
        connection.close();

      } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "There was an error saving the expense.";
      }
    }
    %>
    
    <% if (isSuccess) { %>
      <div class="alert alert-success" role="alert">
        Expense added successfully!
      </div>
    <% } else if (errorMessage != "") { %>
      <div class="alert alert-danger" role="alert">
        <%= errorMessage %>
      </div>
    <% } %>

    <form action="addExpense.jsp" method="POST">
      <div class="form-group">
        <label for="category">Category</label>
        <input type="text" class="form-control" id="category" name="category" required>
      </div>
      <div class="form-group">
        <label for="amount">Amount</label>
        <input type="number" step="0.01" class="form-control" id="amount" name="amount" required>
      </div>
      <div class="form-group">
        <label for="comments">Comments (optional)</label>
        <textarea class="form-control" id="comments" name="comments" rows="3"></textarea>
      </div>
      <button type="submit" class="btn btn-primary btn-block">Add Expense</button>
    </form>

    <div class="mt-3">
      <a href="viewExpenses.jsp" class="btn btn-secondary">Back to Expense List</a>
    </div>
  </div>
  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
