<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Vendor Dashboard";
  String pageSubtitle = "Apex Tech Components \u00b7 VEN-001";
  String activePage = "dashboard";
  String userName = "Sanduni Wickrama";
  String userRole = "Vendor";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
    <div class="card p-5"><div class="text-xs text-ink/50 mb-1">Overall Rating</div><div class="font-display text-3xl font-semibold text-teal">4.50</div></div>
    <div class="card p-5"><div class="text-xs text-ink/50 mb-1">On-time Delivery</div><div class="font-display text-3xl font-semibold">92.5%</div></div>
    <div class="card p-5"><div class="text-xs text-ink/50 mb-1">Open Orders</div><div class="font-display text-3xl font-semibold">1</div></div>
    <div class="card p-5"><div class="text-xs text-ink/50 mb-1">Products Listed</div><div class="font-display text-3xl font-semibold">1</div></div>
  </div>

  <div class="card">
    <div class="px-5 py-4 border-b border-line"><h3 class="font-display font-semibold text-sm">Orders Assigned to You</h3></div>
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
        <th class="px-5 py-2.5 font-medium">Order</th><th class="px-5 py-2.5 font-medium">Customer</th><th class="px-5 py-2.5 font-medium">Total</th><th class="px-5 py-2.5 font-medium">Status</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr><td class="px-5 py-3 font-mono text-xs">ORD-20260701-001</td><td class="px-5 py-3">Colombo Retail Hub</td><td class="px-5 py-3 font-mono">$4,250.00</td><td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>Processing</span></td></tr>
      </tbody>
    </table>
  </div>

<%@ include file="includes/footer.jspf" %>
