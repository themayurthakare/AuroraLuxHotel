<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db.jsp"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Register</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<div class="header">
		<strong>AuroraLux Hotel</strong>
		<div class="nav">
			<a href="index.jsp">Home</a><a href="login.jsp">Login</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>Create an account</h3>

			<%
			String message = null;
			if ("POST".equalsIgnoreCase(request.getMethod())) {
				String name = request.getParameter("name");
				String email = request.getParameter("email");
				String password = request.getParameter("password");
				if (name == null || email == null || password == null || name.isEmpty() || email.isEmpty() || password.isEmpty()) {
					message = "Please fill all fields.";
				} else {
					try {
				PreparedStatement check = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE email=?");
				check.setString(1, email);
				ResultSet rs = check.executeQuery();
				rs.next();
				if (rs.getInt(1) > 0) {
					message = "Email already registered.";
				} else {
					PreparedStatement ins = conn
							.prepareStatement("INSERT INTO users (name,email,password,role) VALUES (?,?,?,?)");
					ins.setString(1, name);
					ins.setString(2, email);
					ins.setString(3, password);
					ins.setString(4, "guest");
					ins.executeUpdate();
					ins.close();
					response.sendRedirect("login.jsp?msg=registered");
					return;
				}
				rs.close();
				check.close();
					} catch (Exception e) {
				message = "Error: " + e.getMessage();
					}
				}
			}
			%>

			<%
			if (message != null) {
			%>
			<div class="error"><%=message%></div>
			<%
			}
			%>

			<form method="post">
				<div class="form-row">
					<input class="input" type="text" name="name"
						placeholder="Full name">
				</div>
				<div class="form-row">
					<input class="input" type="email" name="email" placeholder="Email">
				</div>
				<div class="form-row">
					<input class="input" type="password" name="password"
						placeholder="Password">
				</div>
				<button class="btn" type="submit">Register</button>
			</form>
		</div>
	</div>
</body>
</html>
<%
if (conn != null)
	try {
		conn.close();
	} catch (Exception ignored) {
	}
%>
