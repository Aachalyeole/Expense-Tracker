<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Expense</title>
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
    <h2 class="text-center">Edit Expense</h2>
    
    <% 
    // Retrieve the expense ID from the request
    String idStr = request.getParameter("id");
    int id = 0;
    String category = "";
    double amount = 0;
    String comments = "";

    if (idStr != null) {
      try {
        id = Integer.parseInt(idStr);

        // Database connection settings
        String jdbcURL = "jdbc:mysql://localhost:3306/expense_tracker";
        String jdbcUsername = "root";
        String jdbcPassword = "Aish@123"; // Change to your MySQL password

        // Load JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish connection
        Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        // Prepare SQL statement to fetch the expense data
        String sql = "SELECT * FROM Expenses WHERE id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, id);

        // Execute the query
        ResultSet resultSet = statement.executeQuery();
        if (resultSet.next()) {
          category = resultSet.getString("category");
          amount = resultSet.getDouble("amount");
          comments = resultSet.getString("comments");
        }

        // Close connection
        resultSet.close();
        statement.close();
        connection.close();

      } catch (Exception e) {
        e.printStackTrace();
      }
    }
    %>

    <form action="updateExpense.jsp" method="POST">
      <input type="hidden" name="id" value="<%= id %>">
      <div class="form-group">
        <label for="category">Category</label>
        <input type="text" class="form-control" id="category" name="category" value="<%= category %>" required>
      </div>
      <div class="form-group">
        <label for="amount">Amount</label>
        <input type="number" step="0.01" class="form-control" id="amount" name="amount" value="<%= amount %>" required>
      </div>
      <div class="form-group">
        <label for="comments">Comments (optional)</label>
        <textarea class="form-control" id="comments" name="comments" rows="3"><%= comments %></textarea>
      </div>
      <button type="submit" class="btn btn-primary btn-block">Update Expense</button>
    </form>

    <div class="mt-3">
      <a href="index.jsp" class="btn btn-secondary">Back to Expense List</a>
    </div>
  </div>
  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
