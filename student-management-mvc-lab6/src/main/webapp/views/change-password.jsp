<%-- 
    Document   : change-password
    Created on : Nov 26, 2025, 9:42:36 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        
        <!-- Bootstrap theme -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        
        <!--  -->
        <style>
            .password-box {
                max-width: 400px;
                margin: 40px auto;
            }
        </style>

    </head>
    <body>
        <div class = "password-box">
            
            <h3 class="text-center mb-4">Change Password</h3>
            
            <!-- Display change status -->
            <%
                String error = (String) request.getAttribute("error");
                String message = (String) request.getAttribute("message");
                if (error != null){ // If error raises 
            %>  
            
            <div class="alert alert-danger"><%= error %></div>
            
            <% } else if (message != null) { %>
            
            <div class="alert alert-success"><%= message %></div>
            
            <% } %>
            
            <form action="change-password" method="post">
                <input type="password" name="currentPassword" placeholder="Current Password">
                <input type="password" name="newPassword" placeholder="New Password">
                <input type="password" name="confirmPassword" placeholder="Confirm Password">
                <button type="submit">Change Password</button>
            </form>
        </div>
    </body>
</html>
