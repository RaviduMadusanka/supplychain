<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Route Optimization";
  String pageSubtitle = "366.25 km saved this month across 3 shipments";
  String activePage = "routes";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
    <div class="card p-5"><div class="text-xs text-ink/50 mb-1">Total Distance Saved</div><div class="font-display text-2xl font-semibold text-teal">366.25 km</div></div>
    <div class="card p-5"><div class="text-xs text-ink/50 mb-1">Routes Recalculated</div><div class="font-display text-2xl font-semibold">3</div></div>
    <div class="card p-5"><div class="text-xs text-ink/50 mb-1">Est. Fuel/Cost Saved</div><div class="font-display text-2xl font-semibold">$1,140</div></div>
  </div>

  <div class="space-y-4">
    <div class="card p-5">
      <div class="flex items-center justify-between mb-3">
        <span class="font-mono text-xs text-ink/40">SHP-20260702-001</span>
        <span class="tag tag-teal"><span class="tag-dot"></span>-210.50 km</span>
      </div>
      <div class="grid grid-cols-2 gap-4 text-sm">
        <div class="p-3 rounded-lg bg-bg"><div class="text-[10px] font-mono uppercase text-ink/40 mb-1">Old Route</div><div class="text-ink/70">Colombo Port &rarr; Chennai &rarr; Colombo City</div></div>
        <div class="p-3 rounded-lg bg-tealsoft"><div class="text-[10px] font-mono uppercase text-teal mb-1">Optimized Route</div><div class="text-ink">Colombo Port &rarr; Colombo City (Direct)</div></div>
      </div>
      <div class="text-xs text-ink/40 mt-3 font-mono">Calculated 02 Jul, 10:30 AM</div>
    </div>

    <div class="card p-5">
      <div class="flex items-center justify-between mb-3">
        <span class="font-mono text-xs text-ink/40">SHP-20260706-002</span>
        <span class="tag tag-teal"><span class="tag-dot"></span>-95.75 km</span>
      </div>
      <div class="grid grid-cols-2 gap-4 text-sm">
        <div class="p-3 rounded-lg bg-bg"><div class="text-[10px] font-mono uppercase text-ink/40 mb-1">Old Route</div><div class="text-ink/70">Singapore &rarr; Rotterdam &rarr; Stockholm</div></div>
        <div class="p-3 rounded-lg bg-tealsoft"><div class="text-[10px] font-mono uppercase text-teal mb-1">Optimized Route</div><div class="text-ink">Singapore &rarr; Hamburg &rarr; Stockholm</div></div>
      </div>
      <div class="text-xs text-ink/40 mt-3 font-mono">Calculated 06 Jul, 9:00 AM</div>
    </div>

    <div class="card p-5">
      <div class="flex items-center justify-between mb-3">
        <span class="font-mono text-xs text-ink/40">SHP-20260711-003</span>
        <span class="tag tag-teal"><span class="tag-dot"></span>-60.00 km</span>
      </div>
      <div class="grid grid-cols-2 gap-4 text-sm">
        <div class="p-3 rounded-lg bg-bg"><div class="text-[10px] font-mono uppercase text-ink/40 mb-1">Old Route</div><div class="text-ink/70">Jebel Ali &rarr; Abu Dhabi &rarr; Dubai</div></div>
        <div class="p-3 rounded-lg bg-tealsoft"><div class="text-[10px] font-mono uppercase text-teal mb-1">Optimized Route</div><div class="text-ink">Jebel Ali &rarr; Dubai (Direct)</div></div>
      </div>
      <div class="text-xs text-ink/40 mt-3 font-mono">Calculated 11 Jul, 1:45 PM</div>
    </div>
  </div>

<%@ include file="includes/footer.jspf" %>
