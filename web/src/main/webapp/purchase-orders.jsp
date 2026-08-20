<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  String pageTitle = "Inbound Restocking & Purchase Orders";
  String pageSubtitle = "Procure stock from global suppliers and manage inbound warehouse inventory";
  String activePage = "purchaseorders";
  String userName = "Warehouse Operations";
  String userRole = "WAREHOUSE_MANAGER";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<script>
  window.filterPOs = function(status, btn) {
    document.querySelectorAll('.po-tab').forEach(function(b) {
      b.classList.remove('bg-white', 'shadow-sm', 'font-semibold', 'text-ink');
      b.classList.add('text-ink/50');
    });
    if (btn) {
      btn.classList.remove('text-ink/50');
      btn.classList.add('bg-white', 'shadow-sm', 'font-semibold', 'text-ink');
    }
    var rows = document.querySelectorAll('.po-row');
    rows.forEach(function(row) {
      var rowStatus = row.dataset.status ? row.dataset.status.toUpperCase() : '';
      if (status === 'All') {
        row.style.display = '';
      } else if (status === 'PROCESSING' && (rowStatus === 'PROCESSING' || rowStatus === 'IN_TRANSIT')) {
        row.style.display = '';
      } else if (status === 'COMPLETED' && (rowStatus === 'COMPLETED' || rowStatus === 'DELIVERED')) {
        row.style.display = '';
      } else if (rowStatus === status) {
        row.style.display = '';
      } else {
        row.style.display = 'none';
      }
    });
  };

  window.toggleDetails = function(id) {
    var row = document.getElementById(id);
    if (!row) return;
    row.style.display = (row.style.display === 'none' || row.style.display === '') ? 'table-row' : 'none';
  };

  window.openCreatePOModal = function() {
    var modal = document.getElementById('createPOModal');
    if (modal) {
      modal.style.display = 'flex';
    } else {
      alert("Modal element #createPOModal not found");
    }
  };

  window.closeCreatePOModal = function() {
    var modal = document.getElementById('createPOModal');
    if (modal) {
      modal.style.display = 'none';
    }
  };

  window.toggleModal = function(id) {
    var m = document.getElementById(id);
    if (!m) return;
    if (m.style.display === 'none' || m.style.display === '') {
      m.style.display = 'flex';
    } else {
      m.style.display = 'none';
    }
  };

  window.addPOItemRow = function() {
    var container = document.getElementById('poItemsContainer');
    if (!container) return;
    var rows = container.querySelectorAll('.po-item-row');
    if (rows.length > 0) {
      var clone = rows[0].cloneNode(true);
      var select = clone.querySelector('select');
      var input = clone.querySelector('input');
      if (select) select.selectedIndex = 0;
      if (input) input.value = "50";
      container.appendChild(clone);
    }
  };

  window.removePOItemRow = function(btn) {
    var container = document.getElementById('poItemsContainer');
    if (!container) return;
    var rows = container.querySelectorAll('.po-item-row');
    if (rows.length > 1) {
      btn.closest('.po-item-row').remove();
    } else {
      alert("At least one product item is required in the Purchase Order.");
    }
  };

  document.addEventListener('DOMContentLoaded', function() {
    var createBtns = document.querySelectorAll('.btn-create-po');
    createBtns.forEach(function(btn) {
      btn.addEventListener('click', function(e) {
        e.preventDefault();
        window.openCreatePOModal();
      });
    });
  });
</script>

