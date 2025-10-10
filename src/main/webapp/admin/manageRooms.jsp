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
// Update room
if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("action") != null) {
	String act = request.getParameter("action");
	if ("update".equals(act)) {
		try {
	int rid = Integer.parseInt(request.getParameter("room_id"));
	String rnum = request.getParameter("room_number");
	String rtype = request.getParameter("room_type");
	double price = Double.parseDouble(request.getParameter("price"));
	String status = request.getParameter("status");
	PreparedStatement up = conn
			.prepareStatement("UPDATE rooms SET room_number=?, room_type=?, price=?, status=? WHERE room_id=?");
	up.setString(1, rnum);
	up.setString(2, rtype);
	up.setDouble(3, price);
	up.setString(4, status);
	up.setInt(5, rid);
	up.executeUpdate();
	up.close();
	msg = "Room updated.";
		} catch (Exception e) {
	msg = "Error: " + e.getMessage();
		}
	} else if ("add".equals(act)) {
		try {
	String rnum = request.getParameter("room_number");
	String rtype = request.getParameter("room_type");
	double price = Double.parseDouble(request.getParameter("price"));
	PreparedStatement ins = conn.prepareStatement(
			"INSERT INTO rooms (room_number, room_type, price, status) VALUES (?,?,?, 'available')");
	ins.setString(1, rnum);
	ins.setString(2, rtype);
	ins.setDouble(3, price);
	ins.executeUpdate();
	ins.close();
	msg = "Room added.";
		} catch (Exception e) {
	msg = "Error: " + e.getMessage();
		}
	} else if ("remove".equals(act)) {
		try {
	int rid = Integer.parseInt(request.getParameter("room_id"));
	PreparedStatement up = conn.prepareStatement("UPDATE rooms SET status='unavailable' WHERE room_id=?");
	up.setInt(1, rid);
	up.executeUpdate();
	up.close();
	msg = "Room set to unavailable.";
		} catch (Exception e) {
	msg = "Error: " + e.getMessage();
		}
	}
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Manage Rooms</title>
<link rel="stylesheet" href="../css/style1.css">
</head>
<body>
	<div class="header">
		<div>My Hotel (Admin)</div>
		<div class="nav">
			<a href="adminHome.jsp">Home</a> <a href="manageStaff.jsp">Manage
				Staff</a> <a href="allBookings.jsp">All Bookings</a> <a
				href="../logout.jsp">Logout</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>Add Room (Admin)</h3>
			<%
			if (msg != null) {
			%><div class="success"><%=msg%></div>
			<%
			}
			%>
			<form method="post">
				<input type="hidden" name="action" value="add">
				<div class="form-row">
					<input class="input" type="text" name="room_number"
						placeholder="Room number">
				</div>
				<div class="form-row">
					<input class="input" type="text" name="room_type"
						placeholder="Room type">
				</div>
				<div class="form-row">
					<input class="input" type="number" name="price" placeholder="Price">
				</div>
				<button class="btn" type="submit">Add Room</button>
			</form>
		</div>

		<div class="card">
			<h3>All Rooms</h3>
			<table class="table">
				<thead>
					<tr>
						<th>ID</th>
						<th>Number</th>
						<th>Type</th>
						<th>Price</th>
						<th>Status</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<%
					try {
						PreparedStatement pst = conn.prepareStatement("SELECT * FROM rooms ORDER BY room_id ASC");
						ResultSet rs = pst.executeQuery();
						while (rs.next()) {
					%>
					<tr>
						<form method="post">
							<td><%=rs.getInt("room_id")%><input type="hidden"
								name="room_id" value="<%=rs.getInt("room_id")%>"></td>
							<td><input class="input" type="text" name="room_number"
								value="<%=rs.getString("room_number")%>"></td>
							<td><input class="input" type="text" name="room_type"
								value="<%=rs.getString("room_type")%>"></td>
							<td><input class="input" type="number" step="0.01"
								name="price" value="<%=rs.getString("price")%>"></td>
							<td><select class="input" name="status">
									<option value="available"
										<%="available".equals(rs.getString("status")) ? "selected" : ""%>>available</option>
									<option value="unavailable"
										<%="unavailable".equals(rs.getString("status")) ? "selected" : ""%>>unavailable</option>
							</select></td>
							<td><input type="hidden" name="action" value="update">
								<button class="btn" type="submit">Update</button>
								<button class="btn" type="submit" name="action" value="remove"
									style="background: #c0392b;">Set Unavailable</button></td>
						</form>
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
