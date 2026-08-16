<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Customs Documents";
  String pageSubtitle = "3 documents \u00b7 1 pending approval";
  String activePage = "customs";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="flex items-center justify-between mb-5">
    <div class="flex items-center gap-1 p-1 bg-line/50 rounded-lg text-xs font-mono uppercase">
      <button class="px-3 py-1.5 rounded-md bg-white shadow-sm font-semibold">All</button>
      <button class="px-3 py-1.5 rounded-md text-ink/50">Pending</button>
      <button class="px-3 py-1.5 rounded-md text-ink/50">Approved</button>
    </div>
    <button class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold">+ Submit Document</button>
  </div>

  <div class="card overflow-hidden">
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
        <th class="px-5 py-3 font-medium">Document</th><th class="px-5 py-3 font-medium">Shipment</th><th class="px-5 py-3 font-medium">Country</th><th class="px-5 py-3 font-medium">Submitted</th><th class="px-5 py-3 font-medium">Status</th><th class="px-5 py-3 font-medium text-right">Actions</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr class="hover:bg-bg/60">
          <td class="px-5 py-3.5"><div class="font-medium">Bill of Lading</div><div class="font-mono text-xs text-ink/40">BOL-2026-0001</div></td>
          <td class="px-5 py-3.5 font-mono text-xs text-ink/60">SHP-20260702-001</td>
          <td class="px-5 py-3.5 text-ink/60">Sri Lanka</td>
          <td class="px-5 py-3.5 text-xs text-ink/40 font-mono">02 Jul 11:00</td>
          <td class="px-5 py-3.5"><span class="tag tag-teal"><span class="tag-dot"></span>Approved</span></td>
          <td class="px-5 py-3.5 text-right text-xs text-primary font-medium">View</td>
        </tr>
        <tr class="hover:bg-bg/60">
          <td class="px-5 py-3.5"><div class="font-medium">Certificate of Origin</div><div class="font-mono text-xs text-ink/40">COO-2026-0002</div></td>
          <td class="px-5 py-3.5 font-mono text-xs text-ink/60">SHP-20260706-002</td>
          <td class="px-5 py-3.5 text-ink/60">Sweden</td>
          <td class="px-5 py-3.5 text-xs text-ink/40 font-mono">06 Jul 10:00</td>
          <td class="px-5 py-3.5"><span class="tag tag-teal"><span class="tag-dot"></span>Approved</span></td>
          <td class="px-5 py-3.5 text-right text-xs text-primary font-medium">View</td>
        </tr>
        <tr class="hover:bg-bg/60 bg-ambersoft/30">
          <td class="px-5 py-3.5"><div class="font-medium">Import Declaration</div><div class="font-mono text-xs text-ink/40">IMD-2026-0003</div></td>
          <td class="px-5 py-3.5 font-mono text-xs text-ink/60">SHP-20260711-003</td>
          <td class="px-5 py-3.5 text-ink/60">UAE</td>
          <td class="px-5 py-3.5 text-xs text-ink/40 font-mono">11 Jul 14:00</td>
          <td class="px-5 py-3.5"><span class="tag tag-amber"><span class="tag-dot"></span>Pending</span></td>
          <td class="px-5 py-3.5 text-right space-x-2">
            <button class="text-xs text-teal font-medium">Approve</button>
            <button class="text-xs text-amber font-medium">Reject</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>

<%@ include file="includes/footer.jspf" %>
