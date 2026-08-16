<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Timer Services";
  String pageSubtitle = "EJB Timer Service registry \u00b7 3 schedules \u00b7 all healthy";
  String activePage = "timers";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="space-y-4">
    <div class="card p-5">
      <div class="flex items-center justify-between mb-3">
        <div class="flex items-center gap-3">
          <span class="w-10 h-10 rounded-lg bg-primsoft text-primary flex items-center justify-center">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
          </span>
          <div><div class="font-medium text-sm">ShipmentStatusUpdateTimer</div><div class="text-xs text-ink/40 font-mono">SHIPMENT_STATUS_UPDATE</div></div>
        </div>
        <div class="flex items-center gap-2">
          <span class="tag tag-blue"><span class="tag-dot"></span>Declarative</span>
          <span class="tag tag-teal"><span class="tag-dot"></span>Scheduled</span>
        </div>
      </div>
      <div class="grid grid-cols-4 gap-4 text-sm pt-3 border-t border-line">
        <div><div class="text-xs text-ink/40 mb-0.5">Schedule</div><div class="font-mono text-xs">0 */15 * * * *</div></div>
        <div><div class="text-xs text-ink/40 mb-0.5">Last Run</div><div class="text-xs">15 Aug, 8:00 AM <span class="text-teal">&#10003; success</span></div></div>
        <div><div class="text-xs text-ink/40 mb-0.5">Next Run</div><div class="text-xs font-medium">15 Aug, 8:15 AM</div></div>
        <div class="flex items-center justify-end gap-2">
          <button class="px-3 py-1.5 rounded-lg border border-line text-xs font-medium hover:bg-bg">Trigger Now</button>
          <button class="px-3 py-1.5 rounded-lg border border-line text-xs font-medium hover:bg-bg">Pause</button>
        </div>
      </div>
    </div>

    <div class="card p-5">
      <div class="flex items-center justify-between mb-3">
        <div class="flex items-center gap-3">
          <span class="w-10 h-10 rounded-lg bg-primsoft text-primary flex items-center justify-center">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
          </span>
          <div><div class="font-medium text-sm">InventoryLevelCheckTimer</div><div class="text-xs text-ink/40 font-mono">INVENTORY_CHECK</div></div>
        </div>
        <div class="flex items-center gap-2">
          <span class="tag tag-slate"><span class="tag-dot"></span>Programmatic</span>
          <span class="tag tag-teal"><span class="tag-dot"></span>Scheduled</span>
        </div>
      </div>
      <div class="grid grid-cols-4 gap-4 text-sm pt-3 border-t border-line">
        <div><div class="text-xs text-ink/40 mb-0.5">Interval</div><div class="font-mono text-xs">3600 sec (1 hr)</div></div>
        <div><div class="text-xs text-ink/40 mb-0.5">Last Run</div><div class="text-xs">15 Aug, 7:00 AM <span class="text-teal">&#10003; success</span></div></div>
        <div><div class="text-xs text-ink/40 mb-0.5">Next Run</div><div class="text-xs font-medium">15 Aug, 8:00 AM</div></div>
        <div class="flex items-center justify-end gap-2">
          <button class="px-3 py-1.5 rounded-lg border border-line text-xs font-medium hover:bg-bg">Trigger Now</button>
          <button class="px-3 py-1.5 rounded-lg border border-line text-xs font-medium hover:bg-bg">Pause</button>
        </div>
      </div>
    </div>

    <div class="card p-5">
      <div class="flex items-center justify-between mb-3">
        <div class="flex items-center gap-3">
          <span class="w-10 h-10 rounded-lg bg-primsoft text-primary flex items-center justify-center">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10"/></svg>
          </span>
          <div><div class="font-medium text-sm">VendorPerformanceEvalTimer</div><div class="text-xs text-ink/40 font-mono">VENDOR_EVAL</div></div>
        </div>
        <div class="flex items-center gap-2">
          <span class="tag tag-blue"><span class="tag-dot"></span>Declarative</span>
          <span class="tag tag-teal"><span class="tag-dot"></span>Scheduled</span>
        </div>
      </div>
      <div class="grid grid-cols-4 gap-4 text-sm pt-3 border-t border-line">
        <div><div class="text-xs text-ink/40 mb-0.5">Schedule</div><div class="font-mono text-xs">0 0 1 * * * (monthly)</div></div>
        <div><div class="text-xs text-ink/40 mb-0.5">Last Run</div><div class="text-xs">01 Aug, 1:00 AM <span class="text-teal">&#10003; success</span></div></div>
        <div><div class="text-xs text-ink/40 mb-0.5">Next Run</div><div class="text-xs font-medium">01 Sep, 1:00 AM</div></div>
        <div class="flex items-center justify-end gap-2">
          <button class="px-3 py-1.5 rounded-lg border border-line text-xs font-medium hover:bg-bg">Trigger Now</button>
          <button class="px-3 py-1.5 rounded-lg border border-line text-xs font-medium hover:bg-bg">Pause</button>
        </div>
      </div>
    </div>
  </div>

<%@ include file="includes/footer.jspf" %>
