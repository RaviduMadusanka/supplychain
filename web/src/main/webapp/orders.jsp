<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Orders";
  String pageSubtitle = "3 orders \u00b7 $15,990.75 total value";
  String activePage = "orders";
  String userName = "Saman Kumara";
  String userRole = "Warehouse Manager";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="flex items-center justify-between mb-5">
    <div class="flex items-center gap-1 p-1 bg-line/50 rounded-lg text-xs font-mono uppercase">
      <button onclick="filterOrders('All', this)" class="order-tab px-3 py-1.5 rounded-md bg-white shadow-sm font-semibold">All</button>
      <button onclick="filterOrders('Processing', this)" class="order-tab px-3 py-1.5 rounded-md text-ink/50">Processing</button>
      <button onclick="filterOrders('Shipped', this)" class="order-tab px-3 py-1.5 rounded-md text-ink/50">Shipped</button>
      <button onclick="filterOrders('Delivered', this)" class="order-tab px-3 py-1.5 rounded-md text-ink/50">Delivered</button>
    </div>
    <button onclick="toggleModal('createOrderModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition">+ Create Order</button>
  </div>

  <div class="card overflow-hidden">
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
        <th class="px-5 py-3 font-medium">Order</th><th class="px-5 py-3 font-medium">Customer</th><th class="px-5 py-3 font-medium">Vendor</th><th class="px-5 py-3 font-medium">Total</th><th class="px-5 py-3 font-medium">Created</th><th class="px-5 py-3 font-medium">Status</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr class="order-row hover:bg-bg/60 cursor-pointer" data-status="Processing">
          <td class="px-5 py-3.5 font-mono text-xs">ORD-20260701-001</td><td class="px-5 py-3.5">Colombo Retail Hub</td><td class="px-5 py-3.5 text-ink/60">Apex Tech Components</td><td class="px-5 py-3.5 font-mono">$4,250.00</td><td class="px-5 py-3.5 text-xs text-ink/40 font-mono">01 Jul 09:15</td><td class="px-5 py-3.5"><span class="tag tag-blue"><span class="tag-dot"></span>Processing</span></td>
        </tr>
        <tr class="order-row hover:bg-bg/60 cursor-pointer" data-status="Shipped">
          <td class="px-5 py-3.5 font-mono text-xs">ORD-20260705-002</td><td class="px-5 py-3.5">Nordic Trading Co</td><td class="px-5 py-3.5 text-ink/60">Global Parts Ltd</td><td class="px-5 py-3.5 font-mono">$8,760.50</td><td class="px-5 py-3.5 text-xs text-ink/40 font-mono">05 Jul 14:30</td><td class="px-5 py-3.5"><span class="tag tag-slate"><span class="tag-dot"></span>Shipped</span></td>
        </tr>
        <tr class="order-row hover:bg-bg/60 cursor-pointer" data-status="Delivered">
          <td class="px-5 py-3.5 font-mono text-xs">ORD-20260710-003</td><td class="px-5 py-3.5">Dubai Import Partners</td><td class="px-5 py-3.5 text-ink/60">Pacific Freight Supplies</td><td class="px-5 py-3.5 font-mono">$1,980.25</td><td class="px-5 py-3.5 text-xs text-ink/40 font-mono">10 Jul 11:00</td><td class="px-5 py-3.5"><span class="tag tag-teal"><span class="tag-dot"></span>Delivered</span></td>
        </tr>
      </tbody>
    </table>
  </div>

  <!-- expanded order detail example -->
  <div class="card mt-6">
    <div class="px-5 py-4 border-b border-line flex items-center justify-between">
      <div><h3 class="font-display font-semibold text-sm">Order ORD-20260701-001</h3><p class="text-xs text-ink/40 mt-0.5">Colombo Retail Hub &middot; Apex Tech Components</p></div>
      <span class="tag tag-blue"><span class="tag-dot"></span>Processing</span>
    </div>
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
        <th class="px-5 py-2.5 font-medium">Product</th><th class="px-5 py-2.5 font-medium">SKU</th><th class="px-5 py-2.5 font-medium">Qty</th><th class="px-5 py-2.5 font-medium">Unit Price</th><th class="px-5 py-2.5 font-medium text-right">Line Total</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr><td class="px-5 py-3">Industrial Circuit Board</td><td class="px-5 py-3 font-mono text-xs text-ink/50">SKU-1001</td><td class="px-5 py-3 font-mono">50</td><td class="px-5 py-3 font-mono">$85.00</td><td class="px-5 py-3 font-mono text-right">$4,250.00</td></tr>
      </tbody>
      <tfoot><tr class="border-t border-line"><td colspan="4" class="px-5 py-3 text-right text-sm font-semibold">Order Total</td><td class="px-5 py-3 font-mono text-right font-semibold">$4,250.00</td></tr></tfoot>
    </table>
  </div>

<script>
function filterOrders(status, btn) {
  // Update tabs UI
  document.querySelectorAll('.order-tab').forEach(b => {
    b.classList.remove('bg-white', 'shadow-sm', 'font-semibold');
    b.classList.add('text-ink/50');
  });
  btn.classList.remove('text-ink/50');
  btn.classList.add('bg-white', 'shadow-sm', 'font-semibold');

  // Filter rows
  const rows = document.querySelectorAll('.order-row');
  rows.forEach(row => {
    if (status === 'All' || row.dataset.status === status) {
      row.style.display = '';
    } else {
      row.style.display = 'none';
    }
  });
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

<!-- Create Order Modal -->
<div id="createOrderModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-sm">
  <div class="bg-white rounded-xl shadow-xl border border-line w-full max-w-lg p-6">
    <div class="flex items-center justify-between mb-4">
      <h3 class="font-display font-semibold text-lg">Create New Order</h3>
      <button onclick="toggleModal('createOrderModal')" class="text-ink/50 hover:text-ink">&times;</button>
    </div>
    <form class="space-y-4">
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1">Customer</label>
          <select class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary bg-white">
            <option>Colombo Retail Hub</option>
            <option>Nordic Trading Co</option>
          </select>
        </div>
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1">Vendor</label>
          <select class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary bg-white">
            <option>Apex Tech Components</option>
            <option>Global Parts Ltd</option>
          </select>
        </div>
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Products</label>
        <div class="border border-line rounded-lg p-3 bg-bg/50 text-sm text-ink/60 text-center">
           Product selection UI will go here
        </div>
      </div>
      <div class="mt-6 flex justify-end gap-3">
        <button type="button" onclick="toggleModal('createOrderModal')" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg">Cancel</button>
        <button type="button" onclick="toggleModal('createOrderModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-medium hover:bg-primarydk transition">Confirm Order</button>
      </div>
    </form>
  </div>
</div>
<%@ include file="includes/footer.jspf" %>
