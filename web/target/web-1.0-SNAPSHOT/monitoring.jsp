<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Exceptions & Audit";
  String pageSubtitle = "System resilience \u00b7 accountability trail";
  String activePage = "monitoring";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="flex items-center gap-1 mb-5 border-b border-line">
    <button onclick="mTab(event,'m-exceptions')" class="mtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-primary text-primary">Exception Log</button>
    <button onclick="mTab(event,'m-audit')" class="mtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-transparent text-ink/50">Audit Log</button>
    <button onclick="mTab(event,'m-txn')" class="mtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-transparent text-ink/50">Transaction Audit</button>
  </div>

  <div id="m-exceptions" class="card overflow-hidden">
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
        <th class="px-5 py-3 font-medium">Type</th><th class="px-5 py-3 font-medium">Source</th><th class="px-5 py-3 font-medium">Message</th><th class="px-5 py-3 font-medium">Occurred</th><th class="px-5 py-3 font-medium">Status</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr class="hover:bg-bg/60"><td class="px-5 py-3"><span class="tag tag-slate"><span class="tag-dot"></span>System</span></td><td class="px-5 py-3 font-mono text-xs text-ink/60">InventorySyncMDB</td><td class="px-5 py-3 text-ink/70">Connection timeout while syncing warehouse WH-SIN-01</td><td class="px-5 py-3 text-xs text-ink/40 font-mono">02 Aug 08:10</td><td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>Resolved</span></td></tr>
        <tr class="hover:bg-bg/60"><td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>Application</span></td><td class="px-5 py-3 font-mono text-xs text-ink/60">OrderProcessingBean</td><td class="px-5 py-3 text-ink/70">Invalid vendor reference for order ORD-20260710-003</td><td class="px-5 py-3 text-xs text-ink/40 font-mono">10 Jul 11:05</td><td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>Resolved</span></td></tr>
        <tr class="hover:bg-bg/60 bg-ambersoft/30"><td class="px-5 py-3"><span class="tag tag-slate"><span class="tag-dot"></span>System</span></td><td class="px-5 py-3 font-mono text-xs text-ink/60">CustomsIntegrationService</td><td class="px-5 py-3 text-ink/70">Customs API unreachable for shipment SHP-20260711-003</td><td class="px-5 py-3 text-xs text-ink/40 font-mono">11 Jul 14:01</td><td class="px-5 py-3"><span class="tag tag-amber"><span class="tag-dot"></span>Open</span></td></tr>
      </tbody>
    </table>
  </div>

  <div id="m-audit" class="card overflow-hidden hidden">
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
        <th class="px-5 py-3 font-medium">Entity</th><th class="px-5 py-3 font-medium">Action</th><th class="px-5 py-3 font-medium">Performed By</th><th class="px-5 py-3 font-medium">Details</th><th class="px-5 py-3 font-medium">Time</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr class="hover:bg-bg/60"><td class="px-5 py-3 font-mono text-xs">orders #1</td><td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>Create</span></td><td class="px-5 py-3">Kasun Fernando</td><td class="px-5 py-3 text-ink/60">Order ORD-20260701-001 created for Colombo Retail Hub</td><td class="px-5 py-3 text-xs text-ink/40 font-mono">01 Jul 09:15</td></tr>
        <tr class="hover:bg-bg/60"><td class="px-5 py-3 font-mono text-xs">shipments #2</td><td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>Update</span></td><td class="px-5 py-3">Kasun Fernando</td><td class="px-5 py-3 text-ink/60">Shipment SHP-20260706-002 marked DELIVERED</td><td class="px-5 py-3 text-xs text-ink/40 font-mono">13 Jul 09:45</td></tr>
        <tr class="hover:bg-bg/60"><td class="px-5 py-3 font-mono text-xs">customs_documents #3</td><td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>Create</span></td><td class="px-5 py-3">Nadeesha Perera</td><td class="px-5 py-3 text-ink/60">Import Declaration IMD-2026-0003 submitted for review</td><td class="px-5 py-3 text-xs text-ink/40 font-mono">11 Jul 14:00</td></tr>
      </tbody>
    </table>
  </div>

  <div id="m-txn" class="card overflow-hidden hidden">
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
        <th class="px-5 py-3 font-medium">Transaction Type</th><th class="px-5 py-3 font-medium">Reference</th><th class="px-5 py-3 font-medium">Attribute</th><th class="px-5 py-3 font-medium">Performed By</th><th class="px-5 py-3 font-medium">Status</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr class="hover:bg-bg/60"><td class="px-5 py-3">ORDER_CREATION</td><td class="px-5 py-3 font-mono text-xs text-ink/60">ORD-20260701-001</td><td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>REQUIRED</span></td><td class="px-5 py-3">Kasun Fernando</td><td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>Committed</span></td></tr>
        <tr class="hover:bg-bg/60"><td class="px-5 py-3">SHIPMENT_UPDATE</td><td class="px-5 py-3 font-mono text-xs text-ink/60">SHP-20260706-002</td><td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>REQUIRES_NEW</span></td><td class="px-5 py-3">Kasun Fernando</td><td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>Committed</span></td></tr>
        <tr class="hover:bg-bg/60"><td class="px-5 py-3">INVENTORY_ADJUSTMENT</td><td class="px-5 py-3 font-mono text-xs text-ink/60">SKU-1003</td><td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>MANDATORY</span></td><td class="px-5 py-3">Nadeesha Perera</td><td class="px-5 py-3"><span class="tag tag-amber"><span class="tag-dot"></span>Rolled Back</span></td></tr>
      </tbody>
    </table>
  </div>

<script>
function mTab(e,id){
  document.querySelectorAll('#m-exceptions,#m-audit,#m-txn').forEach(el=>el.classList.add('hidden'));
  document.getElementById(id).classList.remove('hidden');
  document.querySelectorAll('.mtabbtn').forEach(b=>{ b.classList.remove('border-primary','text-primary'); b.classList.add('border-transparent','text-ink/50'); });
  e.currentTarget.classList.add('border-primary','text-primary');
  e.currentTarget.classList.remove('border-transparent','text-ink/50');
}
</script>

<%@ include file="includes/footer.jspf" %>
