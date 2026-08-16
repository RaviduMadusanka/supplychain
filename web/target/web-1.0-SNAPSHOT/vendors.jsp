<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Vendors";
  String pageSubtitle = "3 vendors \u00b7 across 3 countries";
  String activePage = "vendors";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="flex items-center justify-between mb-5">
    <div class="flex items-center gap-2">
      <input type="text" placeholder="Search vendor code, name, country..." class="w-80 px-3.5 py-2 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
      <select class="px-3 py-2 rounded-lg border border-line bg-white text-sm text-ink/60"><option>All statuses</option><option>Active</option><option>Suspended</option></select>
    </div>
    <button onclick="document.getElementById('addVendor').classList.remove('hidden')" class="px-4 py-2 rounded-lg bg-primary hover:bg-primarydk text-white text-sm font-semibold shadow-sm shadow-primary/30">+ Add Vendor</button>
  </div>

  <div class="card overflow-hidden">
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
        <th class="px-5 py-3 font-medium">Vendor</th><th class="px-5 py-3 font-medium">Contact</th><th class="px-5 py-3 font-medium">Country</th><th class="px-5 py-3 font-medium">Rating</th><th class="px-5 py-3 font-medium">Status</th><th class="px-5 py-3 font-medium text-right">Actions</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr class="hover:bg-bg/60">
          <td class="px-5 py-4"><div class="font-medium">Apex Tech Components</div><div class="font-mono text-xs text-ink/40">VEN-001</div></td>
          <td class="px-5 py-4 text-ink/70">Sanduni Wickrama<div class="text-xs text-ink/40">contact@apextech.lk</div></td>
          <td class="px-5 py-4 text-ink/70">Sri Lanka</td>
          <td class="px-5 py-4"><span class="font-mono text-sm font-semibold text-teal">4.50</span></td>
          <td class="px-5 py-4"><span class="tag tag-teal"><span class="tag-dot"></span>Active</span></td>
          <td class="px-5 py-4 text-right"><a href="vendor-performance.jsp" class="text-primary text-xs font-medium hover:underline">View performance</a></td>
        </tr>
        <tr class="hover:bg-bg/60">
          <td class="px-5 py-4"><div class="font-medium">Global Parts Ltd</div><div class="font-mono text-xs text-ink/40">VEN-002</div></td>
          <td class="px-5 py-4 text-ink/70">Rohan Silva<div class="text-xs text-ink/40">sales@globalparts.com</div></td>
          <td class="px-5 py-4 text-ink/70">United Kingdom</td>
          <td class="px-5 py-4"><span class="font-mono text-sm font-semibold text-teal">4.10</span></td>
          <td class="px-5 py-4"><span class="tag tag-teal"><span class="tag-dot"></span>Active</span></td>
          <td class="px-5 py-4 text-right"><a href="vendor-performance.jsp" class="text-primary text-xs font-medium hover:underline">View performance</a></td>
        </tr>
        <tr class="hover:bg-bg/60">
          <td class="px-5 py-4"><div class="font-medium">Pacific Freight Supplies</div><div class="font-mono text-xs text-ink/40">VEN-003</div></td>
          <td class="px-5 py-4 text-ink/70">Wei Chen<div class="text-xs text-ink/40">info@pacificfreight.cn</div></td>
          <td class="px-5 py-4 text-ink/70">China</td>
          <td class="px-5 py-4"><span class="font-mono text-sm font-semibold text-amber">3.80</span></td>
          <td class="px-5 py-4"><span class="tag tag-teal"><span class="tag-dot"></span>Active</span></td>
          <td class="px-5 py-4 text-right"><a href="vendor-performance.jsp" class="text-primary text-xs font-medium hover:underline">View performance</a></td>
        </tr>
      </tbody>
    </table>
  </div>

  <!-- Add vendor slide-over (hidden by default) -->
  <div id="addVendor" class="hidden fixed inset-0 bg-ink/30 flex justify-end z-50">
    <div class="w-full max-w-md bg-white h-full p-6 overflow-y-auto scrollnice">
      <div class="flex items-center justify-between mb-6">
        <h3 class="font-display font-semibold text-lg">Add Vendor</h3>
        <button onclick="document.getElementById('addVendor').classList.add('hidden')" class="text-ink/40 hover:text-ink">&#10005;</button>
      </div>
      <form class="space-y-4">
        <div><label class="block text-xs font-medium text-ink/60 mb-1.5">Vendor Code</label><input class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm font-mono" placeholder="VEN-004"></div>
        <div><label class="block text-xs font-medium text-ink/60 mb-1.5">Company Name</label><input class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm" placeholder="Company name"></div>
        <div><label class="block text-xs font-medium text-ink/60 mb-1.5">Contact Person</label><input class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm" placeholder="Full name"></div>
        <div class="grid grid-cols-2 gap-3">
          <div><label class="block text-xs font-medium text-ink/60 mb-1.5">Email</label><input class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm" placeholder="email@company.com"></div>
          <div><label class="block text-xs font-medium text-ink/60 mb-1.5">Phone</label><input class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm" placeholder="+94..."></div>
        </div>
        <div><label class="block text-xs font-medium text-ink/60 mb-1.5">Country</label><input class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm" placeholder="Country"></div>
        <button type="button" class="w-full py-2.5 rounded-lg bg-primary text-white text-sm font-semibold mt-2">Save Vendor</button>
      </form>
    </div>
  </div>

<%@ include file="includes/footer.jspf" %>
