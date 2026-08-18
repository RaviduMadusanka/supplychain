<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Warehouse Dashboard";
  String pageSubtitle = "Colombo Central \u00b7 Real-time operations overview";
  String activePage = "dashboard";
  String userName = "Saman Kumara";
  String userRole = "Warehouse Manager";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
    <a href="products-inventory.jsp" class="card p-5 hover:border-primary transition group block">
      <div class="text-xs text-ink/50 mb-1 group-hover:text-primary transition">Total SKUs</div>
      <div class="font-display text-3xl font-semibold">3</div>
      <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Across 3 warehouses</div>
    </a>
    <a href="products-inventory.jsp" class="card p-5 border-amber/30 bg-ambersoft/20 hover:border-amber transition group block">
      <div class="text-xs text-amber/70 mb-1 font-semibold flex items-center justify-between">Low Stock Alerts <span class="tag tag-amber"><span class="tag-dot"></span>Attention</span></div>
      <div class="font-display text-3xl font-semibold text-amber">2</div>
      <div class="text-[10px] text-amber/60 font-mono mt-1 uppercase">Requires restocking</div>
    </a>
    <div class="card p-5">
      <div class="text-xs text-ink/50 mb-1 flex items-center justify-between">Pending Shipments <span class="tag tag-blue"><span class="tag-dot"></span>Active</span></div>
      <div class="font-display text-3xl font-semibold text-primary">1</div>
      <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Awaiting dispatch</div>
    </div>
    <div class="card p-5">
      <div class="text-xs text-ink/50 mb-1">Orders Processing</div>
      <div class="font-display text-3xl font-semibold text-teal">1</div>
      <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Currently picking</div>
    </div>
  </div>

  <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <div class="lg:col-span-2 space-y-6">
      <div class="card">
        <div class="px-5 py-4 border-b border-line flex items-center justify-between">
          <div class="flex items-center gap-3">
            <h3 class="font-display font-semibold text-sm">Stock Levels</h3>
            <a href="products-inventory.jsp" class="text-xs text-primary hover:text-primarydk font-medium transition">View Inventory &rarr;</a>
          </div>
          <button onclick="toggleModal('updateStockModal')" class="px-3 py-1.5 rounded-lg bg-bg text-ink text-xs font-semibold hover:bg-line transition border border-line">Update Stock</button>
        </div>
        <table class="w-full text-sm">
          <thead>
            <tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
              <th class="px-5 py-2.5 font-medium">Product / SKU</th>
              <th class="px-5 py-2.5 font-medium">Warehouse</th>
              <th class="px-5 py-2.5 font-medium text-right">Qty</th>
              <th class="px-5 py-2.5 font-medium text-right">Unit Price</th>
              <th class="px-5 py-2.5 font-medium text-right">Status</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-line">
            <tr class="hover:bg-bg/50 transition">
              <td class="px-5 py-3">
                <div class="font-medium">Industrial Circuit Board</div>
                <div class="text-xs text-ink/40 font-mono mt-0.5">SKU-1001</div>
              </td>
              <td class="px-5 py-3 text-xs">Colombo Central</td>
              <td class="px-5 py-3 text-right font-mono font-medium">420</td>
              <td class="px-5 py-3 text-right font-mono text-xs text-ink/60">$85.00</td>
              <td class="px-5 py-3 text-right"><span class="tag tag-teal"><span class="tag-dot"></span>In Stock</span></td>
            </tr>
            <tr class="hover:bg-bg/50 transition">
              <td class="px-5 py-3">
                <div class="font-medium">Steel Cargo Container Lock</div>
                <div class="text-xs text-ink/40 font-mono mt-0.5">SKU-1002</div>
              </td>
              <td class="px-5 py-3 text-xs">Singapore Hub</td>
              <td class="px-5 py-3 text-right font-mono font-medium text-amber">45</td>
              <td class="px-5 py-3 text-right font-mono text-xs text-ink/60">$29.20</td>
              <td class="px-5 py-3 text-right"><span class="tag tag-amber"><span class="tag-dot"></span>Low Stock</span></td>
            </tr>
            <tr class="hover:bg-bg/50 transition opacity-60">
              <td class="px-5 py-3">
                <div class="font-medium">Packaging Wrap Roll 500m</div>
                <div class="text-xs text-ink/40 font-mono mt-0.5">SKU-1003</div>
              </td>
              <td class="px-5 py-3 text-xs">Dubai Logistics</td>
              <td class="px-5 py-3 text-right font-mono font-medium text-amber">0</td>
              <td class="px-5 py-3 text-right font-mono text-xs text-ink/60">$49.50</td>
              <td class="px-5 py-3 text-right"><span class="tag tag-amber"><span class="tag-dot"></span>Out of Stock</span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div class="space-y-6">
      <div class="card p-0 overflow-hidden border-amber/30">
        <div class="px-5 py-4 border-b border-amber/20 bg-ambersoft/30 flex items-center justify-between">
          <h3 class="font-display font-semibold text-sm text-amber flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
            Low Stock Alerts
          </h3>
        </div>
        <div class="divide-y divide-line">
          <div class="p-4 hover:bg-bg/30 transition">
            <div class="text-xs font-semibold text-ink mb-1">Steel Cargo Container Lock</div>
            <div class="text-[11px] text-ink/50 mb-3">Singapore Hub &middot; Triggered 02 Aug</div>
            <div class="flex items-center justify-between">
              <span class="text-xs font-mono text-amber font-medium">45 left (Min: 50)</span>
              <button class="px-3 py-1 rounded border border-line text-[11px] font-semibold hover:bg-bg transition text-ink">Reorder</button>
            </div>
          </div>
          <div class="p-4 hover:bg-bg/30 transition">
            <div class="text-xs font-semibold text-ink mb-1">Packaging Wrap Roll 500m</div>
            <div class="text-[11px] text-ink/50 mb-3">Dubai Logistics &middot; Triggered 03 Aug</div>
            <div class="flex items-center justify-between">
              <span class="text-xs font-mono text-amber font-medium">0 left (Min: 100)</span>
              <button class="px-3 py-1 rounded border border-line text-[11px] font-semibold hover:bg-bg transition text-ink">Reorder</button>
            </div>
          </div>
        </div>
      </div>
    </div>
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

<!-- Update Stock Modal -->
<div id="updateStockModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-sm">
  <div class="bg-white rounded-xl shadow-xl border border-line w-full max-w-sm p-6">
    <div class="flex items-center justify-between mb-4">
      <h3 class="font-display font-semibold text-lg">Update Stock Level</h3>
      <button onclick="toggleModal('updateStockModal')" class="text-ink/50 hover:text-ink">&times;</button>
    </div>
    <form class="space-y-4">
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Product</label>
        <select class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary bg-white">
          <option>Industrial Circuit Board</option>
          <option>Steel Cargo Container Lock</option>
          <option>Packaging Wrap Roll 500m</option>
        </select>
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Warehouse</label>
        <select class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary bg-white">
          <option>Colombo Central</option>
          <option>Singapore Hub</option>
          <option>Dubai Logistics</option>
        </select>
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">New Quantity</label>
        <input type="number" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary font-mono" placeholder="0">
      </div>
      <div class="mt-6 flex justify-end gap-3 border-t border-line pt-4">
        <button type="button" onclick="toggleModal('updateStockModal')" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg">Cancel</button>
        <button type="button" onclick="toggleModal('updateStockModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-medium hover:bg-primarydk transition">Confirm Update</button>
      </div>
    </form>
  </div>
</div>

<%@ include file="includes/footer.jspf" %>
