<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db.jsp"%>
<%
String checkIn = request.getParameter("check_in");
String checkOut = request.getParameter("check_out");
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Rooms</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<div class="header">
		<div>My Hotel</div>
		<div class="nav">
			<a href="home.jsp">Home</a>
			<%
			Integer userId = (Integer) session.getAttribute("userId");
			if (userId == null) {
			%>
			<a href="login.jsp">Login</a>
			<%
			} else {
			%>
			<a href="logout.jsp">Logout</a>
			<%
			}
			%>
		</div>
	</div>
	<div class="container">
		<div class="card">
			<h3>Check availability</h3>
			<form method="get">
				<div class="form-row">
					<label>Check-in</label> <input class="input" type="date"
						name="check_in" value="<%=(checkIn != null ? checkIn : "")%>">
				</div>
				<div class="form-row">
					<label>Check-out</label> <input class="input" type="date"
						name="check_out" value="<%=(checkOut != null ? checkOut : "")%>">
				</div>
				<button class="btn" type="submit">Search</button>
			</form>
		</div>

		<%
		if (checkIn != null && checkOut != null && !checkIn.isEmpty() && !checkOut.isEmpty()) {
		%>
		<div class="card">
			<h3>
				Available rooms from
				<%=checkIn%>
				to
				<%=checkOut%>
			</h3>
			<div class="grid">
				<%
				try {
					String q = "SELECT * FROM rooms r WHERE r.status='available' AND r.room_id NOT IN "
					+ "(SELECT b.room_id FROM bookings b WHERE b.status IN ('pending','confirmed') "
					+ "AND NOT (b.check_out <= ? OR b.check_in >= ?))";
					PreparedStatement pst = conn.prepareStatement(q);
					pst.setString(1, checkIn);
					pst.setString(2, checkOut);
					ResultSet rs = pst.executeQuery();
					while (rs.next()) {
				%>
				<div class="room-card">
					<h4>
						Room
						<%=rs.getString("room_number")%>
						—
						<%=rs.getString("room_type")%>
					</h4>
					<p class="small">
						Price: ₹<%=rs.getString("price")%>
						/ night
					</p>
					<form method="post" action="bookingForm.jsp">
						<input type="hidden" name="room_id"
							value="<%=rs.getInt("room_id")%>"> <input type="hidden"
							name="check_in" value="<%=checkIn%>"> <input
							type="hidden" name="check_out" value="<%=checkOut%>">
						<button class="btn" type="submit">Book</button>
					</form>
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
		<%
		} else {
		%>
		<div class="card small">Choose check-in and check-out dates to
			see availability.</div>
		<%
		}
		%>

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
