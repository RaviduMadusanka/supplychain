<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Shipments";
  String pageSubtitle = "3 active shipments across 3 corridors";
  String activePage = "shipments";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="flex items-center justify-between mb-5">
    <input type="text" placeholder="Search shipment code, destination, carrier..." class="w-96 px-3.5 py-2 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
    <a href="shipment-tracking.jsp" class="text-xs text-primary font-medium hover:underline">Open customer tracking view &rarr;</a>
  </div>

  <div class="space-y-4">
    <!-- shipment card 1 -->
    <div class="card p-5">
      <div class="flex items-center justify-between mb-4">
        <div>
          <span class="font-mono text-xs text-ink/40">SHP-20260702-001</span>
          <div class="font-medium text-sm mt-0.5">Colombo Central Warehouse &rarr; Colombo, Sri Lanka</div>
        </div>
        <span class="tag tag-blue"><span class="tag-dot"></span>In Transit</span>
      </div>
      <div class="flex items-center gap-0 mb-2">
        <div class="route-node done"></div><div class="flex-1 route-line"></div>
        <div class="route-node done"></div><div class="flex-1 route-line"></div>
        <div class="route-node"></div><div class="flex-1 route-line"></div>
        <div class="route-node border-slate-300"></div>
      </div>
      <div class="grid grid-cols-4 text-[11px] font-mono text-ink/40 uppercase mb-4">
        <span>Picked up</span><span>Customs cleared</span><span class="text-primary">In transit</span><span>Delivery</span>
      </div>
      <div class="flex items-center justify-between text-xs text-ink/50 pt-3 border-t border-line">
        <span>Carrier: <span class="text-ink font-medium">DHL Express</span></span>
        <span>ETA: <span class="text-ink font-medium">08 Jul, 5:00 PM</span></span>
        <span>2 line items</span>
      </div>
    </div>

    <!-- shipment card 2 -->
    <div class="card p-5">
      <div class="flex items-center justify-between mb-4">
        <div>
          <span class="font-mono text-xs text-ink/40">SHP-20260706-002</span>
          <div class="font-medium text-sm mt-0.5">Singapore Regional Hub &rarr; Stockholm, Sweden</div>
        </div>
        <span class="tag tag-teal"><span class="tag-dot"></span>Delivered</span>
      </div>
      <div class="flex items-center gap-0 mb-2">
        <div class="route-node done"></div><div class="flex-1 route-line" style="background-image:none;background:#0EA5A4"></div>
        <div class="route-node done"></div><div class="flex-1 route-line" style="background-image:none;background:#0EA5A4"></div>
        <div class="route-node done"></div><div class="flex-1 route-line" style="background-image:none;background:#0EA5A4"></div>
        <div class="route-node done"></div>
      </div>
      <div class="grid grid-cols-4 text-[11px] font-mono text-ink/40 uppercase mb-4">
        <span>Picked up</span><span>Customs cleared</span><span>In transit</span><span class="text-teal">Delivered</span>
      </div>
      <div class="flex items-center justify-between text-xs text-ink/50 pt-3 border-t border-line">
        <span>Carrier: <span class="text-ink font-medium">Maersk Line</span></span>
        <span>Delivered: <span class="text-ink font-medium">13 Jul, 9:45 AM</span></span>
        <span>1 line item</span>
      </div>
    </div>

    <!-- shipment card 3 -->
    <div class="card p-5">
      <div class="flex items-center justify-between mb-4">
        <div>
          <span class="font-mono text-xs text-ink/40">SHP-20260711-003</span>
          <div class="font-medium text-sm mt-0.5">Dubai Logistics Park &rarr; Dubai, UAE</div>
        </div>
        <span class="tag tag-slate"><span class="tag-dot"></span>Pending</span>
      </div>
      <div class="flex items-center gap-0 mb-2">
        <div class="route-node"></div><div class="flex-1 route-line"></div>
        <div class="route-node"></div><div class="flex-1 route-line"></div>
        <div class="route-node"></div><div class="flex-1 route-line"></div>
        <div class="route-node"></div>
      </div>
      <div class="grid grid-cols-4 text-[11px] font-mono text-ink/40 uppercase mb-4">
        <span class="text-primary">Picked up</span><span>Customs cleared</span><span>In transit</span><span>Delivery</span>
      </div>
      <div class="flex items-center justify-between text-xs text-ink/50 pt-3 border-t border-line">
        <span>Carrier: <span class="text-ink font-medium">FedEx Freight</span></span>
        <span>ETA: <span class="text-ink font-medium">18 Jul, 3:00 PM</span></span>
        <span>1 line item &middot; awaiting customs approval</span>
      </div>
    </div>
  </div>

<%@ include file="includes/footer.jspf" %>
