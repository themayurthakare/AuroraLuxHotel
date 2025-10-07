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
if (request.getParameter("room_id") != null) {
	try {
		int rid = Integer.parseInt(request.getParameter("room_id"));
		PreparedStatement up = conn.prepareStatement("UPDATE rooms SET status='unavailable' WHERE room_id=?");
		up.setInt(1, rid);
		up.executeUpdate();
		up.close();
		msg = "Room removed (status set to unavailable).";
	} catch (Exception e) {
		msg = "Error: " + e.getMessage();
	}
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Remove Room</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
	<div class="header">
		<div>My Hotel (Staff)</div>
		<div class="nav">
			<a href="staffHome.jsp">Home</a> <a href="addRoom.jsp">Add Room</a> <a
				href="availableRooms.jsp">Vacant Rooms</a> <a href="../logout.jsp">Logout</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>Remove Room</h3>
			<%
			if (msg != null) {
			%><div class="success"><%=msg%></div>
			<%
			}
			%>
			<form method="get">
				<div class="form-row">
					<select class="input" name="room_id">
						<option value="">Select room</option>
						<%
						try {
							PreparedStatement pst = conn.prepareStatement("SELECT room_id, room_number FROM rooms WHERE status='available'");
							ResultSet rs = pst.executeQuery();
							while (rs.next()) {
						%>
						<option value="<%=rs.getInt("room_id")%>">Room
							<%=rs.getString("room_number")%></option>
						<%
						}
						rs.close();
						pst.close();
						} catch (Exception e) {
						}
						%>
					</select>
				</div>
				<button class="btn" type="submit">Remove (set unavailable)</button>
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
