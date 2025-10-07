<%@ page import="java.sql.*"%>
<%@ include file="db.jsp"%>
<%
Integer userId = (Integer) session.getAttribute("userId");

if (userId != null) {
	try {
		PreparedStatement ps = conn.prepareStatement("UPDATE users SET login_status=0 WHERE user_id=?");
		ps.setInt(1, userId);
		ps.executeUpdate();
		ps.close();
		conn.close();
	} catch (Exception e) {
		out.println("Error: " + e.getMessage());
	}
}

// Destroy session
session.invalidate();

// Redirect to home
response.sendRedirect("index.jsp");
%>
