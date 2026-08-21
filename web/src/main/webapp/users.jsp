<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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
    <button onclick="filterUsers('ADMIN', this)" class="user-filter-btn px-3 py-1.5 text-xs font-medium rounded-md text-ink/60 hover:bg-bg transition">Admins</button>
    <button onclick="filterUsers('WAREHOUSE_MANAGER', this)" class="user-filter-btn px-3 py-1.5 text-xs font-medium rounded-md text-ink/60 hover:bg-bg transition">WH Managers</button>
    <button onclick="filterUsers('VENDOR', this)" class="user-filter-btn px-3 py-1.5 text-xs font-medium rounded-md text-ink/60 hover:bg-bg transition">Vendors</button>
  </div>
  <button onclick="toggleModal('addUserModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-xs font-bold shadow-sm hover:bg-primarydk transition flex items-center gap-1.5">
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"/></svg>
    Add Warehouse Manager
  </button>
</div>

<!-- Alerts -->
<c:if test="${not empty param.success}">
  <div class="mb-5 p-4 rounded-xl bg-teal/10 border border-teal/30 text-teal flex items-center justify-between text-sm font-medium">
    <div class="flex items-center gap-2">
      <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
      <span>${param.success}</span>
    </div>
    <button onclick="this.parentElement.remove()" class="text-teal/60 hover:text-teal">&times;</button>
  </div>
</c:if>
<c:if test="${not empty param.error}">
  <div class="mb-5 p-4 rounded-xl bg-amber/10 border border-amber/30 text-amber flex items-center justify-between text-sm font-medium">
    <div class="flex items-center gap-2">
      <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
      <span>${param.error}</span>
    </div>
    <button onclick="this.parentElement.remove()" class="text-amber/60 hover:text-amber">&times;</button>
  </div>
</c:if>

<div class="card overflow-hidden">
  <table class="w-full text-sm">
    <thead>
      <tr class="text-left text-white text-xs font-mono uppercase tracking-wider bg-gradient-to-r from-[#12172B] via-[#1B254B] to-[#1E2538] border-b border-slate-700">
        <th class="px-5 py-3.5 font-semibold text-white">User</th>
        <th class="px-5 py-3.5 font-semibold text-slate-200">Username</th>
        <th class="px-5 py-3.5 font-semibold text-slate-200">Email Address</th>
        <th class="px-5 py-3.5 font-semibold text-slate-200">Role</th>
        <th class="px-5 py-3.5 font-semibold text-slate-200">Status</th>
        <th class="px-5 py-3.5 font-semibold text-right w-28 text-slate-300">Actions</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-line">
      <c:choose>
        <c:when test="${not empty users}">
          <c:forEach var="u" items="${users}">
            <tr class="group hover:bg-bg/50 transition user-row" data-role="${u.role}">
              <td class="px-5 py-3">
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-display text-xs font-semibold flex-shrink-0 uppercase">${u.fullName.substring(0,1)}</div>
                  <span class="font-medium text-ink">${u.fullName}</span>
                </div>
              </td>
              <td class="px-5 py-3 font-mono text-xs text-primary font-semibold">${u.username}</td>
              <td class="px-5 py-3 text-xs text-ink/60">${u.email}</td>
              <td class="px-5 py-3">
                <c:choose>
                  <c:when test="${u.role == 'ADMIN'}"><span class="tag tag-blue"><span class="tag-dot"></span>Admin</span></c:when>
                  <c:when test="${u.role == 'WAREHOUSE_MANAGER'}"><span class="tag tag-slate"><span class="tag-dot"></span>WH Manager</span></c:when>
                  <c:when test="${u.role == 'VENDOR'}"><span class="tag tag-amber"><span class="tag-dot"></span>Vendor</span></c:when>
                  <c:otherwise><span class="tag tag-slate"><span class="tag-dot"></span>${u.role}</span></c:otherwise>
                </c:choose>
              </td>
              <td class="px-5 py-3">
                <span class="inline-flex items-center gap-1.5">
                  <span class="w-1.5 h-1.5 rounded-full ${u.status == 'ACTIVE' ? 'bg-teal' : 'bg-amber'}"></span>
                  <span class="text-xs ${u.status == 'ACTIVE' ? 'text-teal' : 'text-amber'} font-semibold">${u.status}</span>
                </span>
              </td>
              <td class="px-5 py-3 text-right">
                <div class="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition">
                  <button class="text-ink/40 hover:text-primary transition" title="Edit"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg></button>
                  <button class="text-ink/40 hover:text-amber transition" title="Suspend"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636"/></svg></button>
                </div>
              </td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr><td colspan="6" class="p-10 text-center text-ink/50 text-sm">No users found. Add your first user to get started.</td></tr>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>

