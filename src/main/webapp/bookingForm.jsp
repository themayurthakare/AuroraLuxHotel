<%@ page import="java.sql.*"%>
<%@ page import="java.time.*"%>
<%@ page import="java.time.temporal.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db.jsp"%>
<%
Integer userId = (Integer) session.getAttribute("userId");
if (userId == null) {
	response.sendRedirect("login.jsp");
	if (conn != null)
		try {
	conn.close();
		} catch (Exception ignored) {
		}
	;
	return;
}

String roomIdStr = request.getParameter("room_id");
String checkIn = request.getParameter("check_in");
String checkOut = request.getParameter("check_out");
String message = null;
if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("confirm") != null) {
	try {
		int roomId = Integer.parseInt(roomIdStr);
		PreparedStatement rp = conn.prepareStatement("SELECT price FROM rooms WHERE room_id=?");
		rp.setInt(1, roomId);
		ResultSet rrp = rp.executeQuery();
		double price = 0;
		if (rrp.next())
	price = rrp.getDouble("price");
		rrp.close();
		rp.close();

		LocalDate in = LocalDate.parse(checkIn);
		LocalDate cout = LocalDate.parse(checkOut);
		long nights = ChronoUnit.DAYS.between(in, cout);
		if (nights <= 0) {
	message = "Check-out must be after check-in.";
		} else {
	double amount = nights * price;
	PreparedStatement ins = conn.prepareStatement(
			"INSERT INTO bookings (user_id, room_id, check_in, check_out, status, amount) VALUES (?,?,?,?,?,?)",
			Statement.RETURN_GENERATED_KEYS);
	ins.setInt(1, userId);
	ins.setInt(2, roomId);
	ins.setDate(3, java.sql.Date.valueOf(in));
	ins.setDate(4, java.sql.Date.valueOf(cout));
	ins.setString(5, "pending");
	ins.setDouble(6, amount);
	ins.executeUpdate();
	ResultSet keys = ins.getGeneratedKeys();
	int bookingId = -1;
	if (keys.next())
		bookingId = keys.getInt(1);
	keys.close();
	ins.close();

	response.sendRedirect("payment.jsp?booking_id=" + bookingId);
	return;
		}
	} catch (Exception e) {
		message = "Could not create booking: " + e.getMessage();
	}
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Booking</title>
<link rel="stylesheet" href="css/style1.css">
</head>
<body>
	<div class="header">
		<div>AuroraLux Hotel</div>
		<div class="nav">
			<a href="rooms.jsp">Back to Rooms</a><a href="logout.jsp">Logout</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<%
			if (message != null) {
			%><div class="error"><%=message%></div>
			<%
			}
			%>
			<h3>Confirm booking</h3>
			<p class="small">
				Room ID:
				<%=roomIdStr%></p>
			<p class="small">
				Check-in:
				<%=checkIn%></p>
			<p class="small">
				Check-out:
				<%=checkOut%></p>

			<form method="post">
				<input type="hidden" name="room_id" value="<%=roomIdStr%>">
				<input type="hidden" name="check_in" value="<%=checkIn%>"> <input
					type="hidden" name="check_out" value="<%=checkOut%>">
				<button class="btn" type="submit" name="confirm">Proceed to
					Payment</button>
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