<div class="space-y-6">

  <!-- Feedback Alerts -->
  <c:if test="${not empty param.success}">
    <div class="p-4 rounded-xl bg-teal/10 border border-teal/20 text-teal flex items-center justify-between text-sm animate-in fade-in duration-200">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
        <span>${param.success}</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-teal/60 hover:text-teal">&times;</button>
    </div>
  </c:if>

  <c:if test="${not empty param.error}">
    <div class="p-4 rounded-xl bg-amber/10 border border-amber/20 text-amber flex items-center justify-between text-sm animate-in fade-in duration-200">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        <span>${param.error}</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-amber/60 hover:text-amber">&times;</button>
    </div>
  </c:if>

  <!-- Low Stock Alert Banner Strip (if any items need restocking) -->
  <c:if test="${not empty lowStocks}">
    <div class="p-5 rounded-2xl bg-gradient-to-r from-amber/10 via-amber/5 to-transparent border border-amber/20 flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div class="flex items-center gap-3.5">
        <div class="w-10 h-10 rounded-xl bg-amber/20 text-amber flex items-center justify-center flex-shrink-0">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
        </div>
        <div>
          <h4 class="text-sm font-semibold text-ink">Low Stock Warning &middot; ${lowStocks.size()} items need restocking</h4>
          <p class="text-xs text-ink/60 mt-0.5">Some items in your warehouses are below reorder threshold. Create a PO to restock immediately.</p>
        </div>
      </div>
      <button type="button" onclick="openCreatePOModal()" class="btn-create-po px-4 py-2 rounded-lg bg-amber text-white text-xs font-semibold hover:opacity-90 transition shadow-sm inline-flex items-center gap-1.5 flex-shrink-0 self-start md:self-auto">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
        Restock Now
      </button>
    </div>
  </c:if>

  <!-- Header Controls & Top Stats Strip -->
  <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
    
    <!-- Filter Tabs -->
    <div class="flex items-center gap-1 p-1 bg-ink/5 rounded-xl border border-line w-fit">
      <button type="button" onclick="filterPOs('All', this)" class="po-tab px-3.5 py-1.5 rounded-lg text-xs font-semibold bg-white text-ink shadow-sm transition">
        All POs (${purchaseOrders.size()})
      </button>
      <button type="button" onclick="filterPOs('PENDING', this)" class="po-tab px-3.5 py-1.5 rounded-lg text-xs font-medium text-ink/50 hover:text-ink transition">
        Pending
      </button>
      <button type="button" onclick="filterPOs('PROCESSING', this)" class="po-tab px-3.5 py-1.5 rounded-lg text-xs font-medium text-ink/50 hover:text-ink transition">
        In Transit
      </button>
      <button type="button" onclick="filterPOs('COMPLETED', this)" class="po-tab px-3.5 py-1.5 rounded-lg text-xs font-medium text-ink/50 hover:text-ink transition">
        Received
      </button>
    </div>

    <!-- Create PO Button -->
    <button type="button" onclick="openCreatePOModal()" class="btn-create-po px-4 py-2.5 rounded-xl bg-primary text-white text-xs font-semibold hover:bg-primarydk transition shadow-sm shadow-primary/20 inline-flex items-center gap-2 self-start sm:self-auto">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
      Create Purchase Order
    </button>
  </div>

  <!-- Purchase Orders Main Table -->
  <div class="bg-white rounded-2xl border border-line shadow-sm overflow-hidden">
    <table class="w-full text-sm">
      <thead>
        <tr class="text-left text-white/80 text-xs font-mono uppercase tracking-wider border-b border-ink bg-ink">
          <th class="px-5 py-3.5 font-medium">PO Code</th>
          <th class="px-5 py-3.5 font-medium">Destination WH</th>
          <th class="px-5 py-3.5 font-medium">Supplier / Vendor</th>
          <th class="px-5 py-3.5 font-medium">Items</th>
          <th class="px-5 py-3.5 font-medium">Cost &amp; Freight</th>
          <th class="px-5 py-3.5 font-medium">Order Date</th>
          <th class="px-5 py-3.5 font-medium">Status</th>
          <th class="px-5 py-3.5 font-medium text-right">Inbound Actions</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-line">
        <c:choose>
          <c:when test="${not empty purchaseOrders}">
            <c:forEach var="po" items="${purchaseOrders}">
              <tr class="po-row hover:bg-bg/40 transition" data-status="${po.statusName}">
                
                <!-- PO Code -->
                <td class="px-5 py-4">
                  <span class="font-mono font-bold text-xs text-primary">${po.poCode}</span>
                </td>

                <!-- Destination Warehouse -->
                <td class="px-5 py-4">
                  <div class="font-medium text-ink">${po.warehouseName}</div>
                  <div class="text-xs text-ink/40 font-mono">${po.warehouseCode} &middot; ${po.warehouseCountry}</div>
                </td>

                <!-- Vendor -->
                <td class="px-5 py-4">
                  <div class="font-medium text-ink">${po.vendorName}</div>
                  <div class="text-xs text-ink/40 font-mono">${po.vendorCode} <c:if test="${not empty po.vendorCountry}">(${po.vendorCountry})</c:if></div>
                </td>

                <!-- Items count -->
                <td class="px-5 py-4">
                  <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-bg border border-line text-xs font-mono">
                    <strong>${po.itemCount}</strong> units (${po.items.size()} SKU)
                  </span>
                </td>

                <!-- Cost & Taxes & Freight -->
                <td class="px-5 py-4">
                  <div class="font-mono font-bold text-ink text-sm">$${po.totalAmount}</div>
                  <div class="text-[11px] font-mono text-ink/50 mt-0.5">
                    <span>Sub: $${po.subtotal}</span>
                    <c:if test="${po.taxAmount > 0}">
                      &middot; <span class="text-amber font-medium">Tax: +$${po.taxAmount}</span>
                    </c:if>
                    <c:if test="${po.shippingAmount > 0}">
                      &middot; <span class="text-primary font-medium">Freight: +$${po.shippingAmount}</span>
                    </c:if>
                  </div>
                </td>

                <!-- Created Date -->
                <td class="px-5 py-4 text-xs font-mono text-ink/60">
                  ${po.createdAt}
                </td>

                <!-- Status Badge -->
                <td class="px-5 py-4">
                  <c:choose>
                    <c:when test="${po.statusName == 'PENDING'}">
                      <span class="tag tag-amber"><span class="tag-dot"></span>Pending Vendor</span>
                    </c:when>
                    <c:when test="${po.statusName == 'PROCESSING' || po.statusName == 'IN_TRANSIT'}">
                      <span class="tag" style="background:#EAEEFC; color:#1B34A6;"><span class="tag-dot" style="background:#2547D0;"></span>In Transit</span>
                    </c:when>
                    <c:when test="${po.statusName == 'COMPLETED'}">
                      <span class="tag tag-teal"><span class="tag-dot"></span>Stock Received</span>
                    </c:when>
                    <c:otherwise>
                      <span class="tag tag-slate"><span class="tag-dot"></span>${po.statusName}</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <!-- Actions -->
                <td class="px-5 py-4 text-right">
                  <div class="flex items-center justify-end gap-2">
                    
                    <!-- Toggle items drawer -->
                    <button type="button" onclick="toggleDetails('po-details-${po.id}')" class="px-2.5 py-1.5 rounded-lg border border-line text-xs font-medium hover:bg-bg transition text-ink/70">
                      View Items
                    </button>

                    <!-- Actions based on PO status -->
                    <c:choose>
                      
                      <%-- PENDING: Awaiting Vendor acceptance --%>
                      <c:when test="${po.statusName == 'PENDING'}">
                        <c:choose>
                          <c:when test="${sessionScope.user != null && sessionScope.user.role == 'VENDOR'}">
                            <form action="${pageContext.request.contextPath}/purchase-orders/action" method="POST" class="inline">
                              <input type="hidden" name="action" value="accept">
                              <input type="hidden" name="poId" value="${po.id}">
                              <button type="submit" class="px-3 py-1.5 rounded-lg bg-primary text-white text-xs font-semibold hover:bg-primarydk transition shadow-sm inline-flex items-center gap-1">
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                                Accept &amp; Dispatch
                              </button>
                            </form>
                          </c:when>
                          <c:otherwise>
                            <span class="text-xs text-amber font-mono inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-amber/10 border border-amber/20">
                              <span class="w-1.5 h-1.5 rounded-full bg-amber animate-pulse"></span>
                              Awaiting Vendor
                            </span>
                          </c:otherwise>
                        </c:choose>
                      </c:when>

                      <%-- PROCESSING / IN_TRANSIT: Vendor has dispatched goods -> WH Manager can Receive Stock --%>
                      <c:when test="${po.statusName == 'PROCESSING' || po.statusName == 'IN_TRANSIT'}">
                        <form action="${pageContext.request.contextPath}/purchase-orders/action" method="POST" class="inline">
                          <input type="hidden" name="action" value="receive">
                          <input type="hidden" name="poId" value="${po.id}">
                          <button type="submit" class="px-3 py-1.5 rounded-lg bg-teal text-white text-xs font-semibold hover:opacity-90 transition shadow-sm inline-flex items-center gap-1" onclick="return confirm('Confirm receipt of goods for ${po.poCode}? This will automatically add the stock to ${po.warehouseName}.')">
                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                            Receive Stock
                          </button>
                        </form>
                      </c:when>

                      <%-- COMPLETED: Stock received & added to inventory --%>
                      <c:when test="${po.statusName == 'COMPLETED'}">
                        <span class="text-xs text-teal font-semibold font-mono inline-flex items-center gap-1 px-2.5 py-1 rounded-md bg-teal/10 border border-teal/20">
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                          Restocked
                        </span>
                      </c:when>

                      <c:otherwise>
                        <span class="text-xs text-ink/40 font-mono">${po.statusName}</span>
                      </c:otherwise>

                    </c:choose>

                  </div>
                </td>

              </tr>

              <!-- Expandable Line Items Row -->
              <tr id="po-details-${po.id}" class="bg-bg/80 border-b border-line" style="display: none;">
                <td colspan="8" class="p-4">
                  <div class="bg-white p-4 rounded-xl border border-line shadow-inner max-w-4xl mx-auto">
                    <div class="flex items-center justify-between pb-3 mb-3 border-b border-line">
                      <div class="font-semibold text-xs text-ink uppercase tracking-wide font-mono">
                        Purchase Order Line Items &middot; ${po.poCode}
                      </div>
                      <div class="text-xs text-ink/50">
                        Restocking Destination: <strong class="text-ink">${po.warehouseName}</strong> (${po.warehouseCountry})
                      </div>
                    </div>

                    <table class="w-full text-xs">
                      <thead>
                        <tr class="text-left text-ink/50 border-b border-line">
                          <th class="pb-2 font-medium font-mono">SKU</th>
                          <th class="pb-2 font-medium">Product Name</th>
                          <th class="pb-2 font-medium text-center">Restock Qty</th>
                          <th class="pb-2 font-medium text-right font-mono">Unit Purchase Cost</th>
                          <th class="pb-2 font-medium text-right font-mono">Subtotal</th>
                        </tr>
                      </thead>
                      <tbody class="divide-y divide-line/60">
                        <c:forEach var="item" items="${po.items}">
                          <tr>
                            <td class="py-2.5 font-mono text-ink/70">${item.productSku}</td>
                            <td class="py-2.5 font-medium text-ink">${item.productName}</td>
                            <td class="py-2.5 text-center font-mono font-semibold text-teal">+${item.quantity}</td>
                            <td class="py-2.5 text-right font-mono text-ink/70">$${item.unitPrice}</td>
                            <td class="py-2.5 text-right font-mono font-bold text-ink">$${item.lineTotal}</td>
                          </tr>
                        </c:forEach>
                      </tbody>
                      <tfoot>
                        <tr class="border-t border-line text-xs text-ink/70">
                          <td colspan="4" class="pt-3 text-right font-medium">Goods Subtotal:</td>
                          <td class="pt-3 text-right font-mono font-semibold text-ink">$${po.subtotal}</td>
                        </tr>
                        <c:if test="${po.taxAmount > 0}">
                          <tr class="text-xs text-amber">
                            <td colspan="4" class="pt-1.5 text-right font-medium">
                              <c:choose>
                                <c:when test="${po.crossBorder && po.importTaxPercentage > 0}">
                                  VAT (${po.vatPercentage}%) + Customs Tariff (${po.importTaxPercentage}%) [${po.warehouseCountry}]:
                                </c:when>
                                <c:otherwise>
                                  VAT (${po.vatPercentage}%) [${po.warehouseCountry}]:
                                </c:otherwise>
                              </c:choose>
                            </td>
                            <td class="pt-1.5 text-right font-mono font-semibold">+$${po.taxAmount}</td>
                          </tr>
                        </c:if>
                        <c:if test="${po.shippingAmount > 0}">
                          <tr class="text-xs text-primary">
                            <td colspan="4" class="pt-1.5 text-right font-medium">
                              <c:choose>
                                <c:when test="${po.crossBorder}">
                                  International Freight &amp; Handling (Weight-based):
                                </c:when>
                                <c:otherwise>
                                  Domestic Freight &amp; Logistics:
                                </c:otherwise>
                              </c:choose>
                            </td>
                            <td class="pt-1.5 text-right font-mono font-semibold">+$${po.shippingAmount}</td>
                          </tr>
                        </c:if>
                        <tr class="border-t border-line font-bold text-xs">
                          <td colspan="4" class="pt-2.5 text-right text-ink">Total Procurement Cost:</td>
                          <td class="pt-2.5 text-right font-mono text-primary text-sm">$${po.totalAmount}</td>
                        </tr>
                      </tfoot>
                    </table>
                  </div>
                </td>
              </tr>

            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="8" class="p-12 text-center text-ink/50 text-sm">
                No purchase orders recorded yet. Click <strong>"+ Create Purchase Order"</strong> above to place a restock order to a supplier.
              </td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>

