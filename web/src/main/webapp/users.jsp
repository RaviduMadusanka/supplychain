<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "User Management";
  String pageSubtitle = "Manage system access and roles";
  String activePage = "users";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <!-- Top Actions -->
  <div class="flex items-center justify-between mb-6">
    <div class="relative w-64">
      <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
        <svg class="w-4 h-4 text-ink/40" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
      </div>
      <input type="text" placeholder="Search users..." class="w-full pl-10 pr-4 py-2 text-sm bg-white border border-line rounded-lg focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary">
    </div>
    <button class="px-4 py-2 bg-primary text-white text-sm font-medium rounded-lg hover:bg-primarydk transition shadow-sm shadow-primary/30 flex items-center gap-2">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
      Add New User
    </button>
  </div>

  <!-- Users Table -->
  <div class="card overflow-hidden">
    <table class="w-full text-sm">
      <thead>
        <tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/30">
          <th class="px-5 py-3 font-medium">User</th>
          <th class="px-5 py-3 font-medium">Role</th>
          <th class="px-5 py-3 font-medium">Email</th>
          <th class="px-5 py-3 font-medium">Status</th>
          <th class="px-5 py-3 font-medium text-right">Actions</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-line">
        
        <tr class="hover:bg-bg/60 transition">
          <td class="px-5 py-3.5">
            <div class="flex items-center gap-3">
              <div class="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-display font-bold text-xs">NP</div>
              <div>
                <div class="font-medium">Nadeesha Perera</div>
                <div class="text-xs text-ink/40 font-mono mt-0.5">admin01</div>
              </div>
            </div>
          </td>
          <td class="px-5 py-3.5 text-ink/70">Administrator</td>
          <td class="px-5 py-3.5 text-ink/70">nadeesha@nextrade.com</td>
          <td class="px-5 py-3.5"><span class="tag tag-teal"><span class="tag-dot"></span>Active</span></td>
          <td class="px-5 py-3.5 text-right">
            <button class="text-primary hover:text-primarydk text-xs font-medium mr-3">Edit</button>
            <button class="text-amber hover:text-amber/80 text-xs font-medium">Suspend</button>
          </td>
        </tr>

        <tr class="hover:bg-bg/60 transition">
          <td class="px-5 py-3.5">
            <div class="flex items-center gap-3">
              <div class="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-display font-bold text-xs">SM</div>
              <div>
                <div class="font-medium">Saman Kumara</div>
                <div class="text-xs text-ink/40 font-mono mt-0.5">coord_lk</div>
              </div>
            </div>
          </td>
          <td class="px-5 py-3.5 text-ink/70">Logistics Coordinator</td>
          <td class="px-5 py-3.5 text-ink/70">saman.k@nextrade.com</td>
          <td class="px-5 py-3.5"><span class="tag tag-teal"><span class="tag-dot"></span>Active</span></td>
          <td class="px-5 py-3.5 text-right">
            <button class="text-primary hover:text-primarydk text-xs font-medium mr-3">Edit</button>
            <button class="text-amber hover:text-amber/80 text-xs font-medium">Suspend</button>
          </td>
        </tr>

        <tr class="hover:bg-bg/60 transition">
          <td class="px-5 py-3.5">
            <div class="flex items-center gap-3">
              <div class="w-8 h-8 rounded-full bg-slate-200 text-slate-500 flex items-center justify-center font-display font-bold text-xs">FJ</div>
              <div>
                <div class="font-medium text-ink/60">Faizal Jameel</div>
                <div class="text-xs text-ink/30 font-mono mt-0.5">wh_dubai</div>
              </div>
            </div>
          </td>
          <td class="px-5 py-3.5 text-ink/50">Warehouse Manager</td>
          <td class="px-5 py-3.5 text-ink/50">f.jameel@nextrade.ae</td>
          <td class="px-5 py-3.5"><span class="tag tag-slate"><span class="tag-dot"></span>Suspended</span></td>
          <td class="px-5 py-3.5 text-right">
            <button class="text-primary hover:text-primarydk text-xs font-medium mr-3">Edit</button>
            <button class="text-teal hover:text-teal/80 text-xs font-medium">Activate</button>
          </td>
        </tr>

      </tbody>
    </table>
  </div>

<%@ include file="includes/footer.jspf" %>
