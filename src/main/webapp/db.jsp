<%@ page import="java.sql.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
/* Central DB connection. Update dbUser/dbPass to match your MySQL credentials. */
String dbURL = "jdbc:mysql://localhost:3306/hotel_db?useSSL=false&serverTimezone=UTC";
String dbUser = "root"; // <-- CHANGE
String dbPass = "mayur"; // <-- CHANGE
Connection conn = null;
try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
} catch (Exception e) {
	out.println("<div style='color:red;padding:10px;'>DB connection error: " + e.getMessage() + "</div>");
	// conn stays null
}
%>
