<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  String pageTitle = "Inventory";
  String pageSubtitle = "Add Stock";
  String activePage = "products";
  
  // Try to read user info from session
  // (Variables are handled by sidebar.jspf if session exists, but must be declared here)
  String userName = "Saman Kumara";
  String userRole = "WAREHOUSE_MANAGER";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <!-- Top Navigation actions (similar to screenshot) -->
  <div class="flex items-center justify-between mb-8">
    <div>
      <h2 class="text-2xl font-display font-semibold text-ink">Add Inventory</h2>
      <p class="text-sm text-ink/50 mt-1">Record stock for a product at a specific warehouse.</p>
    </div>
    <div class="flex gap-3">
      <a href="javascript:void(0)" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg transition bg-white flex items-center gap-2">
        <span>+</span> New Product Instead
      </a>
      <a href="<%= request.getContextPath() %>/inventory" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg transition bg-white flex items-center gap-2">
        &larr; Back to Inventory
      </a>
    </div>
  </div>

  <% if (request.getAttribute("errorMsg") != null) { %>
    <div class="mb-6 p-4 rounded-lg bg-amber/10 border border-amber/20 text-amber text-sm font-medium">
      <%= request.getAttribute("errorMsg") %>
    </div>
  <% } %>

  <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
    
    <!-- LEFT: Form -->
    <div class="lg:col-span-2">
      <div class="card p-6">
        <h3 class="text-sm font-semibold mb-6">Stock Entry</h3>
        
        <form id="addInventoryForm" action="<%= request.getContextPath() %>/inventory/add" method="post" class="space-y-5">
          <!-- Product -->
          <div>
            <label class="block text-xs font-medium text-ink/70 mb-1.5">Product</label>
            <select id="productId" name="productId" class="w-full px-3 py-2.5 bg-white border border-line rounded-lg text-sm focus:outline-none focus:border-primary transition" required>
              <option value="">Search / select a product...</option>
              <c:forEach var="p" items="${products}">
                <option value="${p.id}" data-category="${p.categoryName}">${p.name} (${p.sku})</option>
              </c:forEach>
            </select>
            <p class="text-[10px] text-ink/40 mt-1.5">Don't see the product? <a href="#" class="text-primary hover:underline">Create it first.</a></p>
          </div>

          <!-- Warehouse & Stock Qty -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
            <div>
              <label class="block text-xs font-medium text-ink/70 mb-1.5">Warehouse</label>
              <select id="warehouseId" name="warehouseId" class="w-full px-3 py-2.5 bg-white border border-line rounded-lg text-sm focus:outline-none focus:border-primary transition" required>
                <option value="">Select warehouse...</option>
                <c:forEach var="w" items="${warehouses}">
                  <option value="${w.id}">${w.name}</option>
                </c:forEach>
              </select>
            </div>
            <div>
              <label class="block text-xs font-medium text-ink/70 mb-1.5">Stock Quantity</label>
              <input type="number" id="stockQuantity" name="stockQuantity" min="0" value="0" class="w-full px-3 py-2.5 bg-white border border-line rounded-lg text-sm font-mono focus:outline-none focus:border-primary transition" required>
            </div>
          </div>

          <!-- Unit Price & Low-Stock Threshold -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
            <div>
              <label class="block text-xs font-medium text-ink/70 mb-1.5">Unit Price (USD)</label>
              <input type="number" id="unitPrice" name="unitPrice" min="0" step="0.01" value="0.00" class="w-full px-3 py-2.5 bg-white border border-line rounded-lg text-sm font-mono focus:outline-none focus:border-primary transition" required>
              <p class="text-[10px] text-ink/40 mt-1.5 leading-tight">Pre-filled from the product catalog &mdash; adjust if this warehouse has a different landed cost.</p>
            </div>
            <div>
              <label class="block text-xs font-medium text-ink/70 mb-1.5">Low-Stock Threshold</label>
              <input type="number" id="lowStockThreshold" name="lowStockThreshold" min="0" value="20" class="w-full px-3 py-2.5 bg-white border border-line rounded-lg text-sm font-mono focus:outline-none focus:border-primary transition" required>
              <p class="text-[10px] text-ink/40 mt-1.5 leading-tight">Below this quantity, the item is flagged "Low" on the inventory page.</p>
            </div>
          </div>

          <!-- Status -->
          <div class="w-1/2 pr-2.5">
            <label class="block text-xs font-medium text-ink/70 mb-1.5">Status</label>
            <select id="statusId" name="statusId" class="w-full px-3 py-2.5 bg-white border border-line rounded-lg text-sm focus:outline-none focus:border-primary transition">
              <option value="1">Active</option>
              <option value="2">Inactive</option>
            </select>
          </div>

          <!-- Notes -->
          <div>
            <label class="block text-xs font-medium text-ink/70 mb-1.5">Notes (optional)</label>
            <textarea id="notes" name="notes" rows="3" placeholder="Batch number, supplier reference, storage conditions, etc." class="w-full px-3 py-2.5 bg-white border border-line rounded-lg text-sm focus:outline-none focus:border-primary transition resize-none"></textarea>
          </div>

          <!-- Actions -->
          <div class="pt-6 mt-6 border-t border-line flex justify-end gap-3">
            <a href="<%= request.getContextPath() %>/inventory" class="px-5 py-2.5 rounded-lg border border-line text-sm font-medium hover:bg-bg transition bg-white">Cancel</a>
            <button type="submit" class="px-5 py-2.5 rounded-lg bg-primary text-white text-sm font-medium hover:bg-primarydk transition flex items-center gap-2">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
              Save Stock Entry
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- RIGHT: Preview Card -->
    <div class="lg:col-span-1">
      <div class="card p-6 sticky top-6">
        <h3 class="text-sm font-semibold mb-6">Preview</h3>
        
        <div class="h-24 bg-primsoft/50 rounded-xl flex items-center justify-center text-primary/40 mb-6 border border-primary/10">
          <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
        </div>

        <div class="space-y-4 text-sm">
          <div class="flex justify-between items-center border-b border-line pb-3">
            <span class="text-ink/60">Product</span>
            <span id="previewProduct" class="font-medium text-right">&mdash;</span>
          </div>
          <div class="flex justify-between items-center border-b border-line pb-3">
            <span class="text-ink/60">Category</span>
            <span id="previewCategory" class="font-medium text-right">&mdash;</span>
          </div>
          <div class="flex justify-between items-center border-b border-line pb-3">
            <span class="text-ink/60">Unit Price</span>
            <span id="previewPrice" class="font-mono font-medium text-right">$0.00</span>
          </div>
          <div class="flex justify-between items-center border-b border-line pb-3">
            <span class="text-ink/60">Stock Qty</span>
            <span id="previewQty" class="font-mono font-medium text-right">0</span>
          </div>
          <div class="flex justify-between items-center border-b border-line pb-3">
            <span class="text-ink/60">Total Value</span>
            <span id="previewTotal" class="font-mono font-semibold text-primary text-right">$0.00</span>
          </div>
          <div class="flex justify-between items-center pt-1">
            <span class="text-ink/60">Status</span>
            <span id="previewStatus" class="tag tag-teal text-xs"><span class="tag-dot"></span>Will be Active</span>
          </div>
        </div>
      </div>
    </div>

  </div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    const productId = document.getElementById("productId");
    const stockQuantity = document.getElementById("stockQuantity");
    const unitPrice = document.getElementById("unitPrice");
    const statusId = document.getElementById("statusId");

    const pProduct = document.getElementById("previewProduct");
    const pCategory = document.getElementById("previewCategory");
    const pPrice = document.getElementById("previewPrice");
    const pQty = document.getElementById("previewQty");
    const pTotal = document.getElementById("previewTotal");
    const pStatus = document.getElementById("previewStatus");

    function updatePreview() {
        // Product & Category
        if (productId.selectedIndex > 0) {
            const opt = productId.options[productId.selectedIndex];
            // Name part without SKU (assuming format "Name (SKU)")
            let text = opt.text;
            let name = text.substring(0, text.lastIndexOf("(")).trim();
            pProduct.textContent = name || text;
            pCategory.textContent = opt.getAttribute("data-category") || "Uncategorized";
        } else {
            pProduct.innerHTML = "&mdash;";
            pCategory.innerHTML = "&mdash;";
        }

        // Qty & Price
        const q = parseInt(stockQuantity.value) || 0;
        const p = parseFloat(unitPrice.value) || 0;
        pQty.textContent = q;
        
        pPrice.textContent = "$" + p.toFixed(2);
        pTotal.textContent = "$" + (q * p).toFixed(2);

        // Status
        if (statusId.value === "1") {
            pStatus.className = "tag tag-teal text-xs";
            pStatus.innerHTML = '<span class="tag-dot"></span>Will be Active';
        } else {
            pStatus.className = "tag tag-slate text-xs";
            pStatus.innerHTML = '<span class="tag-dot"></span>Will be Inactive';
        }
    }

    productId.addEventListener("change", updatePreview);
    stockQuantity.addEventListener("input", updatePreview);
    unitPrice.addEventListener("input", updatePreview);
    statusId.addEventListener("change", updatePreview);
});
</script>

<%@ include file="includes/footer.jspf" %>
