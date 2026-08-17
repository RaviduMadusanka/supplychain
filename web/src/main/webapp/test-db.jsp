<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.DataSource" %>
<html>
<body>
<h3>Database Users:</h3>
<table border="1">
<tr><th>Username</th><th>Password Hash</th><th>Role</th><th>Status</th></tr>
<%
    try {
        Context ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("jdbc/SupplyChainDB");
        Connection conn = ds.getConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT username, password_hash, role, status FROM users");
        while(rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getString(1) + "</td>");
            out.println("<td>" + rs.getString(2) + "</td>");
            out.println("<td>" + rs.getString(3) + "</td>");
            out.println("<td>" + rs.getString(4) + "</td>");
            out.println("</tr>");
        }
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
</table>
</body>
</html>
