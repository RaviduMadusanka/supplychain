<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "System Settings";
  String pageSubtitle = "Manage status types and product categories";
  String activePage = "settings";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="flex items-center gap-1 mb-5 border-b border-line">
    <button onclick="cfgTab(event,'cfg-status')" class="cfgtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-primary text-primary">Status Types</button>
    <button onclick="cfgTab(event,'cfg-categories')" class="cfgtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-transparent text-ink/50">Product Categories</button>
  </div>

  <!-- Status Types -->
  <div id="cfg-status">
    <div class="flex justify-end mb-4">
      <button onclick="toggleModal('addStatusModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition">+ Add Status Type</button>
    </div>
    <div class="card overflow-hidden">
      <table class="w-full text-sm">
        <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
          <th class="px-5 py-3 font-medium">Name</th><th class="px-5 py-3 font-medium">Description</th><th class="px-5 py-3 font-medium">Used In</th><th class="px-5 py-3 font-medium text-right">Actions</th>
        </tr></thead>
        <tbody class="divide-y divide-line">
          <tr class="hover:bg-bg/60"><td class="px-5 py-3 font-mono text-xs">IN_STOCK</td><td class="px-5 py-3 text-ink/70">Sufficient stock available</td><td class="px-5 py-3 text-ink/50">inventory_stock</td><td class="px-5 py-3 text-right"><button class="text-primary text-xs font-medium hover:underline mr-3">Edit</button><button class="text-amber text-xs font-medium hover:underline">Delete</button></td></tr>
          <tr class="hover:bg-bg/60"><td class="px-5 py-3 font-mono text-xs">LOW_STOCK</td><td class="px-5 py-3 text-ink/70">Stock below reorder level</td><td class="px-5 py-3 text-ink/50">inventory_stock</td><td class="px-5 py-3 text-right"><button class="text-primary text-xs font-medium hover:underline mr-3">Edit</button><button class="text-amber text-xs font-medium hover:underline">Delete</button></td></tr>
          <tr class="hover:bg-bg/60"><td class="px-5 py-3 font-mono text-xs">OUT_OF_STOCK</td><td class="px-5 py-3 text-ink/70">No stock currently available</td><td class="px-5 py-3 text-ink/50">inventory_stock</td><td class="px-5 py-3 text-right"><button class="text-primary text-xs font-medium hover:underline mr-3">Edit</button><button class="text-amber text-xs font-medium hover:underline">Delete</button></td></tr>
          <tr class="hover:bg-bg/60"><td class="px-5 py-3 font-mono text-xs">IN_TRANSIT</td><td class="px-5 py-3 text-ink/70">Shipment currently in transit</td><td class="px-5 py-3 text-ink/50">shipments</td><td class="px-5 py-3 text-right"><button class="text-primary text-xs font-medium hover:underline mr-3">Edit</button><button class="text-amber text-xs font-medium hover:underline">Delete</button></td></tr>
          <tr class="hover:bg-bg/60"><td class="px-5 py-3 font-mono text-xs">DELAYED</td><td class="px-5 py-3 text-ink/70">Shipment delayed past ETA</td><td class="px-5 py-3 text-ink/50">shipments</td><td class="px-5 py-3 text-right"><button class="text-primary text-xs font-medium hover:underline mr-3">Edit</button><button class="text-amber text-xs font-medium hover:underline">Delete</button></td></tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Product Categories -->
  <div id="cfg-categories" class="hidden">
    <div class="flex justify-end mb-4">
      <button onclick="toggleModal('addCategoryModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition">+ Add Category</button>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div class="card p-4 flex items-center justify-between">
        <div><div class="font-medium text-sm">Electronics</div><div class="text-xs text-ink/40 mt-0.5">1 product</div></div>
        <button class="text-ink/30 hover:text-amber"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg></button>
      </div>
      <div class="card p-4 flex items-center justify-between">
        <div><div class="font-medium text-sm">Hardware</div><div class="text-xs text-ink/40 mt-0.5">1 product</div></div>
        <button class="text-ink/30 hover:text-amber"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg></button>
      </div>
      <div class="card p-4 flex items-center justify-between">
        <div><div class="font-medium text-sm">Packaging Materials</div><div class="text-xs text-ink/40 mt-0.5">1 product</div></div>
        <button class="text-ink/30 hover:text-amber"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg></button>
      </div>
    </div>
  </div>

  <!-- Add Status Type Modal -->
  <div id="addStatusModal" class="hidden fixed inset-0 bg-ink/30 flex items-center justify-center z-50 p-4">
    <div class="w-full max-w-sm bg-white rounded-xl p-6">
      <div class="flex items-center justify-between mb-5">
        <h3 class="font-display font-semibold text-base">Add Status Type</h3>
        <button onclick="toggleModal('addStatusModal')" class="text-ink/40 hover:text-ink">&#10005;</button>
      </div>
      <form class="space-y-4">
        <div><label class="block text-xs font-medium text-ink/60 mb-1.5">Name</label><input placeholder="e.g. AWAITING_CUSTOMS" class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm font-mono uppercase"></div>
        <div><label class="block text-xs font-medium text-ink/60 mb-1.5">Description</label><input placeholder="Short description" class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm"></div>
        <button type="button" onclick="toggleModal('addStatusModal')" class="w-full py-2.5 rounded-lg bg-primary text-white text-sm font-semibold">Save Status Type</button>
      </form>
    </div>
  </div>

  <!-- Add Category Modal -->
  <div id="addCategoryModal" class="hidden fixed inset-0 bg-ink/30 flex items-center justify-center z-50 p-4">
    <div class="w-full max-w-sm bg-white rounded-xl p-6">
      <div class="flex items-center justify-between mb-5">
        <h3 class="font-display font-semibold text-base">Add Product Category</h3>
        <button onclick="toggleModal('addCategoryModal')" class="text-ink/40 hover:text-ink">&#10005;</button>
      </div>
      <form class="space-y-4">
        <div><label class="block text-xs font-medium text-ink/60 mb-1.5">Category Name</label><input placeholder="e.g. Perishable Goods" class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm"></div>
        <button type="button" onclick="toggleModal('addCategoryModal')" class="w-full py-2.5 rounded-lg bg-primary text-white text-sm font-semibold">Save Category</button>
      </form>
    </div>
  </div>

<script>
function cfgTab(e, id){
  document.querySelectorAll('#cfg-status,#cfg-categories').forEach(el=>el.classList.add('hidden'));
  document.getElementById(id).classList.remove('hidden');
  document.querySelectorAll('.cfgtabbtn').forEach(b=>{ b.classList.remove('border-primary','text-primary'); b.classList.add('border-transparent','text-ink/50'); });
  e.currentTarget.classList.add('border-primary','text-primary');
  e.currentTarget.classList.remove('border-transparent','text-ink/50');
}
function toggleModal(id){ document.getElementById(id).classList.toggle('hidden'); }
</script>

<%@ include file="includes/footer.jspf" %>
