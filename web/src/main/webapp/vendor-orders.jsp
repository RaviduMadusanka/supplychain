<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Purchase Orders";
  String pageSubtitle = "Restock orders from warehouses \u00b7 1 pending your response";
  String activePage = "vendororders";
  String userName = "Sanduni Wickrama";
  String userRole = "Vendor";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="space-y-4">
    <div class="card p-5 ring-1 ring-amber/30">
      <div class="flex items-center justify-between mb-3">
        <div>
          <span class="font-mono text-xs text-ink/40">ORD-20260701-001</span>
          <div class="font-medium text-sm mt-0.5">Restock request from Colombo Central Warehouse</div>
        </div>
        <span class="tag tag-amber"><span class="tag-dot"></span>Awaiting Response</span>
      </div>
      <div class="grid grid-cols-3 gap-4 text-sm pt-3 border-t border-line mb-4">
        <div><div class="text-xs text-ink/40 mb-0.5">Product</div><div class="font-medium">Industrial Circuit Board</div></div>
        <div><div class="text-xs text-ink/40 mb-0.5">Quantity Requested</div><div class="font-mono font-medium">50</div></div>
        <div><div class="text-xs text-ink/40 mb-0.5">Requested</div><div class="text-xs text-ink/60 font-mono">01 Jul 2026, 09:15 AM</div></div>
      </div>
      <div class="flex justify-end gap-2">
        <button class="px-4 py-2 rounded-lg border border-line text-xs font-semibold hover:bg-bg transition text-amber">Reject</button>
        <button class="px-4 py-2 rounded-lg bg-primary text-white text-xs font-semibold hover:bg-primarydk transition">Accept Order</button>
      </div>
    </div>

    <div class="card p-5">
      <div class="flex items-center justify-between mb-3">
        <div>
          <span class="font-mono text-xs text-ink/40">ORD-20260610-014</span>
          <div class="font-medium text-sm mt-0.5">Restock request from Singapore Regional Hub</div>
        </div>
        <span class="tag tag-teal"><span class="tag-dot"></span>Accepted</span>
      </div>
      <div class="grid grid-cols-3 gap-4 text-sm pt-3 border-t border-line">
        <div><div class="text-xs text-ink/40 mb-0.5">Product</div><div class="font-medium">Industrial Circuit Board</div></div>
        <div><div class="text-xs text-ink/40 mb-0.5">Quantity</div><div class="font-mono font-medium">100</div></div>
        <div><div class="text-xs text-ink/40 mb-0.5">Accepted</div><div class="text-xs text-ink/60 font-mono">11 Jun 2026, 2:30 PM</div></div>
      </div>
    </div>
  </div>

<%@ include file="includes/footer.jspf" %>
