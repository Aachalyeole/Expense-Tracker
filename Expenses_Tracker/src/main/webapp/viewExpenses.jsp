<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>View Expenses</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
    }
    .container {
      margin-top: 50px;
    }
    table {
      margin-top: 20px;
    }
    .action-buttons {
      display: flex;
      gap: 10px;
    }
    .action-buttons a {
      text-decoration: none;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2 class="text-center">Expense Tracker</h2>
    <div class="d-flex justify-content-between mb-3">
    </div>
    <table class="table table-bordered">
      <thead class="thead-dark">
        <tr>
          <th>Category</th>
          <th>Amount</th>
          <th>Comments</th>
          <th>Created At</th>
          <th>Updated At</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <% 
          // Database connection settings
          String jdbcURL = "jdbc:mysql://localhost:3306/expense_tracker";
          String jdbcUsername = "root";
          String jdbcPassword = "Aish@123"; // Change to your MySQL password

          try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection
            Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            // Prepare SQL statement
            String sql = "SELECT * FROM Expenses ORDER BY created_at DESC";
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery(sql);

            // Iterate over the result set and display data in table rows
            while (resultSet.next()) {
              int id = resultSet.getInt("id");
              String category = resultSet.getString("category");
              double amount = resultSet.getDouble("amount");
              String comments = resultSet.getString("comments");
              Timestamp createdAt = resultSet.getTimestamp("created_at");
              Timestamp updatedAt = resultSet.getTimestamp("updated_at");
        %>
        <tr>
          <td><%= category %></td>
          <td><%= amount %></td>
          <td><%= comments %></td>
          <td><%= createdAt %></td>
          <td><%= updatedAt %></td>
          <td>
            <div class="action-buttons">
              <a href="editExpense.jsp?id=<%= id %>" class="btn btn-warning btn-sm">Edit</a>
              <a href="deleteExpense.jsp?id=<%= id %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this expense?');">Delete</a>
            </div>
          </td>
        </tr>
        <% 
            }

            // Close connection
            resultSet.close();
            statement.close();
            connection.close();

          } catch (Exception e) {
            e.printStackTrace();
          }
        %>
      </tbody>
    </table>

    <div class="d-flex justify-content-end mt-3">
      <a href="addExpense.jsp" class="btn btn-primary">Add Expense</a>
    </div>
  </div>
  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
