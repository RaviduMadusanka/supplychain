<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.DataSource" %>
<html>
<body style="font-family: sans-serif; padding: 20px;">
<h2>Database Fixer</h2>
<%
    try {
        Context ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("jdbc/SupplyChainDB");
        Connection conn = ds.getConnection();
        Statement stmt = conn.createStatement();

        int updated = stmt.executeUpdate("UPDATE users SET password_hash = 'm4dppKdClZotApjDb7cGI/LfrNqENiN98I2N/Vs3N0w='");
        out.println("<p style='color: green;'>Successfully reset passwords to <b>pass123</b> for " + updated + " users.</p>");

        out.println("<h3>Current Users:</h3><table border='1' cellpadding='5' style='border-collapse: collapse;'>");
        out.println("<tr><th>Username</th><th>Role</th><th>Status</th></tr>");
        ResultSet rs = stmt.executeQuery("SELECT username, role, status FROM users");
        while(rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getString(1) + "</td>");
            out.println("<td>" + rs.getString(2) + "</td>");
            out.println("<td>" + rs.getString(3) + "</td>");
            out.println("</tr>");
        }
        conn.close();
        
        out.println("</table>");
        out.println("<br><a href='login.jsp'>Go to Login</a>");
    } catch (Exception e) {
        out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>
