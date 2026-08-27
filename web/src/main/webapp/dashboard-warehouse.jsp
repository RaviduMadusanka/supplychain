<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Warehouse Manager Dashboard";
  String pageSubtitle = "Colombo Central Warehouse \u00b7 WH-001";
  String activePage = "dashboard";
  String userName = "Kasun Fernando";
  String userRole = "Warehouse Manager";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
    <div class="card p-5">
      <div class="text-xs text-ink/50 mb-1">SKUs in this warehouse</div>
      <div class="font-display text-3xl font-semibold">3</div>
    </div>
    <div class="card p-5">
      <div class="text-xs text-ink/50 mb-1">Low-stock alerts</div>
      <div class="font-display text-3xl font-semibold text-amber">2</div>
    </div>
    <div class="card p-5">
      <div class="text-xs text-ink/50 mb-1">Shipments awaiting update</div>
      <div class="font-display text-3xl font-semibold text-primary">2</div>
    </div>
    <div class="card p-5">
      <div class="text-xs text-ink/50 mb-1">Restock orders sent (30d)</div>
      <div class="font-display text-3xl font-semibold text-teal">4</div>
    </div>
  </div>

  <div class="flex items-center gap-1 mb-5 border-b border-line">
    <button onclick="wmTab(event,'wm-overview')" class="wmtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-primary text-primary">Overview</button>
    <button onclick="wmTab(event,'wm-stock')" class="wmtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-transparent text-ink/50">Update Stock</button>
    <button onclick="wmTab(event,'wm-shipments')" class="wmtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-transparent text-ink/50">Shipment Status</button>
    <button onclick="wmTab(event,'wm-alerts')" class="wmtabbtn px-4 py-2.5 text-sm font-medium border-b-2 border-transparent text-ink/50">Low-Stock Alerts <span class="ml-1 px-1.5 py-0.5 rounded-full bg-ambersoft text-amber text-[10px] font-mono">2</span></button>
  </div>

  <div id="wm-overview">
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-5">
      <div class="card">
        <div class="px-5 py-4 border-b border-line flex items-center justify-between">
          <h3 class="font-display font-semibold text-sm">Recent Stock Movements</h3>
          <button onclick="wmTabByName('wm-stock')" class="text-xs text-primary font-medium hover:underline">Update stock &rarr;</button>
        </div>
        <table class="w-full text-sm">
          <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
            <th class="px-5 py-2.5 font-medium">Product</th><th class="px-5 py-2.5 font-medium">Qty</th><th class="px-5 py-2.5 font-medium">Updated</th>
          </tr></thead>
          <tbody class="divide-y divide-line">
            <tr><td class="px-5 py-3">Industrial Circuit Board</td><td class="px-5 py-3 font-mono">420</td><td class="px-5 py-3 text-xs text-ink/40 font-mono">01 Aug 08:00</td></tr>
            <tr><td class="px-5 py-3">Steel Cargo Container Lock</td><td class="px-5 py-3 font-mono">45</td><td class="px-5 py-3 text-xs text-ink/40 font-mono">02 Aug 08:00</td></tr>
          </tbody>
        </table>
      </div>

      <div class="card">
        <div class="px-5 py-4 border-b border-line flex items-center justify-between">
          <h3 class="font-display font-semibold text-sm">Shipments Needing Action</h3>
          <button onclick="wmTabByName('wm-shipments')" class="text-xs text-primary font-medium hover:underline">Manage &rarr;</button>
        </div>
        <table class="w-full text-sm">
          <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
            <th class="px-5 py-2.5 font-medium">Shipment</th><th class="px-5 py-2.5 font-medium">Destination</th><th class="px-5 py-2.5 font-medium">Status</th>
          </tr></thead>
          <tbody class="divide-y divide-line">
            <tr><td class="px-5 py-3 font-mono text-xs">SHP-20260702-001</td><td class="px-5 py-3">Colombo, Sri Lanka</td><td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>In Transit</span></td></tr>
            <tr><td class="px-5 py-3 font-mono text-xs">SHP-20260711-003</td><td class="px-5 py-3">Dubai, UAE</td><td class="px-5 py-3"><span class="tag tag-slate"><span class="tag-dot"></span>Pending</span></td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <div id="wm-stock" class="hidden">
    <div class="flex justify-end mb-4">
      <button onclick="toggleModal('addStockModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition">+ Add Stock Receipt</button>
    </div>
    <div class="card overflow-hidden">
      <table class="w-full text-sm">
        <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
          <th class="px-5 py-3 font-medium">Product</th><th class="px-5 py-3 font-medium">SKU</th><th class="px-5 py-3 font-medium">Qty on Hand</th><th class="px-5 py-3 font-medium">Unit Price</th><th class="px-5 py-3 font-medium">Status</th><th class="px-5 py-3 font-medium">Updated</th><th class="px-5 py-3 font-medium"></th>
        </tr></thead>
        <tbody class="divide-y divide-line">
          <tr class="hover:bg-bg/60" data-row="1">
            <td class="px-5 py-3">Industrial Circuit Board</td>
            <td class="px-5 py-3 font-mono text-xs text-ink/50">SKU-1001</td>
            <td class="px-5 py-3 font-mono qty-cell">420</td>
            <td class="px-5 py-3 font-mono">$85.00</td>
            <td class="px-5 py-3"><span class="tag tag-teal"><span class="tag-dot"></span>In Stock</span></td>
            <td class="px-5 py-3 text-xs text-ink/40 font-mono">01 Aug 08:00</td>
            <td class="px-5 py-3 text-right"><button onclick="openStockEdit('1','Industrial Circuit Board','SKU-1001',420)" class="text-primary text-xs font-medium hover:underline">Update qty</button></td>
          </tr>
          <tr class="hover:bg-bg/60" data-row="2">
            <td class="px-5 py-3">Steel Cargo Container Lock</td>
            <td class="px-5 py-3 font-mono text-xs text-ink/50">SKU-1002</td>
            <td class="px-5 py-3 font-mono qty-cell">45</td>
            <td class="px-5 py-3 font-mono">$29.20</td>
            <td class="px-5 py-3"><span class="tag tag-amber"><span class="tag-dot"></span>Low Stock</span></td>
            <td class="px-5 py-3 text-xs text-ink/40 font-mono">02 Aug 08:00</td>
            <td class="px-5 py-3 text-right"><button onclick="openStockEdit('2','Steel Cargo Container Lock','SKU-1002',45)" class="text-primary text-xs font-medium hover:underline">Update qty</button></td>
          </tr>
          <tr class="hover:bg-bg/60" data-row="3">
            <td class="px-5 py-3">Packaging Wrap Roll 500m</td>
            <td class="px-5 py-3 font-mono text-xs text-ink/50">SKU-1003</td>
            <td class="px-5 py-3 font-mono qty-cell">0</td>
            <td class="px-5 py-3 font-mono">$49.50</td>
            <td class="px-5 py-3"><span class="tag tag-amber"><span class="tag-dot"></span>Out of Stock</span></td>
            <td class="px-5 py-3 text-xs text-ink/40 font-mono">03 Aug 08:00</td>
            <td class="px-5 py-3 text-right"><button onclick="openStockEdit('3','Packaging Wrap Roll 500m','SKU-1003',0)" class="text-primary text-xs font-medium hover:underline">Update qty</button></td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <div id="wm-shipments" class="hidden space-y-4">
    <div class="card p-5">
      <div class="flex items-center justify-between mb-4">
        <div>
          <span class="font-mono text-xs text-ink/40">SHP-20260702-001</span>
          <div class="font-medium text-sm mt-0.5">Colombo Central Warehouse &rarr; Colombo, Sri Lanka</div>
        </div>
        <span id="statuspill-1" class="tag tag-blue"><span class="tag-dot"></span>In Transit</span>
      </div>
      <div class="flex items-center justify-between pt-3 border-t border-line">
        <span class="text-xs text-ink/50">Carrier: <span class="text-ink font-medium">DHL Express</span> &middot; ETA: <span class="text-ink font-medium">08 Jul, 5:00 PM</span></span>
        <div class="flex items-center gap-2">
          <select id="statussel-1" class="px-3 py-1.5 rounded-lg border border-line bg-white text-xs font-mono uppercase focus:outline-none focus:ring-2 focus:ring-primary/30">
            <option>Pending</option>
            <option selected>Shipped</option>
            <option>In Transit</option>
            <option>Delivered</option>
            <option>Delayed</option>
          </select>
          <button onclick="updateShipmentStatus('1')" class="px-3 py-1.5 rounded-lg bg-primary text-white text-xs font-semibold hover:bg-primarydk transition">Update</button>
        </div>
      </div>
    </div>

    <div class="card p-5">
      <div class="flex items-center justify-between mb-4">
        <div>
          <span class="font-mono text-xs text-ink/40">SHP-20260711-003</span>
          <div class="font-medium text-sm mt-0.5">Dubai Logistics Park &rarr; Dubai, UAE</div>
        </div>
        <span id="statuspill-3" class="tag tag-slate"><span class="tag-dot"></span>Pending</span>
      </div>
      <div class="flex items-center justify-between pt-3 border-t border-line">
        <span class="text-xs text-ink/50">Carrier: <span class="text-ink font-medium">FedEx Freight</span> &middot; ETA: <span class="text-ink font-medium">18 Jul, 3:00 PM</span></span>
        <div class="flex items-center gap-2">
          <select id="statussel-3" class="px-3 py-1.5 rounded-lg border border-line bg-white text-xs font-mono uppercase focus:outline-none focus:ring-2 focus:ring-primary/30">
            <option selected>Pending</option>
            <option>Shipped</option>
            <option>In Transit</option>
            <option>Delivered</option>
            <option>Delayed</option>
          </select>
          <button onclick="updateShipmentStatus('3')" class="px-3 py-1.5 rounded-lg bg-primary text-white text-xs font-semibold hover:bg-primarydk transition">Update</button>
        </div>
      </div>
    </div>
  </div>

  <div id="wm-alerts" class="hidden space-y-3">
    <div class="card p-4 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <span class="w-9 h-9 rounded-lg bg-ambersoft text-amber flex items-center justify-center font-mono text-xs">!</span>
        <div>
          <div class="text-sm font-medium">Low stock &mdash; Steel Cargo Container Lock</div>
          <div class="text-xs text-ink/40 font-mono">45 on hand &middot; reorder level 100 &middot; triggered 02 Aug 08:05</div>
        </div>
      </div>
      <button onclick="openRestockModal('Steel Cargo Container Lock','SKU-1002','Global Parts Ltd', 100)" class="px-3 py-1.5 rounded-lg bg-primary text-white text-xs font-semibold hover:bg-primarydk transition">Create Restock Order</button>
    </div>
    <div class="card p-4 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <span class="w-9 h-9 rounded-lg bg-ambersoft text-amber flex items-center justify-center font-mono text-xs">!</span>
        <div>
          <div class="text-sm font-medium">Out of stock &mdash; Packaging Wrap Roll 500m</div>
          <div class="text-xs text-ink/40 font-mono">0 on hand &middot; reorder level 30 &middot; triggered 03 Aug 08:05</div>
        </div>
      </div>
      <button onclick="openRestockModal('Packaging Wrap Roll 500m','SKU-1003','Pacific Freight Supplies', 30)" class="px-3 py-1.5 rounded-lg bg-primary text-white text-xs font-semibold hover:bg-primarydk transition">Create Restock Order</button>
    </div>

    <div class="card p-4 mt-6">
      <div class="text-xs font-mono uppercase tracking-wide text-ink/40 mb-3">Restock orders sent this month</div>
      <table class="w-full text-sm">
        <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
          <th class="py-2 font-medium">Product</th><th class="py-2 font-medium">Vendor</th><th class="py-2 font-medium">Qty</th><th class="py-2 font-medium">Sent</th><th class="py-2 font-medium">Vendor Response</th>
        </tr></thead>
        <tbody class="divide-y divide-line">
          <tr><td class="py-2.5">Industrial Circuit Board</td><td class="py-2.5 text-ink/60">Apex Tech Components</td><td class="py-2.5 font-mono">200</td><td class="py-2.5 text-xs text-ink/40 font-mono">28 Jul 09:10</td><td class="py-2.5"><span class="tag tag-teal"><span class="tag-dot"></span>Accepted</span></td></tr>
          <tr><td class="py-2.5">Steel Cargo Container Lock</td><td class="py-2.5 text-ink/60">Global Parts Ltd</td><td class="py-2.5 font-mono">150</td><td class="py-2.5 text-xs text-ink/40 font-mono">30 Jul 14:20</td><td class="py-2.5"><span class="tag tag-blue"><span class="tag-dot"></span>Pending</span></td></tr>
        </tbody>
      </table>
    </div>
  </div>

