<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "System Configuration";
  String pageSubtitle = "Manage statuses, categories & global settings";
  String activePage = "sysconfig";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<div class="mb-6 flex gap-1 border-b border-line p-1 bg-white/50 w-fit rounded-t-lg">
  <button onclick="scmTab('tab-statuses', this)" class="scm-tab-btn active px-4 py-2 text-sm font-semibold text-ink border-b-2 border-primary transition">Status Types</button>
  <button onclick="scmTab('tab-categories', this)" class="scm-tab-btn px-4 py-2 text-sm font-medium text-ink/50 hover:text-ink transition border-b-2 border-transparent">Categories</button>
</div>

<div id="tab-statuses" class="scm-tab-content space-y-4">
  <div class="flex justify-end mb-4">
    <button onclick="toggleModal('addStatusModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold shadow-sm hover:bg-primarydk transition">+ Add Status</button>
  </div>
  <div class="card">
    <table class="w-full text-sm">
      <thead>
        <tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
          <th class="px-5 py-2.5 font-medium w-16">ID</th>
          <th class="px-5 py-2.5 font-medium">Name</th>
          <th class="px-5 py-2.5 font-medium">Description</th>
          <th class="px-5 py-2.5 font-medium text-right w-24"></th>
        </tr>
      </thead>
      <tbody class="divide-y divide-line">
        <tr class="group hover:bg-bg/50 transition">
          <td class="px-5 py-3 text-xs font-mono text-ink/50">1</td>
          <td class="px-5 py-3 font-medium flex items-center gap-2"><span class="w-2 h-2 rounded-full bg-blue-500"></span> In Transit</td>
          <td class="px-5 py-3 text-xs text-ink/60">Active shipment en route</td>
          <td class="px-5 py-3 text-right opacity-0 group-hover:opacity-100 transition flex items-center justify-end gap-2">
            <button class="text-ink/40 hover:text-primary transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg></button>
            <button class="text-ink/40 hover:text-amber transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg></button>
          </td>
        </tr>
        <tr class="group hover:bg-bg/50 transition">
          <td class="px-5 py-3 text-xs font-mono text-ink/50">2</td>
          <td class="px-5 py-3 font-medium flex items-center gap-2"><span class="w-2 h-2 rounded-full bg-amber"></span> Delayed</td>
          <td class="px-5 py-3 text-xs text-ink/60">Shipment behind schedule</td>
          <td class="px-5 py-3 text-right opacity-0 group-hover:opacity-100 transition flex items-center justify-end gap-2">
            <button class="text-ink/40 hover:text-primary transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg></button>
            <button class="text-ink/40 hover:text-amber transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg></button>
          </td>
        </tr>
        <tr class="group hover:bg-bg/50 transition">
          <td class="px-5 py-3 text-xs font-mono text-ink/50">3</td>
          <td class="px-5 py-3 font-medium flex items-center gap-2"><span class="w-2 h-2 rounded-full bg-teal"></span> Delivered</td>
          <td class="px-5 py-3 text-xs text-ink/60">Successfully received</td>
          <td class="px-5 py-3 text-right opacity-0 group-hover:opacity-100 transition flex items-center justify-end gap-2">
            <button class="text-ink/40 hover:text-primary transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg></button>
            <button class="text-ink/40 hover:text-amber transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg></button>
          </td>
        </tr>
        <tr class="group hover:bg-bg/50 transition">
          <td class="px-5 py-3 text-xs font-mono text-ink/50">4</td>
          <td class="px-5 py-3 font-medium flex items-center gap-2"><span class="w-2 h-2 rounded-full bg-slate-400"></span> Cancelled</td>
          <td class="px-5 py-3 text-xs text-ink/60">Order or shipment cancelled</td>
          <td class="px-5 py-3 text-right opacity-0 group-hover:opacity-100 transition flex items-center justify-end gap-2">
            <button class="text-ink/40 hover:text-primary transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg></button>
            <button class="text-ink/40 hover:text-amber transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg></button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

