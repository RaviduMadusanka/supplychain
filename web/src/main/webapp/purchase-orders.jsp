<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  com.globaltrade.core.dto.UserDTO currUser = (com.globaltrade.core.dto.UserDTO) session.getAttribute("user");
  boolean isVendor = (currUser != null && "VENDOR".equalsIgnoreCase(currUser.getRole()));
  
  String pageTitle = isVendor ? "Inbound Restock Purchase Orders" : "Inbound Restocking & Purchase Orders";
  String pageSubtitle = isVendor ? "Fulfill restock purchase orders requested by warehouse logistics coordinators" : "Procure stock from global suppliers and manage inbound warehouse inventory";
  String activePage = "purchaseorders";
  String userName = currUser != null ? currUser.getFullName() : (isVendor ? "Supplier Partner" : "Warehouse Operations");
  String userRole = currUser != null ? currUser.getRole() : (isVendor ? "Vendor" : "Warehouse Manager");
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
    <div class="p-4 rounded-xl bg-teal/10 border border-teal/20 text-teal flex items-center justify-between text-sm shadow-2xs">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
        <span>${param.success}</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-teal/60 hover:text-teal">&times;</button>
    </div>
  </c:if>

  <c:if test="${not empty param.error}">
    <div class="p-4 rounded-xl bg-amber/10 border border-amber/20 text-amber flex items-center justify-between text-sm shadow-2xs">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        <span>${param.error}</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-amber/60 hover:text-amber">&times;</button>
    </div>
  </c:if>

  <!-- WAREHOUSE MANAGER ONLY: Low Stock Alert Banner Strip -->
  <c:if test="${sessionScope.user == null || sessionScope.user.role != 'VENDOR'}">
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
  </c:if>

  <!-- Header Controls & Top Stats Strip -->
  <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
    
    <!-- Filter Tabs -->
    <div class="flex items-center gap-1 p-1 bg-ink/5 rounded-xl border border-line w-fit">
      <button type="button" onclick="filterPOs('All', this)" class="po-tab px-3.5 py-1.5 rounded-lg text-xs font-semibold bg-white text-ink shadow-sm transition">
        All Orders (${purchaseOrders.size()})
      </button>
      <button type="button" onclick="filterPOs('PENDING', this)" class="po-tab px-3.5 py-1.5 rounded-lg text-xs font-medium text-ink/50 hover:text-ink transition">
        Pending Acceptance
      </button>
      <button type="button" onclick="filterPOs('PROCESSING', this)" class="po-tab px-3.5 py-1.5 rounded-lg text-xs font-medium text-ink/50 hover:text-ink transition">
        In Transit
      </button>
      <button type="button" onclick="filterPOs('COMPLETED', this)" class="po-tab px-3.5 py-1.5 rounded-lg text-xs font-medium text-ink/50 hover:text-ink transition">
        Delivered
      </button>
    </div>

    <!-- WAREHOUSE MANAGER ONLY: Create PO Button -->
    <c:if test="${sessionScope.user == null || sessionScope.user.role != 'VENDOR'}">
      <button type="button" onclick="openCreatePOModal()" class="btn-create-po px-4 py-2.5 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primarydk transition shadow-sm inline-flex items-center gap-2 self-start sm:self-auto">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
        Create Purchase Order
      </button>
    </c:if>
  </div>

  <!-- Purchase Orders Main Table -->
  <div class="bg-white rounded-2xl border border-line shadow-sm overflow-hidden">
    <table class="w-full text-sm">
      <thead>
        <tr class="text-left text-white text-xs font-mono uppercase tracking-wider bg-gradient-to-r from-[#12172B] via-[#1B254B] to-[#1E2538] border-b border-slate-700">
          <th class="px-5 py-3.5 font-semibold text-slate-300">PO Code</th>
          <th class="px-5 py-3.5 font-semibold text-white">Destination WH</th>
          <th class="px-5 py-3.5 font-semibold text-slate-200">Supplier / Vendor</th>
          <th class="px-5 py-3.5 font-semibold text-teal">Items &amp; SKU</th>
          <th class="px-5 py-3.5 font-semibold text-slate-200">Cost &amp; Freight</th>
          <th class="px-5 py-3.5 font-semibold text-slate-200">Order Date</th>
          <th class="px-5 py-3.5 font-semibold text-slate-200">Status</th>
          <th class="px-5 py-3.5 font-semibold text-right text-slate-300">Actions</th>
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

                <!-- Total Cost -->
                <td class="px-5 py-4">
                  <div class="font-mono font-bold text-sm text-ink">
                    $${String.format("%,.2f", po.totalAmount)}
                  </div>
                  <c:if test="${po.crossBorder}">
                    <span class="inline-block mt-0.5 px-1.5 py-0.5 rounded text-[10px] font-mono bg-blue-50 text-primary border border-blue-200">
                      Cross-Border
                    </span>
                  </c:if>
                </td>

                <!-- Order Date -->
                <td class="px-5 py-4 text-xs font-mono text-ink/60">
                  <c:choose>
                    <c:when test="${not empty po.createdAt}">
                      ${po.createdAt.toLocalDate()}
                    </c:when>
                    <c:otherwise>2026-08-20</c:otherwise>
                  </c:choose>
                </td>

                <!-- Status Badge -->
                <td class="px-5 py-4">
                  <c:choose>
                    <c:when test="${po.statusName == 'PENDING'}">
                      <span class="tag tag-amber"><span class="tag-dot"></span>Pending Vendor</span>
                    </c:when>
                    <c:when test="${po.statusName == 'PROCESSING' || po.statusName == 'IN_TRANSIT'}">
                      <span class="tag tag-blue"><span class="tag-dot"></span>In Transit</span>
                    </c:when>
                    <c:when test="${po.statusName == 'COMPLETED' || po.statusName == 'DELIVERED'}">
                      <span class="tag tag-teal"><span class="tag-dot"></span>Stock Received</span>
                    </c:when>
                    <c:when test="${po.statusName == 'CANCELLED'}">
                      <span class="tag tag-slate"><span class="tag-dot"></span>Cancelled</span>
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

                    <!-- Actions based on PO status & Role -->
                    <c:choose>
                      
                      <%-- PENDING --%>
                      <c:when test="${po.statusName == 'PENDING'}">
                        <c:choose>
                          <%-- Vendor Actions: Accept or Reject --%>
                          <c:when test="${sessionScope.user != null && sessionScope.user.role == 'VENDOR'}">
                            <form action="${pageContext.request.contextPath}/purchase-orders/action" method="POST" class="inline">
                              <input type="hidden" name="action" value="accept">
                              <input type="hidden" name="poId" value="${po.id}">
                              <button type="submit" class="px-3 py-1.5 rounded-lg bg-teal text-white text-xs font-bold hover:bg-teal/90 transition shadow-xs inline-flex items-center gap-1">
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                                Accept
                              </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/purchase-orders/action" method="POST" class="inline">
                              <input type="hidden" name="action" value="reject">
                              <input type="hidden" name="poId" value="${po.id}">
                              <button type="submit" class="px-3 py-1.5 rounded-lg bg-amber text-white text-xs font-bold hover:bg-amber/90 transition shadow-xs inline-flex items-center gap-1">
                                Reject
                              </button>
                            </form>
                          </c:when>
                          <%-- Warehouse Manager View --%>
                          <c:otherwise>
                            <span class="text-xs text-amber font-mono inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-amber/10 border border-amber/20">
                              <span class="w-1.5 h-1.5 rounded-full bg-amber animate-pulse"></span>
                              Awaiting Vendor
                            </span>
                          </c:otherwise>
                        </c:choose>
                      </c:when>

                      <%-- PROCESSING / IN_TRANSIT --%>
                      <c:when test="${po.statusName == 'PROCESSING' || po.statusName == 'IN_TRANSIT'}">
                        <c:choose>
                          <%-- Warehouse Manager: Receive Stock --%>
                          <c:when test="${sessionScope.user == null || sessionScope.user.role != 'VENDOR'}">
                            <form action="${pageContext.request.contextPath}/purchase-orders/action" method="POST" class="inline">
                              <input type="hidden" name="action" value="receive">
                              <input type="hidden" name="poId" value="${po.id}">
                              <button type="submit" class="px-3 py-1.5 rounded-lg bg-teal text-white text-xs font-semibold hover:opacity-90 transition shadow-sm inline-flex items-center gap-1" onclick="return confirm('Confirm receipt of goods for ${po.poCode}? This will automatically add the stock to ${po.warehouseName}.')">
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                                Receive Stock
                              </button>
                            </form>
                          </c:when>
                          <%-- Vendor: Dispatched --%>
                          <c:otherwise>
                            <span class="text-xs text-blue-600 font-mono inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-blue-50 border border-blue-200 font-semibold">
                              <span class="w-1.5 h-1.5 rounded-full bg-blue-600 animate-pulse"></span>
                              Dispatched
                            </span>
                          </c:otherwise>
                        </c:choose>
                      </c:when>

                      <%-- COMPLETED --%>
                      <c:when test="${po.statusName == 'COMPLETED' || po.statusName == 'DELIVERED'}">
                        <span class="text-xs text-teal font-semibold font-mono inline-flex items-center gap-1 px-2.5 py-1 rounded-md bg-teal/10 border border-teal/20">
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                          Received
                        </span>
                      </c:when>

                      <c:otherwise>
                        <span class="text-xs text-ink/40 font-mono">${po.statusName}</span>
                      </c:otherwise>

                    </c:choose>

                  </div>
                </td>
              </tr>

              <!-- Items Breakdown Expandable Row -->
              <tr id="po-details-${po.id}" style="display:none;" class="bg-bg/60 border-b border-line">
                <td colspan="8" class="px-6 py-4">
                  <div class="bg-white rounded-xl border border-line p-4 shadow-xs">
                    <div class="flex items-center justify-between mb-3 border-b border-line pb-2">
                      <div class="text-xs font-mono font-semibold uppercase text-ink/60">
                        Item Specifications for <span class="text-primary">${po.poCode}</span>
                      </div>
                      <div class="text-xs text-ink/50 font-mono">
                        Subtotal: <strong>$${String.format("%,.2f", po.subtotal)}</strong> &middot; Tax: <strong>$${String.format("%,.2f", po.taxAmount)}</strong> &middot; Total: <strong class="text-ink">$${String.format("%,.2f", po.totalAmount)}</strong>
                      </div>
                    </div>
                    
                    <c:choose>
                      <c:when test="${not empty po.items}">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                          <c:forEach var="item" items="${po.items}">
                            <div class="p-3 rounded-lg border border-line bg-bg/40 flex items-center justify-between">
                              <div>
                                <div class="font-medium text-xs text-ink">${item.productName}</div>
                                <div class="text-[11px] font-mono text-primary font-semibold">${item.productSku}</div>
                              </div>
                              <div class="text-right font-mono text-xs">
                                <div class="font-bold text-ink">${item.quantity} units</div>
                                <div class="text-ink/50 text-[10px]">$${item.unitPrice} / unit</div>
                              </div>
                            </div>
                          </c:forEach>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <p class="text-xs text-ink/40 italic">Single/consolidated SKU shipment line</p>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </td>
              </tr>

            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="8" class="px-5 py-12 text-center text-ink/40 text-xs">
                No purchase orders found matching your account criteria.
              </td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>