<script>
function wmTab(e, id){ wmTabByName(id, e.currentTarget); }
function wmTabByName(id, btnEl){
  document.querySelectorAll('#wm-overview,#wm-stock,#wm-shipments,#wm-alerts').forEach(el=>el.classList.add('hidden'));
  document.getElementById(id).classList.remove('hidden');
  document.querySelectorAll('.wmtabbtn').forEach(b=>{ b.classList.remove('border-primary','text-primary'); b.classList.add('border-transparent','text-ink/50'); });
  var btn = btnEl || Array.from(document.querySelectorAll('.wmtabbtn')).find(b => b.getAttribute('onclick').indexOf(id) > -1);
  if (btn) { btn.classList.add('border-primary','text-primary'); btn.classList.remove('border-transparent','text-ink/50'); }
}

function toggleModal(id) {
  const modal = document.getElementById(id);
  if (modal.classList.contains('hidden')) { modal.classList.remove('hidden'); modal.classList.add('flex'); }
  else { modal.classList.add('hidden'); modal.classList.remove('flex'); }
}

function openStockEdit(rowId, name, sku, currentQty){
  document.getElementById('stockEditProduct').textContent = name + ' (' + sku + ')';
  document.getElementById('stockEditRowId').value = rowId;
  document.getElementById('stockEditQty').value = currentQty;
  toggleModal('editStockModal');
}
function saveStockEdit(){
  const rowId = document.getElementById('stockEditRowId').value;
  const newQty = document.getElementById('stockEditQty').value;
  const row = document.querySelector('tr[data-row="' + rowId + '"]');
  if (row) { row.querySelector('.qty-cell').textContent = newQty; }
  toggleModal('editStockModal');
}

