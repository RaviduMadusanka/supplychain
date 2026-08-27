<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
  com.globaltrade.core.dto.UserDTO sessionUser = (com.globaltrade.core.dto.UserDTO) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Browse Products & Catalog :: NexTrade SCM</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          ink:'#12172B', bg:'#F5F6FA', line:'#E4E7EF',
          primary:'#2547D0', primarydk:'#1B34A6', teal:'#0EA5A4', amber:'#E0572B',
          primsoft:'#EAEEFC', tealsoft:'#E3F7F6', ambersoft:'#FDECE4'
        },
        fontFamily: {
          display: ['"Space Grotesk"', 'sans-serif'],
          body: ['Inter', 'sans-serif'],
          mono: ['"JetBrains Mono"', 'monospace']
        }
      }
    }
  }
</script>
<style>
  body{ font-family:'Inter',sans-serif; background:#F5F6FA; color:#12172B; padding-bottom:120px; }
  .font-display{ font-family:'Space Grotesk',sans-serif; }
  .font-mono{ font-family:'JetBrains Mono',monospace; }
  .card{ background:#fff; border:1px solid #E4E7EF; border-radius:16px; transition:0.2s; }
  .card:hover{ border-color:#2547D0; box-shadow:0 10px 25px rgba(37,71,208,0.07); transform:translateY(-2px); }
  
  .tag{ display:inline-flex; align-items:center; gap:.4rem; padding:.25rem .65rem; border-radius:6px; font-family:'JetBrains Mono',monospace; font-size:.70rem; font-weight:600; }
  .tag-dot{ width:6px; height:6px; border-radius:50%; }
  .tag-teal{ background:#E3F7F6; color:#0B6E6D; } .tag-teal .tag-dot{ background:#0EA5A4; }
  .tag-amber{ background:#FDECE4; color:#A63D1B; } .tag-amber .tag-dot{ background:#E0572B; }
  .tag-slate{ background:#EEF0F5; color:#525A72; } .tag-slate .tag-dot{ background:#8A93AC; }
  .tag-blue{ background:#EAEEFC; color:#1B34A6; } .tag-blue .tag-dot{ background:#2547D0; }
</style>
</head>
<body>

<header class="h-16 bg-white border-b border-line flex items-center justify-between px-6 md:px-10 sticky top-0 z-40 shadow-xs">
  <div class="flex items-center gap-8">
    <a href="${pageContext.request.contextPath}/customer/browse" class="flex items-center gap-2.5">
      <div class="w-8 h-8 rounded-lg bg-primary flex items-center justify-center font-display font-bold text-white text-sm shadow-sm shadow-primary/30">N</div>
      <div class="flex flex-col">
        <span class="font-display font-bold text-sm text-ink leading-tight">NexTrade SCM</span>
        <span class="font-mono text-[9px] text-primary font-semibold tracking-wider">CUSTOMER STOREFRONT</span>
      </div>
    </a>
    <nav class="hidden md:flex gap-6">
      <a href="${pageContext.request.contextPath}/customer/browse" class="text-sm font-bold text-primary border-b-2 border-primary py-5">Browse Products</a>
      <a href="${pageContext.request.contextPath}/dashboard/customer" class="text-sm font-medium text-ink/60 hover:text-ink transition py-5 border-b-2 border-transparent">My Orders &amp; Tracking</a>
    </nav>
  </div>
  <div class="flex items-center gap-5">
    <div class="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-bg border border-line">
      <div class="w-6 h-6 rounded-lg bg-primsoft text-primary flex items-center justify-center font-display text-xs font-bold">
        <%= sessionUser != null && sessionUser.getFullName() != null && !sessionUser.getFullName().isEmpty() ? sessionUser.getFullName().substring(0, 1) : "C" %>
      </div>
      <span class="text-xs font-semibold text-ink"><%= sessionUser != null ? sessionUser.getFullName() : "Customer" %></span>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="text-xs font-semibold text-ink/50 hover:text-amber transition">Sign out</a>
  </div>
</header>

<main class="max-w-6xl mx-auto px-6 py-8">
  <c:if test="${not empty param.error}">
    <div class="mb-6 p-4 rounded-xl bg-amber/10 border border-amber/30 text-amber flex items-center justify-between text-sm font-medium">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
        <span>${param.error}</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-amber/60 hover:text-amber text-lg">&times;</button>
    </div>
  </c:if>

  <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
    <div>
      <h1 class="font-display text-2xl font-bold text-ink mb-1">Global Trade Catalog</h1>
      <p class="text-xs text-ink/50">Direct inventory dispatch across Colombo Central, Singapore Hub &amp; Dubai Logistics</p>
    </div>
    <div class="flex items-center gap-3">
      <select id="categoryFilter" onchange="filterCatalog()" class="px-3.5 py-2.5 border border-line rounded-xl text-xs font-semibold bg-white text-ink/80 focus:border-primary focus:outline-none">
        <option value="ALL">All Categories</option>
        <c:forEach var="cat" items="${categories}">
          <option value="${cat.name}">${cat.name}</option>
        </c:forEach>
      </select>
      <div class="relative">
        <svg class="w-4 h-4 absolute left-3.5 top-3 text-ink/40" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
        <input type="text" id="catalogSearch" onkeyup="filterCatalog()" placeholder="Search SKU, name..." class="pl-9 pr-4 py-2.5 border border-line rounded-xl text-xs bg-white focus:border-primary focus:outline-none w-56">
      </div>
    </div>
  </div>

  <div id="catalogGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <c:choose>
      <c:when test="${not empty stocks}">
        <c:forEach var="s" items="${stocks}">
          <div class="card p-6 flex flex-col h-full product-card" 
               data-id="${s.itemId}" 
               data-sku="${s.itemSku}" 
               data-name="${s.productName}" 
               data-category="${s.categoryName}" 
               data-price="${s.unitPrice != null ? s.unitPrice : 50.00}" 
               data-stock="${s.stockQty != null ? s.stockQty : 0}">
            
            <div class="flex justify-between items-start mb-3">
              <span class="px-2.5 py-1 rounded-md bg-bg text-ink/70 border border-line text-[11px] font-semibold uppercase tracking-wider">${s.categoryName != null ? s.categoryName : 'General'}</span>
              <span class="font-mono text-xs text-ink/40 font-semibold">${s.itemSku}</span>
            </div>

            <h3 class="font-display font-bold text-base text-ink mb-1 leading-snug">${s.productName}</h3>
            <p class="text-xs text-ink/50 mb-4 font-mono">Hub: ${s.warehouseName != null ? s.warehouseName : 'Global Central'}</p>

            <div class="mt-auto pt-4 border-t border-line">
              <div class="flex items-baseline justify-between mb-3">
                <div>
                  <span class="text-xs text-ink/40 block">Unit Price</span>
                  <span class="font-display font-bold text-xl text-ink">$<fmt:formatNumber value="${s.unitPrice != null ? s.unitPrice : 50.00}" minFractionDigits="2" maxFractionDigits="2" /></span>
                </div>
                <div>
                  <c:choose>
                    <c:when test="${s.stockQty > 20}">
                      <span class="tag tag-teal"><span class="tag-dot"></span>In Stock (${s.stockQty})</span>
                    </c:when>
                    <c:when test="${s.stockQty > 0}">
                      <span class="tag tag-amber"><span class="tag-dot"></span>Low Stock (${s.stockQty})</span>
                    </c:when>
                    <c:otherwise>
                      <span class="tag tag-slate"><span class="tag-dot"></span>Out of Stock</span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>

              <div class="flex gap-2">
                <button type="button" onclick="addToCartFromBtn(this)" 
                        class="flex-1 py-2.5 rounded-xl border border-line bg-white hover:bg-bg text-ink/80 text-xs font-bold transition flex items-center justify-center gap-1.5 shadow-xs <c:if test='${s.stockQty <= 0}'>opacity-50 cursor-not-allowed</c:if>"
                        <c:if test='${s.stockQty <= 0}'>disabled</c:if>>
                  <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
                  + Add to Cart
                </button>
                <button type="button" onclick="buyNowFromBtn(this)" 
                        class="px-4 py-2.5 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primarydk transition shadow-sm shadow-primary/20 <c:if test='${s.stockQty <= 0}'>opacity-50 cursor-not-allowed</c:if>"
                        <c:if test='${s.stockQty <= 0}'>disabled</c:if>>
                  Order
                </button>
              </div>
            </div>

          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <div class="col-span-3 card p-12 text-center text-ink/50 text-sm">
          No inventory products currently listed. Check back shortly.
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</main>

<div id="cartBar" class="hidden fixed bottom-0 left-0 right-0 z-50 bg-ink text-white border-t border-ink/20 shadow-2xl px-6 py-4">
  <div class="max-w-6xl mx-auto flex items-center justify-between">
    <div class="flex items-center gap-4">
      <div class="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center text-teal">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
      </div>
      <div>
        <div class="font-display font-bold text-sm text-white" id="cartCountLabel">0 Items in Cart</div>
        <div class="text-xs text-white/60 font-mono" id="cartSubtotalLabel">Subtotal: $0.00</div>
      </div>
    </div>
    <div class="flex items-center gap-3">
      <button onclick="clearCart()" class="px-3.5 py-2 rounded-xl text-xs font-semibold text-white/60 hover:text-white transition">Clear</button>
      <button onclick="openCheckoutModal()" class="px-5 py-2.5 rounded-xl bg-primary hover:bg-primarydk text-white text-xs font-bold shadow-lg shadow-primary/30 flex items-center gap-2 transition">
        Proceed to Checkout &rarr;
      </button>
    </div>
  </div>
</div>

<div id="checkoutModal" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-ink/60 backdrop-blur-xs p-4">
  <div class="bg-white rounded-2xl p-6 w-full max-w-xl shadow-2xl border border-line flex flex-col max-h-[90vh] overflow-hidden">
    <div class="flex justify-between items-center pb-4 border-b border-line">
      <div>
        <h3 class="font-display font-bold text-base text-ink">Customer Order &amp; Customs Checkout</h3>
        <p class="text-xs text-ink/40 font-mono">Dynamic cross-border tariff &amp; VAT computation</p>
      </div>
      <button onclick="toggleModal('checkoutModal')" class="text-ink/40 hover:text-ink text-xl">&times;</button>
    </div>

    <form action="${pageContext.request.contextPath}/customer/order/create" method="POST" id="checkoutOrderForm" onsubmit="return validateOrderForm()" class="space-y-4 pt-4 overflow-y-auto pr-1">
      <div id="cartItemsContainer" class="space-y-2">
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-3 pt-2">
        <div>
          <label class="block text-xs font-mono uppercase text-ink/60 mb-1">Destination Country *</label>
          <select name="countryId" id="destCountrySelect" onchange="recalculateTotals()" required class="w-full px-3.5 py-2 rounded-xl border border-line text-xs font-semibold bg-white focus:border-primary focus:outline-none">
            <c:forEach var="c" items="${countries}">
              <option value="${c.id}" data-vat="${c.vatPercentage}" data-tariff="${c.importTaxPercentage}">${c.name} &middot; VAT ${c.vatPercentage}% + Tariff ${c.importTaxPercentage}%</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="block text-xs font-mono uppercase text-ink/60 mb-1">Delivery Address *</label>
          <input type="text" name="deliveryAddress" required value="Colombo 03, Western Province, Sri Lanka" class="w-full px-3.5 py-2 rounded-xl border border-line text-xs focus:border-primary focus:outline-none" />
        </div>
      </div>

      <div class="p-4 rounded-xl bg-bg border border-line space-y-2 text-xs">
        <div class="flex justify-between text-ink/70">
          <span>Items Subtotal:</span>
          <span class="font-mono font-semibold text-ink" id="checkoutSubtotal">$0.00</span>
        </div>
        <div class="flex justify-between text-ink/70">
          <span>Cross-Border Customs (VAT + Tariff):</span>
          <span class="font-mono font-semibold text-teal" id="checkoutTaxes">$0.00</span>
        </div>
        <div class="flex justify-between text-ink/70">
          <span>Flat Freight &amp; Handling:</span>
          <span class="font-mono font-semibold text-ink">$25.00</span>
        </div>
        <div class="flex justify-between pt-2 border-t border-line font-bold text-sm text-ink">
          <span>Estimated Total Payable:</span>
          <span class="font-mono text-primary font-bold text-base" id="checkoutGrandTotal">$0.00</span>
        </div>
      </div>

      <div class="flex justify-end gap-2 pt-2 border-t border-line">
        <button type="button" onclick="toggleModal('checkoutModal')" class="px-4 py-2.5 rounded-xl border border-line text-xs font-semibold text-ink/70 hover:bg-bg">Cancel</button>
        <button type="submit" class="px-6 py-2.5 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primarydk shadow-sm shadow-primary/20">Confirm &amp; Place Order</button>
      </div>
    </form>
  </div>
</div>

<script>
  let cart = {};

  function filterCatalog() {
    const q = (document.getElementById('catalogSearch').value || '').toLowerCase();
    const cat = document.getElementById('categoryFilter').value;
    document.querySelectorAll('.product-card').forEach(c => {
      const name = (c.dataset.name || '').toLowerCase();
      const sku = (c.dataset.sku || '').toLowerCase();
      const cCat = c.dataset.category || '';
      const matchQ = !q || name.includes(q) || sku.includes(q);
      const matchCat = (cat === 'ALL') || (cCat === cat);
      c.style.display = (matchQ && matchCat) ? 'flex' : 'none';
    });
  }

  function addToCartFromBtn(btn) {
    const card = btn.closest('.product-card');
    if (!card) return;
    const id = parseInt(card.dataset.id);
    const sku = card.dataset.sku || 'SKU';
    const name = card.dataset.name || 'Product';
    const price = parseFloat(card.dataset.price) || 50.0;
    const stock = parseInt(card.dataset.stock) || 0;

    if (stock <= 0) {
      alert('This item is currently out of stock.');
      return;
    }

    if (!cart[id]) {
      cart[id] = { id, sku, name, price, qty: 1, maxStock: stock };
    } else {
      if (cart[id].qty < cart[id].maxStock) {
        cart[id].qty++;
      } else {
        alert('Cannot add more than available stock (' + cart[id].maxStock + ').');
      }
    }
    updateCartUI();
  }

  function buyNowFromBtn(btn) {
    addToCartFromBtn(btn);
    openCheckoutModal();
  }

  function updateCartUI() {
    const ids = Object.keys(cart);
    let totalItems = 0;
    let subtotal = 0.0;
    ids.forEach(id => {
      totalItems += cart[id].qty;
      subtotal += (cart[id].price * cart[id].qty);
    });

    const bar = document.getElementById('cartBar');
    if (totalItems > 0) {
      bar.classList.remove('hidden');
      document.getElementById('cartCountLabel').innerText = totalItems + (totalItems === 1 ? ' Item in Cart' : ' Items in Cart');
      document.getElementById('cartSubtotalLabel').innerText = 'Subtotal: $' + subtotal.toFixed(2);
    } else {
      bar.classList.add('hidden');
    }
  }

  function clearCart() {
    cart = {};
    updateCartUI();
  }

  function openCheckoutModal() {
    const container = document.getElementById('cartItemsContainer');
    container.innerHTML = '';
    const ids = Object.keys(cart);
    if (ids.length === 0) {
      alert('Cart is empty. Please select products first.');
      return;
    }

    ids.forEach(id => {
      const item = cart[id];
      const div = document.createElement('div');
      div.className = 'flex items-center justify-between p-3 rounded-xl bg-bg border border-line text-xs';
      var priceStr = parseFloat(item.price).toFixed(2);
      var lineTotalStr = (parseFloat(item.price) * item.qty).toFixed(2);
      div.innerHTML =
        '<input type="hidden" name="itemIds" value="' + item.id + '" />' +
        '<div class="flex-1">' +
          '<div class="font-bold text-ink">' + item.name + '</div>' +
          '<div class="font-mono text-ink/40">' + item.sku + ' &middot; $' + priceStr + ' each</div>' +
        '</div>' +
        '<div class="flex items-center gap-2">' +
          '<label class="text-ink/60 font-mono">Qty:</label>' +
          '<input type="number" name="qty_' + item.id + '" min="1" max="' + item.maxStock + '" value="' + item.qty + '" onchange="changeQty(' + item.id + ', this.value)" class="w-16 px-2 py-1 border border-line rounded-lg text-center font-mono text-xs focus:border-primary focus:outline-none" />' +
          '<span class="font-mono font-bold text-ink ml-2">$' + lineTotalStr + '</span>' +
        '</div>';
      container.appendChild(div);
    });

    recalculateTotals();
    const modal = document.getElementById('checkoutModal');
    modal.classList.remove('hidden');
  }

  function changeQty(id, val) {
    const qty = parseInt(val) || 1;
    if (cart[id]) {
      cart[id].qty = Math.min(qty, cart[id].maxStock);
    }
    updateCartUI();
    recalculateTotals();
  }

  function recalculateTotals() {
    let subtotal = 0.0;
    Object.keys(cart).forEach(id => {
      subtotal += (cart[id].price * cart[id].qty);
    });

    const countrySelect = document.getElementById('destCountrySelect');
    let vat = 15.0;
    let tariff = 10.0;
    if (countrySelect && countrySelect.selectedIndex >= 0) {
      const opt = countrySelect.options[countrySelect.selectedIndex];
      vat = parseFloat(opt.dataset.vat) || 0.0;
      tariff = parseFloat(opt.dataset.tariff) || 0.0;
    }

    const taxes = subtotal * ((vat + tariff) / 100.0);
    const shipping = 25.00;
    const grandTotal = subtotal + taxes + shipping;

    document.getElementById('checkoutSubtotal').innerText = '$' + subtotal.toFixed(2);
    document.getElementById('checkoutTaxes').innerText = '$' + taxes.toFixed(2) + ' (' + (vat + tariff) + '%)';
    document.getElementById('checkoutGrandTotal').innerText = '$' + grandTotal.toFixed(2);
  }

  function validateOrderForm() {
    const ids = Object.keys(cart);
    if (ids.length === 0) {
      alert('Cart is empty. Please add items to cart before placing an order.');
      return false;
    }
    return true;
  }

  function toggleModal(id) {
    const modal = document.getElementById(id);
    if (modal) modal.classList.toggle('hidden');
  }
</script>

</body>
</html>