<!-- Add User Modal -->
<div id="addUserModal" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-ink/50 backdrop-blur-sm p-4">
  <div class="w-full max-w-md bg-white rounded-2xl border border-line shadow-2xl overflow-hidden">
    <div class="h-16 px-6 border-b border-line flex items-center justify-between bg-bg">
      <div class="font-display font-semibold text-sm text-ink">Register New Warehouse Manager</div>
      <button onclick="toggleModal('addUserModal')" class="text-ink/40 hover:text-ink transition"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg></button>
    </div>
    
    <form action="${pageContext.request.contextPath}/users/action" method="POST" class="p-6 space-y-4">
      <div>
        <label class="block text-xs font-semibold text-ink/70 uppercase font-mono mb-1.5">Full Name <span class="text-amber">*</span></label>
        <input type="text" name="fullName" required placeholder="e.g. Kasun Silva" class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/20" />
      </div>
      <div>
        <label class="block text-xs font-semibold text-ink/70 uppercase font-mono mb-1.5">Email Address <span class="text-amber">*</span></label>
        <input type="email" name="email" required placeholder="kasun@example.com" class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/20" />
      </div>
      <div>
        <label class="block text-xs font-semibold text-ink/70 uppercase font-mono mb-1.5">Assigned System Role</label>
        <div class="px-3.5 py-2.5 rounded-lg border border-line bg-slate-50 flex items-center justify-between">
          <span class="text-sm font-semibold text-ink flex items-center gap-2">
            <span class="w-2 h-2 rounded-full bg-teal"></span>
            Warehouse Manager (Operations)
          </span>
          <span class="tag tag-teal text-[9px]">Authorized</span>
        </div>
        <input type="hidden" name="roleName" value="WAREHOUSE_MANAGER" />
      </div>
      
      <div class="p-3.5 rounded-xl bg-primary/5 border border-primary/20 text-xs text-primary/80 leading-relaxed mt-2">
        <strong class="text-primary font-semibold">Automated Provisioning:</strong> 
        A secure random password and username will be automatically generated and dispatched directly to the Warehouse Manager's email address.
      </div>
      
      <div class="pt-4 border-t border-line flex items-center justify-end gap-3">
        <button type="button" onclick="toggleModal('addUserModal')" class="px-4 py-2.5 rounded-lg border border-line text-xs font-semibold text-ink/70 hover:bg-bg transition">Cancel</button>
        <button type="submit" class="px-5 py-2.5 rounded-lg bg-primary text-white text-xs font-semibold hover:bg-primarydk shadow-sm transition">Provision Manager</button>
      </div>
    </form>
  </div>
</div>

<script>
  function toggleModal(id) {
    const el = document.getElementById(id);
    if (el) el.classList.toggle('hidden');
  }

  function filterUsers(role, btn) {
    // Update active button state
    document.querySelectorAll('.user-filter-btn').forEach(b => {
      b.classList.remove('active', 'bg-primary', 'text-white');
      b.classList.add('text-ink/60', 'hover:bg-bg');
    });
    btn.classList.add('active', 'bg-primary', 'text-white');
    btn.classList.remove('text-ink/60', 'hover:bg-bg');
    
    // Filter rows
    const rows = document.querySelectorAll('.user-row');
    rows.forEach(row => {
      if (role === 'all' || row.dataset.role === role) {
        row.style.display = '';
      } else {
        row.style.display = 'none';
      }
    });
  }
</script>

<%@ include file="includes/footer.jspf" %>