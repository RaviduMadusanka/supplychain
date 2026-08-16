<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Orders";
  String pageSubtitle = "3 orders \u00b7 $15,990.75 total value";
  String activePage = "orders";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="flex items-center justify-between mb-5">
    <div class="flex items-center gap-1 p-1 bg-line/50 rounded-lg text-xs font-mono uppercase">
      <button class="px-3 py-1.5 rounded-md bg-white shadow-sm font-semibold">All</button>
      <button class="px-3 py-1.5 rounded-md text-ink/50">Processing</button>
      <button class="px-3 py-1.5 rounded-md text-ink/50">Shipped</button>
      <button class="px-3 py-1.5 rounded-md text-ink/50">Delivered</button>
    </div>
    <button class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold">+ Create Order</button>
  </div>

  <div class="card overflow-hidden">
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
        <th class="px-5 py-3 font-medium">Order</th><th class="px-5 py-3 font-medium">Customer</th><th class="px-5 py-3 font-medium">Vendor</th><th class="px-5 py-3 font-medium">Total</th><th class="px-5 py-3 font-medium">Created</th><th class="px-5 py-3 font-medium">Status</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr class="hover:bg-bg/60 cursor-pointer">
          <td class="px-5 py-3.5 font-mono text-xs">ORD-20260701-001</td><td class="px-5 py-3.5">Colombo Retail Hub</td><td class="px-5 py-3.5 text-ink/60">Apex Tech Components</td><td class="px-5 py-3.5 font-mono">$4,250.00</td><td class="px-5 py-3.5 text-xs text-ink/40 font-mono">01 Jul 09:15</td><td class="px-5 py-3.5"><span class="tag tag-blue"><span class="tag-dot"></span>Processing</span></td>
        </tr>
        <tr class="hover:bg-bg/60 cursor-pointer">
          <td class="px-5 py-3.5 font-mono text-xs">ORD-20260705-002</td><td class="px-5 py-3.5">Nordic Trading Co</td><td class="px-5 py-3.5 text-ink/60">Global Parts Ltd</td><td class="px-5 py-3.5 font-mono">$8,760.50</td><td class="px-5 py-3.5 text-xs text-ink/40 font-mono">05 Jul 14:30</td><td class="px-5 py-3.5"><span class="tag tag-slate"><span class="tag-dot"></span>Shipped</span></td>
        </tr>
        <tr class="hover:bg-bg/60 cursor-pointer">
          <td class="px-5 py-3.5 font-mono text-xs">ORD-20260710-003</td><td class="px-5 py-3.5">Dubai Import Partners</td><td class="px-5 py-3.5 text-ink/60">Pacific Freight Supplies</td><td class="px-5 py-3.5 font-mono">$1,980.25</td><td class="px-5 py-3.5 text-xs text-ink/40 font-mono">10 Jul 11:00</td><td class="px-5 py-3.5"><span class="tag tag-teal"><span class="tag-dot"></span>Delivered</span></td>
        </tr>
      </tbody>
    </table>
  </div>

  <!-- expanded order detail example -->
  <div class="card mt-6">
    <div class="px-5 py-4 border-b border-line flex items-center justify-between">
      <div><h3 class="font-display font-semibold text-sm">Order ORD-20260701-001</h3><p class="text-xs text-ink/40 mt-0.5">Colombo Retail Hub &middot; Apex Tech Components</p></div>
      <span class="tag tag-blue"><span class="tag-dot"></span>Processing</span>
    </div>
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
        <th class="px-5 py-2.5 font-medium">Product</th><th class="px-5 py-2.5 font-medium">SKU</th><th class="px-5 py-2.5 font-medium">Qty</th><th class="px-5 py-2.5 font-medium">Unit Price</th><th class="px-5 py-2.5 font-medium text-right">Line Total</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr><td class="px-5 py-3">Industrial Circuit Board</td><td class="px-5 py-3 font-mono text-xs text-ink/50">SKU-1001</td><td class="px-5 py-3 font-mono">50</td><td class="px-5 py-3 font-mono">$85.00</td><td class="px-5 py-3 font-mono text-right">$4,250.00</td></tr>
      </tbody>
      <tfoot><tr class="border-t border-line"><td colspan="4" class="px-5 py-3 text-right text-sm font-semibold">Order Total</td><td class="px-5 py-3 font-mono text-right font-semibold">$4,250.00</td></tr></tfoot>
    </table>
  </div>

<%@ include file="includes/footer.jspf" %>
