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
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Admin Dashboard</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div class="header">
		<div>My Hotel (Admin)</div>
		<div class="nav">
			<a href="adminHome.jsp">Home</a> <a href="manageStaff.jsp">Manage
				Staff</a> <a href="manageRooms.jsp">Manage Rooms</a> <a
				href="allBookings.jsp">All Bookings</a> <a href="../logout.jsp">Logout</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>Admin Panel</h3>
			<p class="small">Use links above to manage staff, rooms and
				bookings.</p>
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