</div>

<!-- WAREHOUSE MANAGER ONLY: CREATE PURCHASE ORDER MODAL -->
<c:if test="${sessionScope.user == null || sessionScope.user.role != 'VENDOR'}">
  <div id="createPOModal" style="display:none;" class="fixed inset-0 z-50 items-center justify-center bg-ink/60 backdrop-blur-xs p-4">
    <div class="bg-white rounded-2xl w-full max-w-2xl shadow-2xl border border-line overflow-hidden max-h-[90vh] flex flex-col animate-in fade-in zoom-in duration-150">
      
      <!-- Modal Header -->
      <div class="px-6 py-4 border-b border-line flex items-center justify-between bg-bg/50">
        <div>
          <h3 class="font-display font-bold text-base text-ink">Create Inbound Purchase Order</h3>
          <p class="text-xs text-ink/50 mt-0.5">Procure inventory from international certified suppliers</p>
        </div>
        <button type="button" onclick="closeCreatePOModal()" class="text-ink/40 hover:text-ink transition text-xl font-bold">&times;</button>
      </div>

      <!-- Modal Form Body -->
      <form action="${pageContext.request.contextPath}/purchase-orders" method="POST" class="flex flex-col flex-1 overflow-y-auto">
        <input type="hidden" name="action" value="create" />
        
        <div class="p-6 space-y-5 flex-1">
          
          <!-- Warehouse & Vendor Select Grid -->
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label class="block text-xs font-mono uppercase text-ink/60 mb-1.5">Destination Warehouse *</label>
              <select name="warehouseId" required class="w-full px-3.5 py-2.5 rounded-xl border border-line text-sm bg-white focus:outline-none focus:border-primary">
                <option value="">-- Select Destination WH --</option>
                <c:forEach var="wh" items="${warehouses}">
                  <option value="${wh.id}">${wh.name} (${wh.countryName != null ? wh.countryName : 'Regional'})</option>
                </c:forEach>
              </select>
            </div>

            <div>
              <label class="block text-xs font-mono uppercase text-ink/60 mb-1.5">Supplier / Vendor *</label>
              <select name="vendorId" required class="w-full px-3.5 py-2.5 rounded-xl border border-line text-sm bg-white focus:outline-none focus:border-primary">
                <option value="">-- Select Supplier --</option>
                <c:forEach var="v" items="${vendors}">
                  <option value="${v.id}">${v.companyName}</option>
                </c:forEach>
              </select>
            </div>
          </div>

          <!-- Product Line Items Section -->
          <div>
            <div class="flex items-center justify-between mb-2">
              <label class="block text-xs font-mono uppercase text-ink/60">Procured Product Items *</label>
              <button type="button" onclick="addPOItemRow()" class="text-xs text-primary font-semibold hover:underline flex items-center gap-1">
                + Add Item Row
              </button>
            </div>

            <div id="poItemsContainer" class="space-y-2.5">
              <div class="po-item-row flex items-center gap-2 p-2.5 rounded-xl border border-line bg-bg/30">
                <div class="flex-1">
                  <select name="productId" required class="w-full px-3 py-2 rounded-lg border border-line text-xs bg-white focus:outline-none focus:border-primary">
                    <option value="">-- Select Product Item --</option>
                    <c:forEach var="prod" items="${products}">
                      <option value="${prod.id}">[${prod.sku}] ${prod.name} (${prod.categoryName})</option>
                    </c:forEach>
                  </select>
                </div>
                <div class="w-28">
                  <input type="number" name="quantity" min="1" required value="50" placeholder="Qty" class="w-full px-3 py-2 rounded-lg border border-line text-xs font-mono focus:outline-none focus:border-primary text-center" />
                </div>
                <button type="button" onclick="removePOItemRow(this)" class="p-2 rounded-lg text-ink/40 hover:text-amber hover:bg-amber/10 transition" title="Remove line">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                </button>
              </div>
            </div>
          </div>

          <div class="p-3.5 rounded-xl bg-primary/5 border border-primary/20 text-xs text-primary/80 leading-relaxed">
            <strong class="text-primary font-semibold">Automatic Milestone Tracking:</strong> 
            Upon creation, the Purchase Order will be queued in `PENDING` status for the supplier. Cross-border VAT and import tariffs will be computed dynamically.
          </div>
        </div>

        <!-- Modal Footer -->
        <div class="px-6 py-4 border-t border-line bg-bg/50 flex items-center justify-end gap-3">
          <button type="button" onclick="closeCreatePOModal()" class="px-4 py-2 rounded-xl border border-line text-xs font-semibold text-ink/70 hover:bg-bg">Cancel</button>
          <button type="submit" class="px-5 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primarydk shadow-xs">Issue Purchase Order</button>
        </div>
      </form>

    </div>
  </div>
</c:if>

<%@ include file="includes/footer.jspf" %>