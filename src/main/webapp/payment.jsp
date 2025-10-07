<%@ page import="java.sql.*"%>
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

String bookingIdStr = request.getParameter("booking_id");
if (bookingIdStr == null) {
	out.println("<div class='error'>Missing booking id.</div>");
	if (conn != null)
		try {
	conn.close();
		} catch (Exception ignored) {
		}
	;
	return;
}
int bookingId = Integer.parseInt(bookingIdStr);

if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("pay") != null) {
	try {
		PreparedStatement up = conn
		.prepareStatement("UPDATE bookings SET status='confirmed' WHERE booking_id=? AND user_id=?");
		up.setInt(1, bookingId);
		up.setInt(2, userId);
		up.executeUpdate();
		up.close();
		response.sendRedirect("myBookings.jsp");
		if (conn != null)
	try {
		conn.close();
	} catch (Exception ignored) {
	}
		;
		return;
	} catch (Exception e) {
		out.println("<div class='error'>Payment error: " + e.getMessage() + "</div>");
	}
}

String detailsQ = "SELECT b.*, r.room_number, r.room_type FROM bookings b JOIN rooms r ON b.room_id=r.room_id WHERE b.booking_id=? AND b.user_id=?";
PreparedStatement pst = conn.prepareStatement(detailsQ);
pst.setInt(1, bookingId);
pst.setInt(2, userId);
ResultSet rs = pst.executeQuery();
if (!rs.next()) {
	out.println("<div class='error'>Booking not found.</div>");
	rs.close();
	pst.close();
	if (conn != null)
		try {
	conn.close();
		} catch (Exception ignored) {
		}
	;
	return;
}
double amount = rs.getDouble("amount");
String roomNum = rs.getString("room_number");
String roomType = rs.getString("room_type");
String checkIn = rs.getString("check_in");
String checkOut = rs.getString("check_out");
rs.close();
pst.close();
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Payment</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<div class="header">
		<div>My Hotel</div>
		<div class="nav">
			<a href="myBookings.jsp">My Bookings</a><a href="logout.jsp">Logout</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>Payment</h3>
			<p>
				Room <strong><%=roomNum%></strong> (<%=roomType%>)
			</p>
			<p class="small">
				From:
				<%=checkIn%>
				To:
				<%=checkOut%></p>
			<p class="small">
				Amount to pay: <strong>₹<%=amount%></strong>
			</p>
			<p class="small">(This is a dummy payment — clicking pay will
				mark booking as paid/confirmed.)</p>
			<form method="post">
				<button class="btn" type="submit" name="pay">Pay & Confirm
					Booking</button>
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
