<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Checkout :: NexTrade SCM</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = { theme: { extend: { colors: {
    ink:'#12172B', sidebar:'#0B1220', primary:'#2547D0', primarydk:'#1B34A6', teal:'#0EA5A4', amber:'#E0572B', line:'#E4E7EF', bg:'#F5F6FA'
  }, fontFamily: { display:['"Space Grotesk"','sans-serif'], body:['Inter','sans-serif'], mono:['"JetBrains Mono"','monospace'] } } } }
</script>
<style>
  body{ font-family:'Inter',sans-serif; } .font-display{ font-family:'Space Grotesk',sans-serif; } .font-mono{ font-family:'JetBrains Mono',monospace; }
  .card{ background:#fff; border:1px solid #E4E7EF; border-radius:10px; }
  .step-dot{ width:8px; height:8px; border-radius:50%; background:#E4E7EF; }
  .step-dot.done{ background:#0EA5A4; }
  .step-dot.active{ background:#2547D0; }
  @keyframes spin { to { transform: rotate(360deg); } }
  .spinner{ animation: spin 0.8s linear infinite; }
</style>
</head>
<body class="bg-bg text-ink">
<header class="h-16 bg-white border-b border-line flex items-center px-8">
  <div class="w-8 h-8 rounded-md bg-primary flex items-center justify-center font-display font-bold text-white text-sm mr-2">N</div>
  <span class="font-display font-semibold">NexTrade SCM</span><span class="ml-2 text-xs text-ink/40 font-mono">CUSTOMER PORTAL</span>
</header>

<main class="max-w-2xl mx-auto p-8">

  <!-- STEP 1: order form -->
  <div id="orderForm">
    <a href="catalog.jsp" class="text-xs text-primary font-medium hover:underline">&larr; Back to catalog</a>
    <h1 class="font-display text-2xl font-semibold mt-3 mb-6">Confirm your order</h1>

    <div class="card p-6 mb-6">
      <div class="flex items-center justify-between mb-1">
        <div>
          <div id="productName" class="font-medium text-sm">Industrial Circuit Board</div>
          <div id="productSku" class="font-mono text-xs text-ink/40 mt-0.5">SKU-1001 &middot; Colombo Central Warehouse</div>
        </div>
        <div id="unitPrice" class="font-display text-lg font-semibold" data-price="85.00">$85.00</div>
      </div>

      <div class="flex items-center justify-between pt-5 mt-5 border-t border-line">
        <span class="text-sm text-ink/60">Quantity</span>
        <div class="flex items-center gap-3">
          <button onclick="changeQty(-1)" class="w-8 h-8 rounded-lg border border-line text-ink/60 hover:bg-bg">&minus;</button>
          <span id="qtyDisplay" class="font-mono text-sm w-8 text-center">1</span>
          <button onclick="changeQty(1)" class="w-8 h-8 rounded-lg border border-line text-ink/60 hover:bg-bg">+</button>
        </div>
      </div>

      <div class="flex items-center justify-between pt-4 mt-4 border-t border-line">
        <span class="text-sm font-semibold">Order Total</span>
        <span id="orderTotal" class="font-display text-xl font-semibold text-primary">$85.00</span>
      </div>
    </div>

    <div class="card p-6 mb-6">
      <h3 class="font-medium text-sm mb-4">Delivery Address</h3>
      <textarea rows="2" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30">45 Galle Road, Colombo 03, Sri Lanka</textarea>
    </div>

    <div class="card p-4 mb-6 bg-primsoft bg-[#EAEEFC] border-primary/20">
      <p class="text-xs text-ink/60 leading-relaxed">
        <strong class="text-ink">How this is processed:</strong> placing this order runs as a single
        <span class="font-mono text-primary">Bean-Managed Transaction</span> on the server &mdash;
        the stock reservation on <span class="font-mono">inventory_stock</span> and the new
        <span class="font-mono">orders</span> / <span class="font-mono">order_items</span> rows either
        all commit together, or all roll back together if stock isn't available.
      </p>
    </div>

    <button onclick="placeOrder()" class="w-full py-3 rounded-lg bg-primary hover:bg-primarydk transition text-white text-sm font-semibold shadow-sm shadow-primary/30">
      Place Order
    </button>
  </div>

  <!-- STEP 2: processing animation -->
  <div id="processingView" class="hidden text-center py-16">
    <svg class="spinner w-10 h-10 text-primary mx-auto mb-6" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
    <div id="processingLabel" class="font-display text-lg font-semibold mb-6">Reserving stock&hellip;</div>
    <div class="flex items-center justify-center gap-2">
      <span id="dot1" class="step-dot active"></span>
      <span id="dot2" class="step-dot"></span>
      <span id="dot3" class="step-dot"></span>
    </div>
    <p class="text-xs text-ink/40 mt-4 font-mono">Bean-Managed Transaction in progress &mdash; do not close this tab</p>
  </div>

  <!-- STEP 3: confirmation -->
  <div id="successView" class="hidden text-center py-12">
    <div class="w-16 h-16 rounded-full bg-tealsoft bg-[#E3F7F6] text-teal flex items-center justify-center mx-auto mb-6">
      <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
    </div>
    <h2 class="font-display text-2xl font-semibold mb-2">Order placed</h2>
    <p class="text-sm text-ink/50 mb-1">Transaction committed successfully.</p>
    <p id="orderCodeDisplay" class="font-mono text-sm text-primary mb-8">ORD-20260817-004</p>

    <div class="card p-5 mb-8 text-left max-w-sm mx-auto">
      <div class="flex justify-between text-sm mb-2"><span class="text-ink/50">Product</span><span id="successProduct" class="font-medium">Industrial Circuit Board</span></div>
      <div class="flex justify-between text-sm mb-2"><span class="text-ink/50">Quantity</span><span id="successQty" class="font-mono">1</span></div>
      <div class="flex justify-between text-sm pt-2 border-t border-line mt-2"><span class="font-semibold">Total Paid</span><span id="successTotal" class="font-mono font-semibold">$85.00</span></div>
    </div>

    <div class="flex gap-3 justify-center">
      <a href="dashboard-customer.jsp" class="px-5 py-2.5 rounded-lg bg-primary text-white text-sm font-semibold">View My Orders</a>
      <a href="catalog.jsp" class="px-5 py-2.5 rounded-lg border border-line text-sm font-semibold">Continue Shopping</a>
    </div>
  </div>

</main>

<script>
  var products = {
    'SKU-1001': { name: 'Industrial Circuit Board', warehouse: 'Colombo Central Warehouse', price: 85.00 },
    'SKU-1002': { name: 'Steel Cargo Container Lock', warehouse: 'Singapore Regional Hub', price: 29.20 },
    'SKU-1003': { name: 'Packaging Wrap Roll 500m', warehouse: 'Dubai Logistics Park', price: 49.50 }
  };

  var params = new URLSearchParams(window.location.search);
  var sku = params.get('sku') || 'SKU-1001';
  var product = products[sku] || products['SKU-1001'];
  var qty = 1;

  document.getElementById('productName').textContent = product.name;
  document.getElementById('productSku').textContent = sku + ' \u00b7 ' + product.warehouse;
  document.getElementById('unitPrice').textContent = '$' + product.price.toFixed(2);

  function updateTotal() {
    document.getElementById('qtyDisplay').textContent = qty;
    document.getElementById('orderTotal').textContent = '$' + (product.price * qty).toFixed(2);
  }
  function changeQty(delta) {
    qty = Math.max(1, qty + delta);
    updateTotal();
  }

  function placeOrder() {
    document.getElementById('orderForm').classList.add('hidden');
    document.getElementById('processingView').classList.remove('hidden');

    var steps = ['Reserving stock\u2026', 'Charging payment\u2026', 'Confirming order\u2026'];
    var dots = ['dot1','dot2','dot3'];
    var i = 0;
    document.getElementById('processingLabel').textContent = steps[0];

    var interval = setInterval(function () {
      document.getElementById(dots[i]).classList.remove('active');
      document.getElementById(dots[i]).classList.add('done');
      i++;
      if (i < steps.length) {
        document.getElementById(dots[i]).classList.add('active');
        document.getElementById('processingLabel').textContent = steps[i];
      } else {
        clearInterval(interval);
        setTimeout(showSuccess, 500);
      }
    }, 900);
  }

  function showSuccess() {
    document.getElementById('processingView').classList.add('hidden');
    document.getElementById('successView').classList.remove('hidden');
    document.getElementById('successProduct').textContent = product.name;
    document.getElementById('successQty').textContent = qty;
    document.getElementById('successTotal').textContent = '$' + (product.price * qty).toFixed(2);
    var code = 'ORD-' + new Date().toISOString().slice(0,10).replace(/-/g,'') + '-' + Math.floor(100 + Math.random()*900);
    document.getElementById('orderCodeDisplay').textContent = code;
  }

  updateTotal();
</script>
</body>
</html>
