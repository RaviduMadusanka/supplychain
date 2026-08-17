<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Vendor Dashboard";
  String pageSubtitle = "Apex Tech Components \u00b7 VEN-001";
  String activePage = "dashboard";
  String userName = "Sanduni Wickrama";
  String userRole = "Vendor";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
    <div class="card p-5">
      <div class="text-xs text-ink/50 mb-1">Overall Rating</div>
      <div class="font-display text-3xl font-semibold text-teal">4.50</div>
      <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Excellent standing</div>
    </div>
    <div class="card p-5">
      <div class="text-xs text-ink/50 mb-1">On-time Delivery</div>
      <div class="font-display text-3xl font-semibold">92.5%</div>
      <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Last 30 days</div>
    </div>
    <div class="card p-5">
      <div class="text-xs text-ink/50 mb-1">Open Orders</div>
      <div class="font-display text-3xl font-semibold text-primary">2</div>
      <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Awaiting your action</div>
    </div>
    <div class="card p-5">
      <div class="text-xs text-ink/50 mb-1">Products Listed</div>
      <div class="font-display text-3xl font-semibold">1</div>
      <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Active SKUs</div>
    </div>
  </div>

  <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <div class="lg:col-span-2 space-y-6">
      <div class="card">
        <div class="px-5 py-4 border-b border-line flex items-center justify-between">
          <h3 class="font-display font-semibold text-sm">Recent Purchase Orders</h3>
          <a href="purchase-orders.jsp" class="text-primary text-xs font-semibold hover:underline">View All &rarr;</a>
        </div>
        <table class="w-full text-sm">
          <thead>
            <tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
              <th class="px-5 py-2.5 font-medium">PO Ref</th>
              <th class="px-5 py-2.5 font-medium">Product</th>
              <th class="px-5 py-2.5 font-medium">Qty</th>
              <th class="px-5 py-2.5 font-medium">Warehouse</th>
              <th class="px-5 py-2.5 font-medium">Status</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-line">
            <tr class="hover:bg-bg/50 transition">
              <td class="px-5 py-3 font-mono text-xs text-ink/70">PO-2026-0041</td>
              <td class="px-5 py-3 font-medium">Industrial Circuit Board</td>
              <td class="px-5 py-3 font-mono">200</td>
              <td class="px-5 py-3 text-xs">Colombo Central</td>
              <td class="px-5 py-3"><span class="tag tag-amber"><span class="tag-dot"></span>Pending</span></td>
            </tr>
            <tr class="hover:bg-bg/50 transition">
              <td class="px-5 py-3 font-mono text-xs text-ink/70">PO-2026-0038</td>
              <td class="px-5 py-3 font-medium">Industrial Circuit Board</td>
              <td class="px-5 py-3 font-mono">150</td>
              <td class="px-5 py-3 text-xs">Singapore Hub</td>
              <td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>Accepted</span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div class="space-y-6">
      <div class="card">
        <div class="px-5 py-4 border-b border-line">
          <h3 class="font-display font-semibold text-sm">Performance Summary</h3>
        </div>
        <div class="divide-y divide-line">
          <div class="p-5">
            <div class="flex items-center justify-between mb-2">
              <span class="text-xs font-medium text-ink/70">On-time Delivery</span>
              <span class="text-xs font-mono font-semibold">92.5%</span>
            </div>
            <div class="w-full bg-bg rounded-full h-1.5 overflow-hidden">
              <div class="bg-teal h-1.5 rounded-full" style="width: 92.5%"></div>
            </div>
          </div>
          <div class="p-5 flex items-center justify-between">
            <span class="text-xs font-medium text-ink/70">Quality Score</span>
            <span class="text-xs font-mono font-semibold">4.5 <span class="text-ink/40 font-normal">/ 5.0</span></span>
          </div>
          <div class="p-5 flex items-center justify-between">
            <span class="text-xs font-medium text-ink/70">Return Rate</span>
            <span class="text-xs font-mono font-semibold text-teal">1.2%</span>
          </div>
        </div>
      </div>
    </div>
  </div>

<%@ include file="includes/footer.jspf" %>
