<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "My Products";
  String pageSubtitle = "Products supplied by Apex Tech Components";
  String activePage = "vendorproducts";
  String userName = "Sanduni Wickrama";
  String userRole = "Vendor";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<div class="flex justify-end mb-6">
  <button onclick="toggleModal('addProductModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold shadow-sm hover:bg-primarydk transition">+ Add Product</button>
</div>

<div class="card">
  <table class="w-full text-sm">
    <thead>
      <tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
        <th class="px-5 py-2.5 font-medium">SKU</th>
        <th class="px-5 py-2.5 font-medium">Name</th>
        <th class="px-5 py-2.5 font-medium">Category</th>
        <th class="px-5 py-2.5 font-medium text-right">Weight</th>
        <th class="px-5 py-2.5 font-medium text-right">Reorder Level</th>
        <th class="px-5 py-2.5 font-medium text-right w-24">Actions</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-line">
      <tr class="group hover:bg-bg/50 transition">
        <td class="px-5 py-3 font-mono text-xs text-ink/70">SKU-1001</td>
        <td class="px-5 py-3 font-medium">Industrial Circuit Board</td>
        <td class="px-5 py-3 text-xs"><span class="px-2 py-1 rounded bg-bg text-ink/70 border border-line">Electronics</span></td>
        <td class="px-5 py-3 text-right font-mono text-xs text-ink/70">0.75 kg</td>
        <td class="px-5 py-3 text-right font-mono text-xs">50</td>
        <td class="px-5 py-3 text-right">
          <button class="px-3 py-1 rounded border border-line text-[11px] font-semibold hover:bg-bg transition text-ink">Edit</button>
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
</script>

<!-- Add Product Modal -->
<div id="addProductModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-sm">
  <div class="bg-white rounded-xl shadow-xl border border-line w-full max-w-sm p-6">
    <div class="flex items-center justify-between mb-4">
      <h3 class="font-display font-semibold text-lg">Add New Product</h3>
      <button onclick="toggleModal('addProductModal')" class="text-ink/50 hover:text-ink">&times;</button>
    </div>
    <form class="space-y-4">
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">SKU</label>
        <input type="text" class="w-full px-3 py-2 border border-line rounded-lg text-sm font-mono focus:outline-none focus:border-primary" placeholder="e.g. SKU-1004">
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Product Name</label>
        <input type="text" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary" placeholder="Enter name">
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Category</label>
        <select class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary bg-white">
          <option>Electronics</option>
          <option>Hardware</option>
          <option>Packaging Materials</option>
        </select>
      </div>
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1">Weight (kg)</label>
          <input type="number" step="0.01" class="w-full px-3 py-2 border border-line rounded-lg text-sm font-mono focus:outline-none focus:border-primary" placeholder="0.00">
        </div>
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1">Reorder Lvl</label>
          <input type="number" class="w-full px-3 py-2 border border-line rounded-lg text-sm font-mono focus:outline-none focus:border-primary" placeholder="0">
        </div>
      </div>
      <div class="mt-6 flex justify-end gap-3 pt-4 border-t border-line">
        <button type="button" onclick="toggleModal('addProductModal')" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg">Cancel</button>
        <button type="button" onclick="toggleModal('addProductModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-medium hover:bg-primarydk transition">Save Product</button>
      </div>
    </form>
  </div>
</div>

<%@ include file="includes/footer.jspf" %>
