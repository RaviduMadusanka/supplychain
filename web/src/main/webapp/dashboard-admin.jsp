<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Admin Dashboard";
  String pageSubtitle = "Saturday, 15 Aug 2026 \u00b7 Global operations overview";
  String activePage = "dashboard";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <!-- KPI row -->
  <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-5 gap-4 mb-8">
    <div class="card p-5">
      <div class="flex items-center justify-between mb-2"><span class="text-xs text-ink/50 font-medium">Active Shipments</span><span class="tag tag-blue"><span class="tag-dot"></span>Live</span></div>
      <div class="font-display text-3xl font-semibold">1,248</div>
      <div class="text-xs text-teal font-medium mt-1">&uarr; 4.2% vs last week</div>
    </div>
    <div class="card p-5">
      <div class="flex items-center justify-between mb-2"><span class="text-xs text-ink/50 font-medium">Open Exceptions</span><span class="tag tag-amber"><span class="tag-dot"></span>Attention</span></div>
      <div class="font-display text-3xl font-semibold text-amber">6</div>
      <div class="text-xs text-ink/40 mt-1">2 unresolved &gt; 24h</div>
    </div>
    <div class="card p-5">
      <div class="flex items-center justify-between mb-2"><span class="text-xs text-ink/50 font-medium">Low / Out of Stock</span></div>
      <div class="font-display text-3xl font-semibold">2</div>
      <div class="text-xs text-ink/40 mt-1">SKU-1002, SKU-1003</div>
    </div>
    <div class="card p-5">
      <div class="flex items-center justify-between mb-2"><span class="text-xs text-ink/50 font-medium">Pending Customs Docs</span></div>
      <div class="font-display text-3xl font-semibold">1</div>
      <div class="text-xs text-ink/40 mt-1">IMD-2026-0003 &middot; UAE</div>
    </div>
    <div class="card p-5">
      <div class="flex items-center justify-between mb-2"><span class="text-xs text-ink/50 font-medium">Timer Jobs</span><span class="tag tag-teal"><span class="tag-dot"></span>Running</span></div>
      <div class="font-display text-3xl font-semibold">3<span class="text-base text-ink/30 font-body">/3</span></div>
      <div class="text-xs text-ink/40 mt-1">All schedules healthy</div>
    </div>
  </div>

  <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
    <!-- shipments in transit -->
    <div class="xl:col-span-2 card">
      <div class="flex items-center justify-between px-5 py-4 border-b border-line">
        <h3 class="font-display font-semibold text-sm">Shipments in Transit</h3>
        <a href="shipments.jsp" class="text-xs text-primary font-medium hover:underline">View all &rarr;</a>
      </div>
      <table class="w-full text-sm">
        <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
          <th class="px-5 py-2.5 font-medium">Shipment</th><th class="px-5 py-2.5 font-medium">Route</th><th class="px-5 py-2.5 font-medium">Carrier</th><th class="px-5 py-2.5 font-medium">ETA</th><th class="px-5 py-2.5 font-medium">Status</th>
        </tr></thead>
        <tbody class="divide-y divide-line">
          <tr class="hover:bg-bg/60">
            <td class="px-5 py-3 font-mono text-xs">SHP-20260702-001</td>
            <td class="px-5 py-3 text-ink/70">Colombo &rarr; Colombo City</td>
            <td class="px-5 py-3 text-ink/70">DHL Express</td>
            <td class="px-5 py-3 text-ink/70">08 Jul, 5:00 PM</td>
            <td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>In Transit</span></td>
          </tr>
          <tr class="hover:bg-bg/60">
            <td class="px-5 py-3 font-mono text-xs">SHP-20260706-002</td>
            <td class="px-5 py-3 text-ink/70">Singapore &rarr; Stockholm</td>
            <td class="px-5 py-3 text-ink/70">Maersk Line</td>
            <td class="px-5 py-3 text-ink/70">14 Jul, 12:00 PM</td>
            <td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>Delivered</span></td>
          </tr>
          <tr class="hover:bg-bg/60">
            <td class="px-5 py-3 font-mono text-xs">SHP-20260711-003</td>
            <td class="px-5 py-3 text-ink/70">Dubai &rarr; Dubai</td>
            <td class="px-5 py-3 text-ink/70">FedEx Freight</td>
            <td class="px-5 py-3 text-ink/70">18 Jul, 3:00 PM</td>
            <td class="px-5 py-3"><span class="tag tag-slate"><span class="tag-dot"></span>Pending</span></td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- exception feed -->
    <div class="card">
      <div class="flex items-center justify-between px-5 py-4 border-b border-line">
        <h3 class="font-display font-semibold text-sm">Recent Exceptions</h3>
        <a href="monitoring.jsp" class="text-xs text-primary font-medium hover:underline">View log &rarr;</a>
      </div>
      <div class="divide-y divide-line">
        <div class="px-5 py-3.5">
          <div class="flex items-center justify-between mb-1"><span class="tag tag-slate"><span class="tag-dot"></span>Open</span><span class="text-[10px] text-ink/30 font-mono">11 Jul</span></div>
          <div class="text-sm font-medium">Customs API unreachable</div>
          <div class="text-xs text-ink/40 font-mono mt-0.5">CustomsIntegrationService</div>
        </div>
        <div class="px-5 py-3.5">
          <div class="flex items-center justify-between mb-1"><span class="tag tag-teal"><span class="tag-dot"></span>Resolved</span><span class="text-[10px] text-ink/30 font-mono">02 Aug</span></div>
          <div class="text-sm font-medium">Connection timeout syncing WH-SIN-01</div>
          <div class="text-xs text-ink/40 font-mono mt-0.5">InventorySyncMDB</div>
        </div>
        <div class="px-5 py-3.5">
          <div class="flex items-center justify-between mb-1"><span class="tag tag-teal"><span class="tag-dot"></span>Resolved</span><span class="text-[10px] text-ink/30 font-mono">10 Jul</span></div>
          <div class="text-sm font-medium">Invalid vendor reference on order</div>
          <div class="text-xs text-ink/40 font-mono mt-0.5">OrderProcessingBean</div>
        </div>
      </div>
    </div>
  </div>

<%@ include file="includes/footer.jspf" %>
