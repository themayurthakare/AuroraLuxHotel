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

String action = request.getParameter("action");
String bid = request.getParameter("booking_id");
if (action != null && bid != null) {
	try {
		if ("confirm".equals(action)) {
	PreparedStatement up = conn.prepareStatement("UPDATE bookings SET status='confirmed' WHERE booking_id=?");
	up.setInt(1, Integer.parseInt(bid));
	up.executeUpdate();
	up.close();
		} else if ("cancel".equals(action)) {
	PreparedStatement up = conn.prepareStatement("UPDATE bookings SET status='cancelled' WHERE booking_id=?");
	up.setInt(1, Integer.parseInt(bid));
	up.executeUpdate();
	up.close();
		} else if ("pend".equals(action)) {
	PreparedStatement up = conn.prepareStatement("UPDATE bookings SET status='pending' WHERE booking_id=?");
	up.setInt(1, Integer.parseInt(bid));
	up.executeUpdate();
	up.close();
		}
		response.sendRedirect("allBookings.jsp");
		if (conn != null)
	try {
		conn.close();
	} catch (Exception ignored) {
	}
		;
		return;
	} catch (Exception e) {
		out.println("<div class='error'>" + e.getMessage() + "</div>");
	}
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>All Bookings</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div class="header">
		<div>My Hotel (Admin)</div>
		<div class="nav">
			<a href="adminHome.jsp">Home</a> <a href="manageStaff.jsp">Manage
				Staff</a> <a href="manageRooms.jsp">Manage Rooms</a> <a
				href="../logout.jsp">Logout</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>All Bookings</h3>
			<table class="table">
				<thead>
					<tr>
						<th>ID</th>
						<th>Guest</th>
						<th>Room</th>
						<th>Check-in</th>
						<th>Check-out</th>
						<th>Amount</th>
						<th>Status</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<%
					try {
						String q = "SELECT b.booking_id, u.name as guest_name, r.room_number, b.check_in, b.check_out, b.amount, b.status FROM bookings b JOIN users u ON b.user_id=u.user_id JOIN rooms r ON b.room_id=r.room_id ORDER BY b.created_at DESC";
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
						<td><%=rs.getString("status")%></td>
						<td>
							<%
							if (!"confirmed".equals(rs.getString("status"))) {
							%> <a
							class="btn"
							href="allBookings.jsp?action=confirm&booking_id=<%=rs.getInt("booking_id")%>">Confirm</a>
							<%
							}
							%> <%
 if (!"cancelled".equals(rs.getString("status"))) {
 %> <a
							class="btn" style="background: #c0392b;"
							href="allBookings.jsp?action=cancel&booking_id=<%=rs.getInt("booking_id")%>">Cancel</a>
							<%
							}
							%> <%
 if (!"pending".equals(rs.getString("status"))) {
 %> <a
							class="btn"
							href="allBookings.jsp?action=pend&booking_id=<%=rs.getInt("booking_id")%>">Set
								Pending</a> <%
 }
 %>
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
