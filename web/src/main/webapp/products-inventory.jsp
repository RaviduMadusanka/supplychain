<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Products & Inventory";
  String pageSubtitle = "3 SKUs \u00b7 3 warehouses \u00b7 2 active alerts";
  String activePage = "products";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <!-- tabs -->
  <div class="flex items-center gap-1 mb-5 border-b border-line">
    <button onclick="scmTab(event,'t-products')" class="scmtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-primary text-primary">Products</button>
    <button onclick="scmTab(event,'t-stock')" class="scmtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-transparent text-ink/50">Stock by Warehouse</button>
    <button onclick="scmTab(event,'t-alerts')" class="scmtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-transparent text-ink/50">Alerts <span class="ml-1 px-1.5 py-0.5 rounded-full bg-ambersoft text-amber text-[10px] font-mono">2</span></button>
  </div>

  <div id="t-products">
    <div class="flex justify-end mb-4"><button onclick="toggleModal('addProductModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition">+ Add Product</button></div>
    <div class="card overflow-hidden">
      <table class="w-full text-sm">
        <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
          <th class="px-5 py-3 font-medium">SKU</th><th class="px-5 py-3 font-medium">Name</th><th class="px-5 py-3 font-medium">Category</th><th class="px-5 py-3 font-medium">Weight</th><th class="px-5 py-3 font-medium">Reorder Level</th><th class="px-5 py-3 font-medium">Vendor</th>
        </tr></thead>
        <tbody class="divide-y divide-line">
          <tr class="hover:bg-bg/60"><td class="px-5 py-3 font-mono text-xs">SKU-1001</td><td class="px-5 py-3">Industrial Circuit Board</td><td class="px-5 py-3 text-ink/60">Electronics</td><td class="px-5 py-3 text-ink/60">0.75 kg</td><td class="px-5 py-3 text-ink/60">50</td><td class="px-5 py-3 text-ink/60">Apex Tech Components</td></tr>
          <tr class="hover:bg-bg/60"><td class="px-5 py-3 font-mono text-xs">SKU-1002</td><td class="px-5 py-3">Steel Cargo Container Lock</td><td class="px-5 py-3 text-ink/60">Hardware</td><td class="px-5 py-3 text-ink/60">1.20 kg</td><td class="px-5 py-3 text-ink/60">100</td><td class="px-5 py-3 text-ink/60">Global Parts Ltd</td></tr>
          <tr class="hover:bg-bg/60"><td class="px-5 py-3 font-mono text-xs">SKU-1003</td><td class="px-5 py-3">Packaging Wrap Roll 500m</td><td class="px-5 py-3 text-ink/60">Packaging Materials</td><td class="px-5 py-3 text-ink/60">12.50 kg</td><td class="px-5 py-3 text-ink/60">30</td><td class="px-5 py-3 text-ink/60">Pacific Freight Supplies</td></tr>
        </tbody>
      </table>
    </div>
  </div>

  <div id="t-stock" class="hidden">
    <div class="card overflow-hidden">
      <table class="w-full text-sm">
        <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
          <th class="px-5 py-3 font-medium">Product</th><th class="px-5 py-3 font-medium">Warehouse</th><th class="px-5 py-3 font-medium">Qty on Hand</th><th class="px-5 py-3 font-medium">Unit Price</th><th class="px-5 py-3 font-medium">Status</th><th class="px-5 py-3 font-medium">Updated</th>
        </tr></thead>
        <tbody class="divide-y divide-line">
          <tr class="hover:bg-bg/60"><td class="px-5 py-3">Industrial Circuit Board</td><td class="px-5 py-3 text-ink/60">Colombo Central</td><td class="px-5 py-3 font-mono">420</td><td class="px-5 py-3 font-mono">$85.00</td><td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>In Stock</span></td><td class="px-5 py-3 text-xs text-ink/40 font-mono">01 Aug 08:00</td></tr>
          <tr class="hover:bg-bg/60"><td class="px-5 py-3">Steel Cargo Container Lock</td><td class="px-5 py-3 text-ink/60">Singapore Regional Hub</td><td class="px-5 py-3 font-mono">45</td><td class="px-5 py-3 font-mono">$29.20</td><td class="px-5 py-3"><span class="tag tag-amber"><span class="tag-dot"></span>Low Stock</span></td><td class="px-5 py-3 text-xs text-ink/40 font-mono">02 Aug 08:00</td></tr>
          <tr class="hover:bg-bg/60"><td class="px-5 py-3">Packaging Wrap Roll 500m</td><td class="px-5 py-3 text-ink/60">Dubai Logistics Park</td><td class="px-5 py-3 font-mono">0</td><td class="px-5 py-3 font-mono">$49.50</td><td class="px-5 py-3"><span class="tag tag-amber"><span class="tag-dot"></span>Out of Stock</span></td><td class="px-5 py-3 text-xs text-ink/40 font-mono">03 Aug 08:00</td></tr>
        </tbody>
      </table>
    </div>
  </div>

  <div id="t-alerts" class="hidden space-y-3">
    <div class="card p-4 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <span class="w-9 h-9 rounded-lg bg-ambersoft text-amber flex items-center justify-center font-mono text-xs">!</span>
        <div><div class="text-sm font-medium">Low stock &mdash; Steel Cargo Container Lock</div><div class="text-xs text-ink/40 font-mono">Singapore Regional Hub &middot; triggered 02 Aug 08:05</div></div>
      </div>
      <button class="px-3 py-1.5 rounded-lg border border-line text-xs font-medium hover:bg-bg">Resolve</button>
    </div>
    <div class="card p-4 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <span class="w-9 h-9 rounded-lg bg-ambersoft text-amber flex items-center justify-center font-mono text-xs">!</span>
        <div><div class="text-sm font-medium">Out of stock &mdash; Packaging Wrap Roll 500m</div><div class="text-xs text-ink/40 font-mono">Dubai Logistics Park &middot; triggered 03 Aug 08:05</div></div>
      </div>
      <button class="px-3 py-1.5 rounded-lg border border-line text-xs font-medium hover:bg-bg">Resolve</button>
    </div>
  </div>

