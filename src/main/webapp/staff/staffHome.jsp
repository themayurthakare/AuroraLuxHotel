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
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Staff Dashboard</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div class="header">
		<div>My Hotel (Staff)</div>
		<div class="nav">
			<a href="staffHome.jsp">Home</a> <a href="manageBookings.jsp">Manage
				Bookings</a> <a href="addRoom.jsp">Add Room</a> <a
				href="availableRooms.jsp">Vacant Rooms</a> <a href="../logout.jsp">Logout</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>Pending Bookings</h3>
			<table class="table">
				<thead>
					<tr>
						<th>ID</th>
						<th>Guest</th>
						<th>Room</th>
						<th>Check-in</th>
						<th>Check-out</th>
						<th>Amount</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<%
					try {
						String q = "SELECT b.booking_id, u.name as guest_name, r.room_number, b.check_in, b.check_out, b.amount FROM bookings b JOIN users u ON b.user_id=u.user_id JOIN rooms r ON b.room_id=r.room_id WHERE b.status='pending' ORDER BY b.created_at ASC";
						PreparedStatement pst = conn.prepareStatement(q);
						ResultSet rs = pst.executeQuery();
						while (rs.next()) {
					%>
					<tr>
						<td><%=rs.getInt("booking_id")%></td>
						<td><%=rs.getString("guest_name")%></td>
						<td><%=rs.getString("room_number")%></td>
						<td><%=rs.getString("check_in")%></td>
						<td><%=rs.getString("check_out")%></td>
						<td>₹<%=rs.getString("amount")%></td>
						<td><a class="btn"
							href="manageBookings.jsp?action=confirm&booking_id=<%=rs.getInt("booking_id")%>">Confirm</a>
							<a class="btn" style="background: #c0392b;"
							href="manageBookings.jsp?action=cancel&booking_id=<%=rs.getInt("booking_id")%>">Cancel</a>
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