function updateShipmentStatus(id){
  const sel = document.getElementById('statussel-' + id);
  const pill = document.getElementById('statuspill-' + id);
  const val = sel.value;
  const map = {
    'Pending':  ['tag-slate', 'Pending'],
    'Shipped':  ['tag-blue',  'Shipped'],
    'In Transit': ['tag-blue', 'In Transit'],
    'Delivered':['tag-teal',  'Delivered'],
    'Delayed':  ['tag-amber', 'Delayed']
  };
  const cfg = map[val] || ['tag-slate', val];
  pill.className = 'tag ' + cfg[0];
  pill.innerHTML = '<span class="tag-dot"></span>' + cfg[1];
}

function openRestockModal(name, sku, vendor, suggestedQty){
  document.getElementById('restockProduct').textContent = name + ' (' + sku + ')';
  document.getElementById('restockVendor').value = vendor;
  document.getElementById('restockQty').value = suggestedQty;
  toggleModal('restockModal');
}
</script>

<div id="editStockModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-sm">
  <div class="bg-white rounded-xl shadow-xl border border-line w-full max-w-md p-6">
    <div class="flex items-center justify-between mb-4">
      <h3 class="font-display font-semibold text-lg">Update Stock Quantity</h3>
      <button onclick="toggleModal('editStockModal')" class="text-ink/50 hover:text-ink">&times;</button>
    </div>
    <form class="space-y-4" onsubmit="event.preventDefault(); saveStockEdit();">
      <input type="hidden" id="stockEditRowId">
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Product</label>
        <div id="stockEditProduct" class="text-sm font-medium"></div>
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">New Quantity on Hand</label>
        <input type="number" id="stockEditQty" min="0" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary">
      </div>
      <div class="mt-6 flex justify-end gap-3">
        <button type="button" onclick="toggleModal('editStockModal')" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg">Cancel</button>
        <button type="submit" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-medium hover:bg-primarydk transition">Save</button>
      </div>
    </form>
  </div>
</div>

<div id="restockModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-sm">
  <div class="bg-white rounded-xl shadow-xl border border-line w-full max-w-md p-6">
    <div class="flex items-center justify-between mb-4">
      <h3 class="font-display font-semibold text-lg">Create Restock Order</h3>
      <button onclick="toggleModal('restockModal')" class="text-ink/50 hover:text-ink">&times;</button>
    </div>
    <form class="space-y-4" onsubmit="event.preventDefault(); toggleModal('restockModal');">
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Product</label>
        <div id="restockProduct" class="text-sm font-medium"></div>
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Vendor</label>
        <input type="text" id="restockVendor" readonly class="w-full px-3 py-2 border border-line rounded-lg text-sm bg-bg/50 text-ink/70">
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Order Quantity</label>
        <input type="number" id="restockQty" min="1" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary">
      </div>
      <div class="mt-6 flex justify-end gap-3">
        <button type="button" onclick="toggleModal('restockModal')" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg">Cancel</button>
        <button type="submit" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-medium hover:bg-primarydk transition">Send to Vendor</button>
      </div>
    </form>
  </div>
</div>

<%@ include file="includes/footer.jspf" %>
