<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "User Management";
  String pageSubtitle = "Manage system users & access control";
  String activePage = "users";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<div class="flex items-center justify-between mb-6">
  <div class="flex gap-1 border border-line rounded-lg p-1 bg-white">
    <button onclick="filterUsers('all', this)" class="user-filter-btn active px-3 py-1.5 text-xs font-semibold rounded-md bg-primary text-white transition">All Users</button>
    <button onclick="filterUsers('admin', this)" class="user-filter-btn px-3 py-1.5 text-xs font-medium rounded-md text-ink/60 hover:bg-bg transition">Admins</button>
    <button onclick="filterUsers('whmanager', this)" class="user-filter-btn px-3 py-1.5 text-xs font-medium rounded-md text-ink/60 hover:bg-bg transition">WH Managers</button>
    <button onclick="filterUsers('vendor', this)" class="user-filter-btn px-3 py-1.5 text-xs font-medium rounded-md text-ink/60 hover:bg-bg transition">Vendors</button>
    <button onclick="filterUsers('customer', this)" class="user-filter-btn px-3 py-1.5 text-xs font-medium rounded-md text-ink/60 hover:bg-bg transition">Customers</button>
  </div>
  <button onclick="toggleModal('addUserModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold shadow-sm hover:bg-primarydk transition">+ Add User</button>
</div>

<div class="card">
  <table class="w-full text-sm">
    <thead>
      <tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
        <th class="px-5 py-2.5 font-medium">User</th>
        <th class="px-5 py-2.5 font-medium">Username</th>
        <th class="px-5 py-2.5 font-medium">Email</th>
        <th class="px-5 py-2.5 font-medium">Role</th>
        <th class="px-5 py-2.5 font-medium">Status</th>
        <th class="px-5 py-2.5 font-medium">Created</th>
        <th class="px-5 py-2.5 font-medium text-right w-28">Actions</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-line">
      <tr class="group hover:bg-bg/50 transition" data-role="admin">
        <td class="px-5 py-3">
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-display text-xs font-semibold flex-shrink-0">N</div>
            <span class="font-medium">Nadeesha Perera</span>
          </div>
        </td>
        <td class="px-5 py-3 font-mono text-xs text-ink/60">admin01</td>
        <td class="px-5 py-3 text-xs text-ink/60">admin@globaltrade.com</td>
        <td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>Admin</span></td>
        <td class="px-5 py-3"><span class="inline-flex items-center gap-1.5"><span class="w-1.5 h-1.5 rounded-full bg-teal"></span><span class="text-xs">Active</span></span></td>
        <td class="px-5 py-3 font-mono text-xs text-ink/50">01 Jan 2026</td>
        <td class="px-5 py-3 text-right">
          <div class="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
            <button class="px-2.5 py-1 rounded border border-line text-[11px] font-semibold hover:bg-bg transition text-ink">Edit</button>
          </div>
        </td>
      </tr>
      <tr class="group hover:bg-bg/50 transition" data-role="admin">
        <td class="px-5 py-3">
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-display text-xs font-semibold flex-shrink-0">K</div>
            <span class="font-medium">Kasun Fernando</span>
          </div>
        </td>
        <td class="px-5 py-3 font-mono text-xs text-ink/60">coord01</td>
        <td class="px-5 py-3 text-xs text-ink/60">coordinator@globaltrade.com</td>
        <td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>Admin</span></td>
        <td class="px-5 py-3"><span class="inline-flex items-center gap-1.5"><span class="w-1.5 h-1.5 rounded-full bg-teal"></span><span class="text-xs">Active</span></span></td>
        <td class="px-5 py-3 font-mono text-xs text-ink/50">15 Mar 2026</td>
        <td class="px-5 py-3 text-right">
          <div class="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
            <button class="px-2.5 py-1 rounded border border-line text-[11px] font-semibold hover:bg-bg transition text-ink">Edit</button>
          </div>
        </td>
      </tr>
      <tr class="group hover:bg-bg/50 transition" data-role="whmanager">
        <td class="px-5 py-3">
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-full bg-teal/10 text-teal flex items-center justify-center font-display text-xs font-semibold flex-shrink-0">W</div>
            <span class="font-medium">Warehouse Manager</span>
          </div>
        </td>
        <td class="px-5 py-3 font-mono text-xs text-ink/60">whmgr01</td>
        <td class="px-5 py-3 text-xs text-ink/60">whmgr@nextrade.com</td>
        <td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>WH Manager</span></td>
        <td class="px-5 py-3"><span class="inline-flex items-center gap-1.5"><span class="w-1.5 h-1.5 rounded-full bg-teal"></span><span class="text-xs">Active</span></span></td>
        <td class="px-5 py-3 font-mono text-xs text-ink/50">10 Jun 2026</td>
        <td class="px-5 py-3 text-right">
          <div class="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
            <button class="px-2.5 py-1 rounded border border-line text-[11px] font-semibold hover:bg-bg transition text-ink">Edit</button>
            <button class="px-2.5 py-1 rounded border border-amber/30 text-[11px] font-semibold hover:bg-ambersoft transition text-amber">Disable</button>
          </div>
        </td>
      </tr>
      <tr class="group hover:bg-bg/50 transition" data-role="vendor">
        <td class="px-5 py-3">
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-full bg-amber/10 text-amber flex items-center justify-center font-display text-xs font-semibold flex-shrink-0">S</div>
            <span class="font-medium">Sanduni Wickrama</span>
          </div>
        </td>
        <td class="px-5 py-3 font-mono text-xs text-ink/60">vendor01</td>
        <td class="px-5 py-3 text-xs text-ink/60">contact@apextech.lk</td>
        <td class="px-5 py-3"><span class="tag tag-amber"><span class="tag-dot"></span>Vendor</span></td>
        <td class="px-5 py-3"><span class="inline-flex items-center gap-1.5"><span class="w-1.5 h-1.5 rounded-full bg-teal"></span><span class="text-xs">Active</span></span></td>
        <td class="px-5 py-3 font-mono text-xs text-ink/50">20 Jul 2026</td>
        <td class="px-5 py-3 text-right">
          <div class="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
            <button class="px-2.5 py-1 rounded border border-line text-[11px] font-semibold hover:bg-bg transition text-ink">Edit</button>
            <button class="px-2.5 py-1 rounded border border-amber/30 text-[11px] font-semibold hover:bg-ambersoft transition text-amber">Disable</button>
          </div>
        </td>
      </tr>
      <tr class="group hover:bg-bg/50 transition" data-role="customer">
        <td class="px-5 py-3">
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-display text-xs font-semibold flex-shrink-0">C</div>
            <span class="font-medium">Colombo Retail Hub</span>
          </div>
        </td>
        <td class="px-5 py-3 font-mono text-xs text-ink/60">cust01</td>
        <td class="px-5 py-3 text-xs text-ink/60">customer@nextrade.com</td>
        <td class="px-5 py-3"><span class="tag tag-slate"><span class="tag-dot"></span>Customer</span></td>
        <td class="px-5 py-3"><span class="inline-flex items-center gap-1.5"><span class="w-1.5 h-1.5 rounded-full bg-teal"></span><span class="text-xs">Active</span></span></td>
        <td class="px-5 py-3 font-mono text-xs text-ink/50">01 Aug 2026</td>
        <td class="px-5 py-3 text-right">
          <div class="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
            <button class="px-2.5 py-1 rounded border border-line text-[11px] font-semibold hover:bg-bg transition text-ink">Edit</button>
            <button class="px-2.5 py-1 rounded border border-amber/30 text-[11px] font-semibold hover:bg-ambersoft transition text-amber">Disable</button>
          </div>
        </td>
      </tr>
    </tbody>
  </table>
