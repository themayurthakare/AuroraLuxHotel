<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db.jsp"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Hotel Booking - Home</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<div class="header">
		<div>
			<strong>AuroraLux Hotel</strong>
		</div>
		<div class="nav">
			<a href="login.jsp">Login</a> <a href="register.jsp">Register</a>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h2>Welcome to My Hotel</h2>
			<p class="small">Comfortable rooms. Easy booking. Friendly staff.</p>
		</div>

		<div class="card">
			<h3>Featured Rooms</h3>
			<div class="grid">
				<%
				try {
					String q = "SELECT room_number, room_type, price FROM rooms WHERE status='available' LIMIT 6";
					PreparedStatement pst = conn.prepareStatement(q);
					ResultSet rs = pst.executeQuery();
					while (rs.next()) {
				%>
				<div class="room-card">
					<h4>
						Room
						<%=rs.getString("room_number")%>
						—
						<%=rs.getString("room_type")%></h4>
					<p class="small">
						Price: ₹<%=rs.getString("price")%>
						/ night
					</p>
					<a class="btn" href="rooms.jsp">Book Now</a>
				</div>
				<%
				}
				rs.close();
				pst.close();
				} catch (Exception e) {
				out.println("<div class='error'>" + e.getMessage() + "</div>");
				}
				%>
			</div>
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
