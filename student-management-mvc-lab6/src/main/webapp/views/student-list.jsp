<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>

    <!-- Full Integrated Styles -->
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .navbar {
            background: white;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .navbar h2 { color: #333; }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info span { font-weight: 600; }

        .role-badge {
            padding: 4px 10px;
            border-radius: 5px;
            color: white;
            font-size: 12px;
            margin-left: 5px;
            text-transform: uppercase;
        }

        .role-admin { background-color: #e63946; }
        .role-user { background-color: #457b9d; }

        .btn-nav, .btn-logout {
            padding: 10px 18px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            color: white;
            background-color: #764ba2;
        }

        .btn-logout { background-color: #e63946; }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        h1 { color: #333; margin-bottom: 10px; font-size: 32px; }

        .message { padding: 15px; margin-bottom: 20px; border-radius: 5px; font-weight: 500; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }

        .btn-primary {
            padding: 12px 20px; background: #667eea; color: white; border-radius: 6px;
            text-decoration: none; font-weight: 500; border: none; cursor: pointer;
        }

        .btn-secondary { background-color: #6c757d; color: white; padding: 10px 16px; border-radius: 6px; }
        .btn-danger { background-color: #dc3545; padding: 8px 16px; color: white; border-radius: 6px; }

        table {
            width: 100%; margin-top: 20px; border-collapse: collapse;
        }

        thead {
            background: #667eea; color: white;
        }

        th, td {
            padding: 15px; border-bottom: 1px solid #ddd;
        }

        tbody tr:hover { background-color: #f8f9fa; }

        .actions { display: flex; gap: 10px; }

        .empty-state { text-align:center; padding:60px 20px; color:#999; }
        .empty-state-icon { font-size:64px; margin-bottom:20px; }
    </style>
</head>

<body>

    <!-- Navigation Bar -->
    <div class="navbar">
        <h2>📚 Student Management System</h2>
        <div class="navbar-right">
            <div class="user-info">
                <span>Welcome, ${sessionScope.fullName}</span>
                <span class="role-badge role-${sessionScope.role}">
                    ${sessionScope.role}
                </span>
            </div>

            <a href="dashboard" class="btn-nav">Dashboard</a>
            <a href="logout" class="btn-logout">Logout</a>
        </div>
    </div>

    <div class="container">

        <h1>📚 Student List</h1>

        <!-- Success Message -->
        <c:if test="${not empty param.message}">
            <div class="message success">✅ ${param.message}</div>
        </c:if>

        <!-- Error Message -->
        <c:if test="${not empty param.error}">
            <div class="message error">❌ ${param.error}</div>
        </c:if>

        <!-- Add Button: Admin Only -->
        <c:if test="${sessionScope.role eq 'admin'}">
            <a href="student?action=new" class="btn-primary">➕ Add New Student</a>
        </c:if>

        <!-- Search + Filtering -->
        <div style="margin-top:20px; display:flex; gap:20px;">

            <!-- Filter by Major -->
            <form action="student" method="get" style="display:flex; gap:10px;">
                <input type="hidden" name="action" value="filter">

                <select name="major" style="padding:10px; border-radius:6px;">
                    <option value="">All Majors</option>

                    <option value="Computer Science"
                        <c:if test="${selectedMajor eq 'Computer Science'}">selected</c:if>>Computer Science</option>

                    <option value="Information Technology"
                        <c:if test="${selectedMajor eq 'Information Technology'}">selected</c:if>>Information Technology</option>

                    <option value="Software Engineering"
                        <c:if test="${selectedMajor eq 'Software Engineering'}">selected</c:if>>Software Engineering</option>

                    <option value="Business Administration"
                        <c:if test="${selectedMajor eq 'Business Administration'}">selected</c:if>>Business Administration</option>
                </select>

                <button class="btn-primary">Apply</button>

                <c:if test="${not empty selectedMajor}">
                    <a href="student?action=list" class="btn-secondary">Clear</a>
                </c:if>
            </form>

            <!-- Search Bar -->
            <form action="student" method="get" style="display:flex; flex:1; gap:10px;">
                <input type="hidden" name="action" value="search">

                <input type="text" name="keyword" placeholder="Search..." 
                    value="${keyword}"
                    style="flex:1; padding:12px; border-radius:8px; border:1px solid #ddd;">

                <button class="btn-primary">🔍</button>

                <c:if test="${not empty keyword}">
                    <a href="student?action=list" class="btn-secondary">✖</a>
                </c:if>
            </form>
        </div>

        <!-- Search Message -->
        <c:if test="${not empty keyword}">
            <div class ="message" style="background:#eef; margin-top:10px;">
                🔎 <strong>Search results for:</strong> "${keyword}"
            </div>
        </c:if>

        <!-- Student Table -->
        <c:choose>
        <c:when test="${not empty students}">
            <table>
                <thead>
                    <tr>
                        <th><a href="student?action=sort&sortBy=id&order=${order == 'asc' ? 'desc' : 'asc'}">ID</a></th>
                        <th><a href="student?action=sort&sortBy=student_code&order=${order == 'asc' ? 'desc' : 'asc'}">Code</a></th>
                        <th><a href="student?action=sort&sortBy=full_name&order=${order == 'asc' ? 'desc' : 'asc'}">Name</a></th>
                        <th><a href="student?action=sort&sortBy=email&order=${order == 'asc' ? 'desc' : 'asc'}">Email</a></th>
                        <th><a href="student?action=sort&sortBy=major&order=${order == 'asc' ? 'desc' : 'asc'}">Major</a></th>

                        <c:if test="${sessionScope.role eq 'admin'}">
                            <th>Actions</th>
                        </c:if>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach items="${students}" var="student">
                        <tr>
                            <td>${student.id}</td>
                            <td>${student.studentCode}</td>
                            <td>${student.fullName}</td>
                            <td>${student.email}</td>
                            <td>${student.major}</td>

                            <c:if test="${sessionScope.role eq 'admin'}">
                                <td>
                                    <div class="actions">
                                        <a href="student?action=edit&id=${student.id}" class="btn-secondary">✏️ Edit</a>
                                        <a href="student?action=delete&id=${student.id}" class="btn-danger"
                                           onclick="return confirm('Delete this student?')">🗑 Delete</a>
                                    </div>
                                </td>
                            </c:if>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>

        <c:otherwise>
            <div class="empty-state">
                <div class="empty-state-icon">📭</div>
                <h3>No students found</h3>
                <p>Start by adding a new student</p>
            </div>
        </c:otherwise>
        </c:choose>

    </div>
</body>
</html>