<script>
function scmTab(e, id){
  document.querySelectorAll('#t-products,#t-stock,#t-alerts').forEach(el=>el.classList.add('hidden'));
  document.getElementById(id).classList.remove('hidden');
  document.querySelectorAll('.scmtabbtn').forEach(b=>{ b.classList.remove('border-primary','text-primary'); b.classList.add('border-transparent','text-ink/50'); });
  e.currentTarget.classList.add('border-primary','text-primary');
  e.currentTarget.classList.remove('border-transparent','text-ink/50');
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

<!-- Add Product Modal -->
<div id="addProductModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-sm">
  <div class="bg-white rounded-xl shadow-xl border border-line w-full max-w-md p-6">
    <div class="flex items-center justify-between mb-4">
      <h3 class="font-display font-semibold text-lg">Add New Product</h3>
      <button onclick="toggleModal('addProductModal')" class="text-ink/50 hover:text-ink">&times;</button>
    </div>
    <form class="space-y-4">
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">SKU</label>
        <input type="text" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary">
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Name</label>
        <input type="text" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary">
      </div>
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1">Category</label>
          <input type="text" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary">
        </div>
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1">Reorder Level</label>
          <input type="number" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary">
        </div>
      </div>
      <div class="mt-6 flex justify-end gap-3">
        <button type="button" onclick="toggleModal('addProductModal')" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg">Cancel</button>
        <button type="button" onclick="toggleModal('addProductModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-medium hover:bg-primarydk transition">Save Product</button>
      </div>
    </form>
  </div>
</div>

<%@ include file="includes/footer.jspf" %>
