<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Purchase Orders";
  String pageSubtitle = "Restock orders assigned to Apex Tech Components";
  String activePage = "purchaseorders";
  String userName = "Sanduni Wickrama";
  String userRole = "Vendor";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<div class="flex items-center gap-4 mb-6">
  <div class="px-4 py-2 bg-white rounded-lg border border-line flex items-center gap-3">
    <span class="w-2 h-2 rounded-full bg-amber"></span>
    <span class="text-xs font-medium text-ink/60">Pending</span>
    <span class="font-mono text-sm font-semibold">1</span>
  </div>
  <div class="px-4 py-2 bg-white rounded-lg border border-line flex items-center gap-3">
    <span class="w-2 h-2 rounded-full bg-teal"></span>
    <span class="text-xs font-medium text-ink/60">Accepted</span>
    <span class="font-mono text-sm font-semibold">1</span>
  </div>
  <div class="px-4 py-2 bg-white rounded-lg border border-line flex items-center gap-3">
    <span class="w-2 h-2 rounded-full bg-slate-400"></span>
    <span class="text-xs font-medium text-ink/60">Rejected</span>
    <span class="font-mono text-sm font-semibold">1</span>
  </div>
</div>

<div class="card">
  <table class="w-full text-sm">
    <thead>
      <tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
        <th class="px-5 py-2.5 font-medium">PO Ref</th>
        <th class="px-5 py-2.5 font-medium">Product</th>
        <th class="px-5 py-2.5 font-medium text-right">Qty</th>
        <th class="px-5 py-2.5 font-medium">Requested By</th>
        <th class="px-5 py-2.5 font-medium">Date</th>
        <th class="px-5 py-2.5 font-medium">Status</th>
        <th class="px-5 py-2.5 font-medium text-right">Actions</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-line">
      <!-- Pending Row -->
      <tr class="hover:bg-bg/50 transition">
        <td class="px-5 py-3 font-mono text-xs text-ink/70">PO-2026-0041</td>
        <td class="px-5 py-3">
          <div class="font-medium">Industrial Circuit Board</div>
          <div class="text-xs text-ink/40 font-mono mt-0.5">SKU-1001</div>
        </td>
        <td class="px-5 py-3 text-right font-mono font-semibold">200</td>
        <td class="px-5 py-3 text-xs">Colombo Central WH</td>
        <td class="px-5 py-3 text-xs font-mono text-ink/60">01 Aug 2026</td>
        <td class="px-5 py-3"><span class="tag tag-amber"><span class="tag-dot"></span>Pending</span></td>
        <td class="px-5 py-3 text-right">
          <div class="flex items-center justify-end gap-2">
            <button class="px-3 py-1.5 rounded-md bg-teal text-white text-[11px] font-semibold hover:bg-teal/90 transition shadow-sm">Accept</button>
            <button class="px-3 py-1.5 rounded-md bg-amber text-white text-[11px] font-semibold hover:bg-amber/90 transition shadow-sm">Reject</button>
          </div>
        </td>
      </tr>
      <!-- Accepted Row -->
      <tr class="hover:bg-bg/50 transition">
        <td class="px-5 py-3 font-mono text-xs text-ink/70">PO-2026-0038</td>
        <td class="px-5 py-3">
          <div class="font-medium">Industrial Circuit Board</div>
          <div class="text-xs text-ink/40 font-mono mt-0.5">SKU-1001</div>
        </td>
        <td class="px-5 py-3 text-right font-mono font-semibold">150</td>
        <td class="px-5 py-3 text-xs">Singapore Hub</td>
        <td class="px-5 py-3 text-xs font-mono text-ink/60">28 Jul 2026</td>
        <td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>Accepted</span></td>
        <td class="px-5 py-3 text-right">
          <span class="text-xs text-ink/40 italic">&mdash;</span>
        </td>
      </tr>
      <!-- Rejected Row -->
      <tr class="hover:bg-bg/50 transition opacity-75">
        <td class="px-5 py-3 font-mono text-xs text-ink/70">PO-2026-0035</td>
        <td class="px-5 py-3">
          <div class="font-medium">Industrial Circuit Board</div>
          <div class="text-xs text-ink/40 font-mono mt-0.5">SKU-1001</div>
        </td>
        <td class="px-5 py-3 text-right font-mono font-semibold">100</td>
        <td class="px-5 py-3 text-xs">Dubai Logistics</td>
        <td class="px-5 py-3 text-xs font-mono text-ink/60">20 Jul 2026</td>
        <td class="px-5 py-3"><span class="tag tag-slate"><span class="tag-dot"></span>Rejected</span></td>
        <td class="px-5 py-3 text-right">
          <span class="text-xs text-ink/40 italic">&mdash;</span>
        </td>
      </tr>
    </tbody>
  </table>
</div>

<%@ include file="includes/footer.jspf" %>