</div>

<script>
function toggleModal(id) {
  const modal = document.getElementById(id);
  if (modal.classList.contains('hidden')) {
    modal.classList.remove('hidden');
    modal.classList.add('flex');
  } else {
    modal.classList.add('hidden');
    modal.classList.remove('flex');
  }
}

function filterUsers(role, btn) {
  document.querySelectorAll('.user-filter-btn').forEach(b => {
    b.classList.remove('active', 'bg-primary', 'text-white');
    b.classList.add('text-ink/60');
  });
  btn.classList.add('active', 'bg-primary', 'text-white');
  btn.classList.remove('text-ink/60');

  document.querySelectorAll('tbody tr[data-role]').forEach(row => {
    if (role === 'all' || row.dataset.role === role) {
      row.style.display = '';
    } else {
      row.style.display = 'none';
    }
  });
}
</script>

<!-- Add User Modal -->
<div id="addUserModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-sm">
  <div class="bg-white rounded-xl shadow-xl border border-line w-full max-w-md p-6">
    <div class="flex items-center justify-between mb-5">
      <h3 class="font-display font-semibold text-lg">Add New User</h3>
      <button onclick="toggleModal('addUserModal')" class="text-ink/50 hover:text-ink text-xl">&times;</button>
    </div>
    <form class="space-y-4">
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1">Full Name</label>
          <input type="text" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary" placeholder="e.g. Ruwan Silva">
        </div>
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1">Username</label>
          <input type="text" class="w-full px-3 py-2 border border-line rounded-lg text-sm font-mono focus:outline-none focus:border-primary" placeholder="e.g. ruwan01">
        </div>
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Email</label>
        <input type="email" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary" placeholder="user@company.com">
      </div>
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1">Password</label>
          <input type="password" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;">
        </div>
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1">Role</label>
          <select class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary bg-white">
            <option>Warehouse Manager</option>
            <option>Vendor</option>
            <option>Customer</option>
            <option>Admin</option>
          </select>
        </div>
      </div>
      <div class="mt-6 flex justify-end gap-3 pt-4 border-t border-line">
        <button type="button" onclick="toggleModal('addUserModal')" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg">Cancel</button>
        <button type="button" onclick="toggleModal('addUserModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-medium hover:bg-primarydk transition">Create User</button>
      </div>
    </form>
  </div>
</div>

<%@ include file="includes/footer.jspf" %>