</div>

<!-- Create Purchase Order Modal — placed outside main/space-y-6 at body level -->
<div id="createPOModal" style="display:none; position:fixed; inset:0; z-index:9999; align-items:center; justify-content:center; background:rgba(18,23,43,0.6); backdrop-filter:blur(4px); padding:1rem;">
  <div style="background:#fff; border-radius:1rem; border:1px solid #E4E7EF; box-shadow:0 25px 50px rgba(0,0,0,0.25); width:100%; max-width:38rem; max-height:92vh; display:flex; flex-direction:column; overflow:hidden;">

    <div style="height:4rem; padding:0 1.5rem; border-bottom:1px solid #E4E7EF; display:flex; align-items:center; justify-content:space-between; background:#F5F6FA;">
      <div style="display:flex; align-items:center; gap:0.5rem;">
        <div style="width:2rem; height:2rem; border-radius:0.5rem; background:#EAEEFC; color:#2547D0; display:flex; align-items:center; justify-content:center;">
          <svg style="width:1rem;height:1rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
        </div>
        <div>
          <div style="font-weight:600; font-size:0.9rem; color:#12172B;">New Purchase Order</div>
          <div style="font-size:0.7rem; color:#12172B99; font-family:monospace;">Restock warehouse inventory from supplier</div>
        </div>
      </div>
      <button type="button" onclick="closeCreatePOModal()" style="color:#12172B66; background:none; border:none; cursor:pointer; padding:0.25rem; border-radius:0.5rem;">
        <svg style="width:1.25rem;height:1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
      </button>
    </div>

    <form action="${pageContext.request.contextPath}/purchase-orders/action" method="POST" style="padding:1.5rem; display:flex; flex-direction:column; gap:1rem; overflow-y:auto; max-height:calc(92vh - 4rem);">
      <input type="hidden" name="action" value="create">

      <div>
        <label style="display:block; font-size:0.65rem; font-weight:700; color:#12172BB3; margin-bottom:0.375rem; text-transform:uppercase; font-family:monospace;">Destination Warehouse *</label>
        <select name="warehouseId" required style="width:100%; padding:0.625rem 0.875rem; border:1px solid #E4E7EF; border-radius:0.5rem; font-size:0.875rem; background:#fff; outline:none;">
          <option value="">-- Select Receiving Warehouse --</option>
          <c:forEach var="w" items="${warehouses}">
            <option value="${w.id}">${w.name} (${w.warehouseCode}) &middot; ${w.countryName}</option>
          </c:forEach>
        </select>
      </div>

      <div>
        <label style="display:block; font-size:0.65rem; font-weight:700; color:#12172BB3; margin-bottom:0.375rem; text-transform:uppercase; font-family:monospace;">Supplier / Vendor *</label>
        <select name="vendorId" required style="width:100%; padding:0.625rem 0.875rem; border:1px solid #E4E7EF; border-radius:0.5rem; font-size:0.875rem; background:#fff; outline:none;">
          <option value="">-- Select Supplier --</option>
          <c:forEach var="v" items="${vendors}">
            <option value="${v.id}">${v.companyName} (${v.vendorCode})</option>
          </c:forEach>
        </select>
      </div>

      <!-- Products & Restock Quantities Dynamic List -->
      <div class="border border-line rounded-xl p-3.5 bg-bg/40">
        <div class="flex items-center justify-between mb-2.5 pb-2 border-b border-line">
          <div>
            <label class="block text-xs font-semibold text-ink uppercase font-mono">Restock Products List <span class="text-amber">*</span></label>
            <span class="text-[11px] text-ink/50">Add one or more products to this purchase order</span>
          </div>
          <button type="button" onclick="addPOItemRow()" class="px-2.5 py-1 rounded-lg bg-primary/10 text-primary hover:bg-primary hover:text-white text-xs font-semibold transition inline-flex items-center gap-1">
            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
            + Add Product
          </button>
        </div>

        <div id="poItemsContainer" class="space-y-2 max-h-48 overflow-y-auto pr-1">
          <!-- Item Row Template -->
          <div class="po-item-row flex items-center gap-2 bg-white p-2 rounded-lg border border-line">
            <div class="flex-1">
              <select name="productId" required class="w-full px-2.5 py-1.5 border border-line rounded-md text-xs bg-white focus:border-primary focus:outline-none">
                <option value="">-- Select Product --</option>
                <c:forEach var="p" items="${products}">
                  <option value="${p.id}">${p.name} (${p.sku}) &middot; ${p.weight}kg</option>
                </c:forEach>
              </select>
            </div>
            <div class="w-24">
              <input type="number" name="quantity" value="100" min="1" required class="w-full px-2.5 py-1.5 border border-line rounded-md text-xs bg-white font-mono focus:border-primary focus:outline-none" placeholder="Qty">
            </div>
            <button type="button" onclick="removePOItemRow(this)" class="p-1.5 text-ink/40 hover:text-amber rounded-md hover:bg-amber/10 transition" title="Remove Product">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
            </button>
          </div>
        </div>
      </div>

      <div style="padding:0.875rem; border-radius:0.75rem; background:#F5F6FA; border:1px solid #E4E7EF; font-size:0.7rem; color:#12172B99;">
        <div style="font-weight:600; color:#12172B; margin-bottom:0.25rem;">⚠ Automated Cost &amp; Multi-Stock Policy</div>
        VAT, Customs Tariffs and Weight-based Cargo Freight will be auto-calculated for all selected products. When stock is received, all products in this order will be automatically added to the destination warehouse inventory.
      </div>

      <div style="padding-top:1rem; border-top:1px solid #E4E7EF; display:flex; align-items:center; justify-content:flex-end; gap:0.75rem;">
        <button type="button" onclick="closeCreatePOModal()" style="padding:0.625rem 1rem; border:1px solid #E4E7EF; border-radius:0.5rem; font-size:0.875rem; font-weight:600; color:#12172BB3; background:#fff; cursor:pointer;">Cancel</button>
        <button type="submit" style="padding:0.625rem 1.5rem; border:none; border-radius:0.5rem; background:#2547D0; color:#fff; font-size:0.875rem; font-weight:600; cursor:pointer;">Issue Purchase Order</button>
      </div>
    </form>
  </div>
</div>

<%@ include file="includes/footer.jspf" %>
