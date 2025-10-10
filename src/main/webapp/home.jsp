<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db.jsp"%>
<%
Integer userId = (Integer) session.getAttribute("userId");
String role = (String) session.getAttribute("role");

if (userId == null || role == null || !"guest".equals(role)) {
	response.sendRedirect("login.jsp");
	if (conn != null)
		try {
	conn.close();
		} catch (Exception ignored) {
		}
	return;
}

String userName = "Guest"; // fallback
try {
	PreparedStatement ps = conn.prepareStatement("SELECT name FROM users WHERE user_id=?");
	ps.setInt(1, userId);
	ResultSet rs = ps.executeQuery();
	if (rs.next()) {
		userName = rs.getString("name");
	}
	rs.close();
	ps.close();
} catch (Exception e) {
	e.printStackTrace();
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Guest Dashboard</title>
<link rel="stylesheet" href="css/style1.css">
</head>
<body>
	<div class="header">
		<div>My Hotel</div>
		<div class="nav">
			<a href="rooms.jsp">Rooms</a> <a href="myBookings.jsp">My
				Bookings</a> <a href="logout.jsp">Logout</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>
				Welcome,
				<%=userName%></h3>
			<p class="small">Use the links above to browse rooms and manage
				your bookings.</p>
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
