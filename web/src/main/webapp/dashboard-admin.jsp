<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Admin Dashboard";
  String pageSubtitle = "System administration \u00b7 User & access control overview";
  String activePage = "dashboard";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <!-- KPI row -->
  <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4 mb-8">
    <div class="card p-5">
      <div class="flex items-center justify-between mb-2"><span class="text-xs text-ink/50 font-medium">Total Users</span><span class="tag tag-blue"><span class="tag-dot"></span>Active</span></div>
      <div class="font-display text-3xl font-semibold">5</div>
      <div class="text-xs text-ink/40 mt-1">2 Admins &middot; 1 WH Mgr &middot; 1 Vendor &middot; 1 Customer</div>
    </div>
    <div class="card p-5">
      <div class="flex items-center justify-between mb-2"><span class="text-xs text-ink/50 font-medium">Audit Events Today</span></div>
      <div class="font-display text-3xl font-semibold">12</div>
      <div class="text-xs text-ink/40 mt-1">3 stock updates &middot; 2 order changes</div>
    </div>
    <div class="card p-5">
      <div class="flex items-center justify-between mb-2"><span class="text-xs text-ink/50 font-medium">Status Types</span></div>
      <div class="font-display text-3xl font-semibold">4</div>
      <div class="text-xs text-ink/40 mt-1">In Transit, Delayed, Delivered, Cancelled</div>
    </div>
    <div class="card p-5">
      <div class="flex items-center justify-between mb-2"><span class="text-xs text-ink/50 font-medium">Timer Jobs</span><span class="tag tag-teal"><span class="tag-dot"></span>Running</span></div>
      <div class="font-display text-3xl font-semibold">3<span class="text-base text-ink/30 font-body">/3</span></div>
      <div class="text-xs text-ink/40 mt-1">All schedules healthy</div>
    </div>
  </div>

  <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
    <!-- User Management Summary -->
    <div class="xl:col-span-2 card">
      <div class="flex items-center justify-between px-5 py-4 border-b border-line">
        <h3 class="font-display font-semibold text-sm">Registered Users</h3>
        <a href="users.jsp" class="text-xs text-primary font-medium hover:underline">Manage users &rarr;</a>
      </div>
      <table class="w-full text-sm">
        <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
          <th class="px-5 py-2.5 font-medium">User</th><th class="px-5 py-2.5 font-medium">Role</th><th class="px-5 py-2.5 font-medium">Status</th><th class="px-5 py-2.5 font-medium">Last Activity</th>
        </tr></thead>
        <tbody class="divide-y divide-line">
          <tr class="hover:bg-bg/60 transition">
            <td class="px-5 py-3">
              <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-display text-xs font-semibold">N</div>
                <div><div class="font-medium">Nadeesha Perera</div><div class="text-xs text-ink/40 font-mono">admin01</div></div>
              </div>
            </td>
            <td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>Admin</span></td>
            <td class="px-5 py-3"><span class="w-2 h-2 rounded-full bg-teal inline-block mr-1"></span><span class="text-xs">Active</span></td>
            <td class="px-5 py-3 font-mono text-xs text-ink/50">Just now</td>
          </tr>
          <tr class="hover:bg-bg/60 transition">
            <td class="px-5 py-3">
              <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-teal/10 text-teal flex items-center justify-center font-display text-xs font-semibold">S</div>
                <div><div class="font-medium">Saman Kumara</div><div class="text-xs text-ink/40 font-mono">whmgr01</div></div>
              </div>
            </td>
            <td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>WH Manager</span></td>
            <td class="px-5 py-3"><span class="w-2 h-2 rounded-full bg-teal inline-block mr-1"></span><span class="text-xs">Active</span></td>
            <td class="px-5 py-3 font-mono text-xs text-ink/50">2 hrs ago</td>
          </tr>
          <tr class="hover:bg-bg/60 transition">
            <td class="px-5 py-3">
              <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-amber/10 text-amber flex items-center justify-center font-display text-xs font-semibold">S</div>
                <div><div class="font-medium">Sanduni Wickrama</div><div class="text-xs text-ink/40 font-mono">vendor01</div></div>
              </div>
            </td>
            <td class="px-5 py-3"><span class="tag tag-amber"><span class="tag-dot"></span>Vendor</span></td>
            <td class="px-5 py-3"><span class="w-2 h-2 rounded-full bg-teal inline-block mr-1"></span><span class="text-xs">Active</span></td>
            <td class="px-5 py-3 font-mono text-xs text-ink/50">5 hrs ago</td>
          </tr>
          <tr class="hover:bg-bg/60 transition">
            <td class="px-5 py-3">
              <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-display text-xs font-semibold">C</div>
                <div><div class="font-medium">Colombo Retail Hub</div><div class="text-xs text-ink/40 font-mono">cust01</div></div>
              </div>
            </td>
            <td class="px-5 py-3"><span class="tag tag-slate"><span class="tag-dot"></span>Customer</span></td>
            <td class="px-5 py-3"><span class="w-2 h-2 rounded-full bg-teal inline-block mr-1"></span><span class="text-xs">Active</span></td>
            <td class="px-5 py-3 font-mono text-xs text-ink/50">1 day ago</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Right column -->
    <div class="space-y-6">
      <!-- Audit Log Feed -->
      <div class="card">
        <div class="flex items-center justify-between px-5 py-4 border-b border-line">
          <h3 class="font-display font-semibold text-sm">Recent Audit Trail</h3>
          <a href="monitoring.jsp" class="text-xs text-primary font-medium hover:underline">Full log &rarr;</a>
        </div>
        <div class="divide-y divide-line">
          <div class="px-5 py-3.5">
            <div class="flex items-center justify-between mb-1"><span class="text-xs font-semibold text-ink">Stock Updated</span><span class="text-[10px] text-ink/30 font-mono">14:32</span></div>
            <div class="text-xs text-ink/50">whmgr01 updated SKU-1001 qty: 400 &rarr; 420</div>
          </div>
          <div class="px-5 py-3.5">
            <div class="flex items-center justify-between mb-1"><span class="text-xs font-semibold text-ink">Order Created</span><span class="text-[10px] text-ink/30 font-mono">13:15</span></div>
            <div class="text-xs text-ink/50">cust01 placed order ORD-20260815-001</div>
          </div>
          <div class="px-5 py-3.5">
            <div class="flex items-center justify-between mb-1"><span class="text-xs font-semibold text-ink">PO Accepted</span><span class="text-[10px] text-ink/30 font-mono">11:45</span></div>
            <div class="text-xs text-ink/50">vendor01 accepted PO-2026-0038</div>
          </div>
          <div class="px-5 py-3.5">
            <div class="flex items-center justify-between mb-1"><span class="text-xs font-semibold text-ink">User Created</span><span class="text-[10px] text-ink/30 font-mono">09:00</span></div>
            <div class="text-xs text-ink/50">admin01 added user vendor01</div>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="card p-5">
        <h3 class="font-display font-semibold text-sm mb-4">Quick Actions</h3>
        <div class="space-y-2">
          <a href="users.jsp" class="flex items-center gap-3 p-3 rounded-lg bg-bg/60 hover:bg-bg transition group">
            <div class="w-8 h-8 rounded-lg bg-primary/10 text-primary flex items-center justify-center group-hover:bg-primary group-hover:text-white transition">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/></svg>
            </div>
            <div><div class="text-xs font-semibold">Add New User</div><div class="text-[10px] text-ink/40">Create WH Manager or Vendor</div></div>
          </a>
          <a href="system-config.jsp" class="flex items-center gap-3 p-3 rounded-lg bg-bg/60 hover:bg-bg transition group">
            <div class="w-8 h-8 rounded-lg bg-teal/10 text-teal flex items-center justify-center group-hover:bg-teal group-hover:text-white transition">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"/></svg>
            </div>
            <div><div class="text-xs font-semibold">System Config</div><div class="text-[10px] text-ink/40">Statuses & categories</div></div>
          </a>
          <a href="monitoring.jsp" class="flex items-center gap-3 p-3 rounded-lg bg-bg/60 hover:bg-bg transition group">
            <div class="w-8 h-8 rounded-lg bg-amber/10 text-amber flex items-center justify-center group-hover:bg-amber group-hover:text-white transition">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
            </div>
            <div><div class="text-xs font-semibold">View Audit Logs</div><div class="text-[10px] text-ink/40">Monitor all activities</div></div>
          </a>
        </div>
      </div>
    </div>
  </div>

<%@ include file="includes/footer.jspf" %>
