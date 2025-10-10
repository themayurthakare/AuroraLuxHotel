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
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>My Bookings</title>
<link rel="stylesheet" href="css/style1.css">
</head>
<body>
	<div class="header">
		<div>My Hotel</div>
		<div class="nav">
			<a href="home.jsp">Home</a><a href="rooms.jsp">Rooms</a><a
				href="logout.jsp">Logout</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>My Bookings</h3>
			<table class="table">
				<thead>
					<tr>
						<th>Booking ID</th>
						<th>Room</th>
						<th>Check-in</th>
						<th>Check-out</th>
						<th>Amount</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<%
					try {
						String q = "SELECT b.booking_id, r.room_number, b.check_in, b.check_out, b.amount, b.status FROM bookings b JOIN rooms r ON b.room_id=r.room_id WHERE b.user_id=? ORDER BY b.created_at DESC";
						PreparedStatement pst = conn.prepareStatement(q);
						pst.setInt(1, userId);
						ResultSet rs = pst.executeQuery();
						while (rs.next()) {
					%>
					<tr>
						<td><%=rs.getInt("booking_id")%></td>
						<td><%=rs.getString("room_number")%></td>
						<td><%=rs.getString("check_in")%></td>
						<td><%=rs.getString("check_out")%></td>
						<td>₹<%=rs.getString("amount")%></td>
						<td><%=rs.getString("status")%></td>
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
