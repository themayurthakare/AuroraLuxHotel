<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../db.jsp"%>
<%
Integer userId = (Integer) session.getAttribute("userId");
String role = (String) session.getAttribute("role");
if (userId == null || role == null || !"admin".equals(role)) {
	response.sendRedirect("../login.jsp");
	if (conn != null)
		try {
	conn.close();
		} catch (Exception ignored) {
		}
	;
	return;
}

String msg = null;
// Add staff
if ("POST".equalsIgnoreCase(request.getMethod())) {
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	if (name != null && email != null && password != null && !name.isEmpty() && !email.isEmpty()
	&& !password.isEmpty()) {
		try {
	PreparedStatement ins = conn
			.prepareStatement("INSERT INTO users (name,email,password,role) VALUES (?,?,?, 'staff')");
	ins.setString(1, name);
	ins.setString(2, email);
	ins.setString(3, password);
	ins.executeUpdate();
	ins.close();
	msg = "Staff account created.";
		} catch (Exception e) {
	msg = "Error: " + e.getMessage();
		}
	} else
		msg = "Please fill all fields.";
}

// Actions (delete or reset login)
String action = request.getParameter("action");
String uid = request.getParameter("user_id");
if (action != null && uid != null) {
	try {
		int u = Integer.parseInt(uid);
		if ("delete".equals(action)) {
	PreparedStatement del = conn.prepareStatement("DELETE FROM users WHERE user_id=? AND role='staff'");
	del.setInt(1, u);
	del.executeUpdate();
	del.close();
		} else if ("reset".equals(action)) {
	PreparedStatement up = conn
			.prepareStatement("UPDATE users SET login_status=0 WHERE user_id=? AND role='staff'");
	up.setInt(1, u);
	up.executeUpdate();
	up.close();
		}
		response.sendRedirect("manageStaff.jsp");
		if (conn != null)
	try {
		conn.close();
	} catch (Exception ignored) {
	}
		;
		return;
	} catch (Exception e) {
		msg = "Action error: " + e.getMessage();
	}
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Manage Staff</title>
<link rel="stylesheet" href="../css/style1.css">
</head>
<body>
	<div class="header">
		<div>My Hotel (Admin)</div>
		<div class="nav">
			<a href="adminHome.jsp">Home</a> <a href="manageRooms.jsp">Manage
				Rooms</a> <a href="allBookings.jsp">All Bookings</a> <a
				href="../logout.jsp">Logout</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>Create Staff Account</h3>
			<%
			if (msg != null) {
			%><div class="success"><%=msg%></div>
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
				<button class="btn" type="submit">Create Staff</button>
			</form>
		</div>

		<div class="card">
			<h3>Existing Staff</h3>
			<table class="table">
				<thead>
					<tr>
						<th>ID</th>
						<th>Name</th>
						<th>Email</th>
						<th>Logged In</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<%
					try {
						PreparedStatement pst = conn.prepareStatement(
						"SELECT user_id, name, email, login_status FROM users WHERE role='staff' ORDER BY user_id ASC");
						ResultSet rs = pst.executeQuery();
						while (rs.next()) {
					%>
					<tr>
						<td><%=rs.getInt("user_id")%></td>
						<td><%=rs.getString("name")%></td>
						<td><%=rs.getString("email")%></td>
						<td><%=(rs.getInt("login_status") == 1 ? "Yes" : "No")%></td>
						<td><a class="btn"
							href="manageStaff.jsp?action=reset&user_id=<%=rs.getInt("user_id")%>">Reset
								Login</a> <a class="btn" style="background: #c0392b;"
							href="manageStaff.jsp?action=delete&user_id=<%=rs.getInt("user_id")%>">Delete</a>
						</td>
					</tr>
					<%
					}
					rs.close();
					pst.close();
					} catch (Exception e) {
					out.println("<div class='error'>" + e.getMessage() + "</div>");
					}
					%>
				</tbody>
			</table>
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
s