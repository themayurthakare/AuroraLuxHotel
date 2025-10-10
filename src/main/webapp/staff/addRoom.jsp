<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../db.jsp"%>
<%
Integer userId = (Integer) session.getAttribute("userId");
String role = (String) session.getAttribute("role");
if (userId == null || role == null || !"staff".equals(role)) {
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
if ("POST".equalsIgnoreCase(request.getMethod())) {
	String room_number = request.getParameter("room_number");
	String room_type = request.getParameter("room_type");
	String price = request.getParameter("price");
	try {
		PreparedStatement ins = conn.prepareStatement(
		"INSERT INTO rooms (room_number, room_type, price, status) VALUES (?,?,?, 'available')");
		ins.setString(1, room_number);
		ins.setString(2, room_type);
		ins.setDouble(3, Double.parseDouble(price));
		ins.executeUpdate();
		ins.close();
		msg = "Room added.";
	} catch (Exception e) {
		msg = "Error: " + e.getMessage();
	}
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Add Room</title>
<link rel="stylesheet" href="../css/style1.css">
</head>
<body>
	<div class="header">
		<div>My Hotel (Staff)</div>
		<div class="nav">
			<a href="staffHome.jsp">Home</a> <a href="manageBookings.jsp">Manage
				Bookings</a> <a href="availableRooms.jsp">Vacant Rooms</a> <a
				href="../logout.jsp">Logout</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>Add Room</h3>
			<%
			if (msg != null) {
			%><div class="success"><%=msg%></div>
			<%
			}
			%>
			<form method="post">
				<div class="form-row">
					<input class="input" type="text" name="room_number"
						placeholder="Room number (e.g. 401)">
				</div>
				<div class="form-row">
					<input class="input" type="text" name="room_type"
						placeholder="Room type (Single/Double/Deluxe)">
				</div>
				<div class="form-row">
					<input class="input" type="number" name="price"
						placeholder="Price per night">
				</div>
				<button class="btn" type="submit">Add Room</button>
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
