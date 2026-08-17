<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Warehouses";
  String pageSubtitle = "3 facilities \u00b7 global network";
  String activePage = "warehouses";
  String userName = "Saman Kumara";
  String userRole = "Warehouse Manager";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
    <div class="card p-5">
      <div class="flex items-center justify-between mb-3">
        <div><div class="font-medium text-sm">Colombo Central Warehouse</div><div class="font-mono text-xs text-ink/40">WH-COL-01</div></div>
        <span class="tag tag-teal"><span class="tag-dot"></span>64%</span>
      </div>
      <div class="text-xs text-ink/50 mb-3">Peliyagoda, Colombo &middot; Sri Lanka</div>
      <div class="h-2 bg-line rounded-full overflow-hidden mb-1"><div class="h-full bg-primary" style="width:64%"></div></div>
      <div class="flex justify-between text-xs font-mono text-ink/40"><span>32,000 used</span><span>50,000 capacity</span></div>
      <div class="mt-4 pt-4 border-t border-line text-xs text-ink/50">Manager: <span class="text-ink font-medium">Kasun Fernando</span></div>
    </div>
    <div class="card p-5">
      <div class="flex items-center justify-between mb-3">
        <div><div class="font-medium text-sm">Singapore Regional Hub</div><div class="font-mono text-xs text-ink/40">WH-SIN-01</div></div>
        <span class="tag tag-amber"><span class="tag-dot"></span>76%</span>
      </div>
      <div class="text-xs text-ink/50 mb-3">Jurong, Singapore</div>
      <div class="h-2 bg-line rounded-full overflow-hidden mb-1"><div class="h-full bg-amber" style="width:76%"></div></div>
      <div class="flex justify-between text-xs font-mono text-ink/40"><span>61,000 used</span><span>80,000 capacity</span></div>
      <div class="mt-4 pt-4 border-t border-line text-xs text-ink/50">Manager: <span class="text-ink font-medium">Unassigned</span></div>
    </div>
    <div class="card p-5">
      <div class="flex items-center justify-between mb-3">
        <div><div class="font-medium text-sm">Dubai Logistics Park</div><div class="font-mono text-xs text-ink/40">WH-DXB-01</div></div>
        <span class="tag tag-teal"><span class="tag-dot"></span>62%</span>
      </div>
      <div class="text-xs text-ink/50 mb-3">Jebel Ali, Dubai &middot; UAE</div>
      <div class="h-2 bg-line rounded-full overflow-hidden mb-1"><div class="h-full bg-primary" style="width:62%"></div></div>
      <div class="flex justify-between text-xs font-mono text-ink/40"><span>40,000 used</span><span>65,000 capacity</span></div>
      <div class="mt-4 pt-4 border-t border-line text-xs text-ink/50">Manager: <span class="text-ink font-medium">Unassigned</span></div>
    </div>
  </div>

<%@ include file="includes/footer.jspf" %>
