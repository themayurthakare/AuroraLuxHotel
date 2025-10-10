<%@ page import="java.sql.*"%>
<%@ include file="db.jsp"%>
<%
String email = request.getParameter("email");
String password = request.getParameter("password");

if (email != null && password != null) {
	try {
		// check if user exists
		PreparedStatement ps = conn
		.prepareStatement("SELECT user_id, role, login_status FROM users WHERE email=? AND password=?");
		ps.setString(1, email);
		ps.setString(2, password);
		ResultSet rs = ps.executeQuery();

		if (rs.next()) {
	int userId = rs.getInt("user_id");
	String role = rs.getString("role");
	int status = rs.getInt("login_status");

	// If already logged in -> assume stale, reset to 0
	if (status == 1) {
		PreparedStatement ps2 = conn.prepareStatement("UPDATE users SET login_status=0 WHERE user_id=?");
		ps2.setInt(1, userId);
		ps2.executeUpdate();
		ps2.close();
	}

	// Now start fresh session
	session.setAttribute("userId", userId);
	session.setAttribute("role", role);

	PreparedStatement ps3 = conn.prepareStatement("UPDATE users SET login_status=1 WHERE user_id=?");
	ps3.setInt(1, userId);
	ps3.executeUpdate();
	ps3.close();

	if ("admin".equalsIgnoreCase(role)) {
		response.sendRedirect("admin/adminHome.jsp");
	} else if ("staff".equalsIgnoreCase(role)) {
		response.sendRedirect("staff/staffHome.jsp");
	} else {
		response.sendRedirect("home.jsp");
	}
		} else {
	out.println("<p style='color:red;'>Invalid email or password</p>");
		}
		rs.close();
		ps.close();
		conn.close();
	} catch (Exception e) {
		out.println("Error: " + e.getMessage());
	}
}
%>

<!-- Login Form -->
<html>
<head>
<link rel="stylesheet" href="css/style1.css">
</head>
<body>
	<div class="header">
		<strong>AuroraLux Hotel</strong>
		<div class="nav">
			<a href="index.jsp">Home</a><a href="register.jsp">Register</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<form method="post" action="login.jsp">
				<h3>Login</h3>
				<div class="form-row">
					<input class="input" type="text" name="email" placeholder="Email"
						required><br>
				</div>
				<div class="form-row">
					<input class="input" type="password" name="password"
						placeholder="Password" required><br>
				</div>
				<button class="btn" type="submit">Login</button>
			</form>
		</div>
	</div>
</body>
</html>