<div id="tab-categories" class="scm-tab-content hidden space-y-4">
  <div class="flex justify-end mb-4">
    <button onclick="toggleModal('addCategoryModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold shadow-sm hover:bg-primarydk transition">+ Add Category</button>
  </div>
  <div class="card">
    <table class="w-full text-sm">
      <thead>
        <tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
          <th class="px-5 py-2.5 font-medium w-16">ID</th>
          <th class="px-5 py-2.5 font-medium">Name</th>
          <th class="px-5 py-2.5 font-medium text-right">Product Count</th>
          <th class="px-5 py-2.5 font-medium text-right w-24"></th>
        </tr>
      </thead>
      <tbody class="divide-y divide-line">
        <tr class="group hover:bg-bg/50 transition">
          <td class="px-5 py-3 text-xs font-mono text-ink/50">1</td>
          <td class="px-5 py-3 font-medium">Electronics</td>
          <td class="px-5 py-3 text-right font-mono">1</td>
          <td class="px-5 py-3 text-right opacity-0 group-hover:opacity-100 transition flex items-center justify-end gap-2">
            <button class="text-ink/40 hover:text-primary transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg></button>
            <button class="text-ink/40 hover:text-amber transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg></button>
          </td>
        </tr>
        <tr class="group hover:bg-bg/50 transition">
          <td class="px-5 py-3 text-xs font-mono text-ink/50">2</td>
          <td class="px-5 py-3 font-medium">Hardware</td>
          <td class="px-5 py-3 text-right font-mono">1</td>
          <td class="px-5 py-3 text-right opacity-0 group-hover:opacity-100 transition flex items-center justify-end gap-2">
            <button class="text-ink/40 hover:text-primary transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg></button>
            <button class="text-ink/40 hover:text-amber transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg></button>
          </td>
        </tr>
        <tr class="group hover:bg-bg/50 transition">
          <td class="px-5 py-3 text-xs font-mono text-ink/50">3</td>
          <td class="px-5 py-3 font-medium">Packaging Materials</td>
          <td class="px-5 py-3 text-right font-mono">1</td>
          <td class="px-5 py-3 text-right opacity-0 group-hover:opacity-100 transition flex items-center justify-end gap-2">
            <button class="text-ink/40 hover:text-primary transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg></button>
            <button class="text-ink/40 hover:text-amber transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg></button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

<script>
function scmTab(targetId, btn) {
  document.querySelectorAll('.scm-tab-content').forEach(el => el.classList.add('hidden'));
  document.getElementById(targetId).classList.remove('hidden');
  
  document.querySelectorAll('.scm-tab-btn').forEach(el => {
    el.classList.remove('active', 'font-semibold', 'border-primary');
    el.classList.add('font-medium', 'text-ink/50', 'border-transparent');
  });
  
  btn.classList.add('active', 'font-semibold', 'border-primary', 'text-ink');
  btn.classList.remove('font-medium', 'text-ink/50', 'border-transparent');
}

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
</script>

<!-- Add Status Modal -->
<div id="addStatusModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-sm">
  <div class="bg-white rounded-xl shadow-xl border border-line w-full max-w-sm p-6">
    <div class="flex items-center justify-between mb-4">
      <h3 class="font-display font-semibold text-lg">Add Status Type</h3>
      <button onclick="toggleModal('addStatusModal')" class="text-ink/50 hover:text-ink">&times;</button>
    </div>
    <form class="space-y-4">
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Name</label>
        <input type="text" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary" placeholder="e.g. Returned">
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Description</label>
        <textarea class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary" rows="2" placeholder="Explanation of this status"></textarea>
      </div>
      <div class="mt-6 flex justify-end gap-3 pt-4 border-t border-line">
        <button type="button" onclick="toggleModal('addStatusModal')" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg">Cancel</button>
        <button type="button" onclick="toggleModal('addStatusModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-medium hover:bg-primarydk transition">Save Status</button>
      </div>
    </form>
  </div>
</div>

<!-- Add Category Modal -->
<div id="addCategoryModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-sm">
  <div class="bg-white rounded-xl shadow-xl border border-line w-full max-w-sm p-6">
    <div class="flex items-center justify-between mb-4">
      <h3 class="font-display font-semibold text-lg">Add Category</h3>
      <button onclick="toggleModal('addCategoryModal')" class="text-ink/50 hover:text-ink">&times;</button>
    </div>
    <form class="space-y-4">
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Name</label>
        <input type="text" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary" placeholder="e.g. Raw Materials">
      </div>
      <div class="mt-6 flex justify-end gap-3 pt-4 border-t border-line">
        <button type="button" onclick="toggleModal('addCategoryModal')" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg">Cancel</button>
        <button type="button" onclick="toggleModal('addCategoryModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-medium hover:bg-primarydk transition">Save Category</button>
      </div>
    </form>
  </div>
</div>

<%@ include file="includes/footer.jspf" %>
