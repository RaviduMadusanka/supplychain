<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  String pageTitle = "Customer Orders";
  String pageSubtitle = "Pick, pack, ship and fulfill outbound customer orders";
  String activePage = "orders";
  String userName = "Saman Kumara";
  String userRole = "Warehouse Manager";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <!-- Notifications -->
  <c:if test="${param.success == 'OrderProcessing'}">
    <div class="mb-6 p-4 rounded-xl bg-blue-500/10 border border-blue-500/30 text-primary flex items-center justify-between text-sm font-medium">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
        <span>Order status updated to <strong>PROCESSING</strong>. Packing and picking can begin!</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-primary/60 hover:text-primary">&times;</button>
    </div>
  </c:if>
  <c:if test="${param.success == 'ShipmentCreated'}">
    <div class="mb-6 p-4 rounded-xl bg-teal/10 border border-teal/30 text-teal flex items-center justify-between text-sm font-medium">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
        <span>Shipment created successfully! Warehouse inventory stock deducted and tracking initiated.</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-teal/60 hover:text-teal">&times;</button>
    </div>
  </c:if>
  <c:if test="${param.success == 'OrderCompleted'}">
    <div class="mb-6 p-4 rounded-xl bg-teal/10 border border-teal/30 text-teal flex items-center justify-between text-sm font-medium">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        <span>Order has been dispatched and marked as <strong>COMPLETED</strong>!</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-teal/60 hover:text-teal">&times;</button>
    </div>
  </c:if>
  <c:if test="${not empty param.error}">
    <div class="mb-6 p-4 rounded-xl bg-amber/10 border border-amber/30 text-amber flex items-center justify-between text-sm font-medium">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
        <span>${param.error}</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-amber/60 hover:text-amber">&times;</button>
    </div>
  </c:if>

  <!-- Counts calculation -->
  <c:set var="pendingCount" value="0" />
  <c:set var="processingCount" value="0" />
  <c:set var="completedCount" value="0" />
  <c:forEach var="o" items="${orders}">
    <c:if test="${o.statusName == 'PENDING' || o.statusName == 'CREATED'}"><c:set var="pendingCount" value="${pendingCount + 1}" /></c:if>
    <c:if test="${o.statusName == 'PROCESSING'}"><c:set var="processingCount" value="${processingCount + 1}" /></c:if>
    <c:if test="${o.statusName == 'COMPLETED'}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
  </c:forEach>

  <!-- Stats Strip -->
  <div class="grid grid-cols-1 sm:grid-cols-4 gap-4 mb-6">
    <div class="card p-4">
      <div class="text-xs text-ink/50 font-medium">Total Orders</div>
      <div class="font-display text-2xl font-bold text-ink mt-1">${orders.size()}</div>
    </div>
    <div class="card p-4 border-l-4 border-l-amber">
      <div class="text-xs text-amber font-medium flex items-center justify-between">
        <span>1. Pending (To Pack)</span>
        <span class="w-2 h-2 rounded-full bg-amber"></span>
      </div>
      <div class="font-display text-2xl font-bold text-ink mt-1">${pendingCount}</div>
    </div>
    <div class="card p-4 border-l-4 border-l-primary">
      <div class="text-xs text-primary font-medium flex items-center justify-between">
        <span>2. Processing / Shipped</span>
        <span class="w-2 h-2 rounded-full bg-primary"></span>
      </div>
      <div class="font-display text-2xl font-bold text-ink mt-1">${processingCount}</div>
    </div>
    <div class="card p-4 border-l-4 border-l-teal">
      <div class="text-xs text-teal font-medium flex items-center justify-between">
        <span>3. Completed</span>
        <span class="w-2 h-2 rounded-full bg-teal"></span>
      </div>
      <div class="font-display text-2xl font-bold text-ink mt-1">${completedCount}</div>
    </div>
  </div>

  <!-- Filter tabs -->
  <div class="flex items-center justify-between mb-5">
    <div class="flex items-center gap-1 p-1 bg-line/50 rounded-lg text-xs font-mono uppercase">
      <button onclick="filterOrders('All', this)" class="order-tab px-3 py-1.5 rounded-md bg-white shadow-sm font-semibold text-ink">All (${orders.size()})</button>
      <button onclick="filterOrders('PENDING', this)" class="order-tab px-3 py-1.5 rounded-md text-ink/50">Pending (${pendingCount})</button>
      <button onclick="filterOrders('PROCESSING', this)" class="order-tab px-3 py-1.5 rounded-md text-ink/50">Processing (${processingCount})</button>
      <button onclick="filterOrders('COMPLETED', this)" class="order-tab px-3 py-1.5 rounded-md text-ink/50">Completed (${completedCount})</button>
    </div>
  </div>

  <!-- Orders Table -->
  <div class="card overflow-hidden">
    <table class="w-full text-sm">
      <thead>
        <tr class="text-left text-white/80 text-xs font-mono uppercase tracking-wider border-b border-ink bg-ink">
          <th class="px-5 py-3.5 font-medium">Order Code</th>
          <th class="px-5 py-3.5 font-medium">Customer</th>
          <th class="px-5 py-3.5 font-medium">Items</th>
          <th class="px-5 py-3.5 font-medium">Total Amount</th>
          <th class="px-5 py-3.5 font-medium">Placed Date</th>
          <th class="px-5 py-3.5 font-medium">Status</th>
          <th class="px-5 py-3.5 font-medium text-right">Fulfillment Actions</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-line">
        <c:choose>
          <c:when test="${not empty orders}">
            <c:forEach var="o" items="${orders}">
              <tr class="order-row hover:bg-bg/50 transition" data-status="${o.statusName}">
                
                <!-- Order Code -->
                <td class="px-5 py-4 font-mono font-semibold text-xs text-primary">
                  ${o.orderCode}
                </td>

                <!-- Customer Details -->
                <td class="px-5 py-4">
                  <div class="font-medium text-ink">${o.customerName}</div>
                  <c:if test="${not empty o.customerAddress}">
                    <div class="text-xs text-ink/50 truncate max-w-xs mt-0.5" title="${o.customerAddress}">${o.customerAddress}</div>
                  </c:if>
                </td>

                <!-- Items Count & Toggle -->
                <td class="px-5 py-4">
                  <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-bg border border-line text-xs font-mono">
                    <strong>${o.itemCount}</strong> units (${o.items.size()} SKU)
                  </span>
                </td>

                <!-- Total Amount -->
                <td class="px-5 py-4 font-mono font-semibold text-ink">
                  $${o.totalAmount}
                </td>

                <!-- Placed Date -->
                <td class="px-5 py-4 text-xs font-mono text-ink/60">
                  ${o.createdAt}
                </td>

                <!-- Status Badge -->
                <td class="px-5 py-4">
                  <c:choose>
                    <c:when test="${o.statusName == 'PENDING' || o.statusName == 'CREATED'}">
                      <span class="tag tag-amber"><span class="tag-dot"></span>Pending Pack</span>
                    </c:when>
                    <c:when test="${o.statusName == 'PROCESSING'}">
                      <span class="tag" style="background:#EAEEFC; color:#1B34A6;"><span class="tag-dot" style="background:#2547D0;"></span>Processing</span>
                    </c:when>
                    <c:when test="${o.statusName == 'COMPLETED'}">
                      <span class="tag tag-teal"><span class="tag-dot"></span>Completed</span>
                    </c:when>
                    <c:otherwise>
                      <span class="tag tag-slate"><span class="tag-dot"></span>${o.statusName}</span>
                    </c:otherwise>
                  </c:choose>

                  <c:if test="${not empty o.shipmentCode}">
                    <div class="text-[11px] font-mono text-primary mt-1">🚚 ${o.shipmentCode} (${o.carrierName})</div>
                  </c:if>
                </td>

                <!-- Actions based on Lifecycle -->
                <td class="px-5 py-4 text-right">
                  <div class="flex items-center justify-end gap-2">
                    
                    <!-- Toggle items details modal/drawer -->
                    <button onclick="toggleDetails('details-${o.id}')" class="px-2.5 py-1.5 rounded-lg border border-line text-xs font-medium hover:bg-bg transition text-ink/70" title="View Items">
                      View Items
                    </button>

                    <!-- STEP 1: PENDING -> Start Packing (PROCESSING) -->
                    <c:if test="${o.statusName == 'PENDING' || o.statusName == 'CREATED'}">
                      <form action="${pageContext.request.contextPath}/orders/action" method="POST" class="inline">
                        <input type="hidden" name="action" value="process">
                        <input type="hidden" name="orderId" value="${o.id}">
                        <button type="submit" class="px-3 py-1.5 rounded-lg bg-amber text-white text-xs font-semibold hover:opacity-90 transition shadow-sm inline-flex items-center gap-1">
                          <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                          Start Packing
                        </button>
                      </form>
                    </c:if>

                    <!-- STEP 2: PROCESSING -> Create Shipment -->
                    <c:if test="${o.statusName == 'PROCESSING'}">
                      <c:if test="${empty o.shipmentCode}">
                        <button onclick="openShipmentModal(${o.id}, '${o.orderCode}', '${o.customerName}', '${o.customerAddress}')" class="px-3 py-1.5 rounded-lg bg-primary text-white text-xs font-semibold hover:bg-primarydk transition shadow-sm inline-flex items-center gap-1">
                          <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                          Create Shipment
                        </button>
                      </c:if>

                      <!-- STEP 3: Complete / Dispatch Order -->
                      <form action="${pageContext.request.contextPath}/orders/action" method="POST" class="inline">
                        <input type="hidden" name="action" value="complete">
                        <input type="hidden" name="orderId" value="${o.id}">
                        <button type="submit" class="px-3 py-1.5 rounded-lg bg-teal text-white text-xs font-semibold hover:opacity-90 transition shadow-sm inline-flex items-center gap-1" onclick="return confirm('Confirm dispatch & completion of order ${o.orderCode}?')">
                          <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                          Dispatch &amp; Complete
                        </button>
                      </form>
                    </c:if>

                    <!-- COMPLETED State -->
                    <c:if test="${o.statusName == 'COMPLETED'}">
                      <span class="text-xs text-teal font-semibold font-mono inline-flex items-center gap-1">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                        Fulfilled
                      </span>
                    </c:if>

                  </div>
                </td>

              </tr>

              <!-- Expandable Order Line Items Row -->
              <tr id="details-${o.id}" class="hidden bg-bg/80 border-b border-line">
                <td colspan="7" class="p-4">
                  <div class="bg-white p-4 rounded-xl border border-line shadow-inner max-w-4xl mx-auto">
                    <div class="flex items-center justify-between pb-3 mb-3 border-b border-line">
                      <div class="font-semibold text-xs text-ink uppercase tracking-wide font-mono">
                        Order Line Items &middot; ${o.orderCode}
                      </div>
                      <div class="text-xs text-ink/50">
                        Deliver to: <strong class="text-ink">${o.customerAddress}</strong> (Ph: ${o.customerPhone})
                      </div>
                    </div>
                    
                    <table class="w-full text-xs">
                      <thead>
                        <tr class="text-left text-ink/50 border-b border-line">
                          <th class="pb-2 font-medium font-mono">SKU</th>
                          <th class="pb-2 font-medium">Product Name</th>
                          <th class="pb-2 font-medium text-center">Quantity</th>
                          <th class="pb-2 font-medium text-right font-mono">Unit Price</th>
                          <th class="pb-2 font-medium text-right font-mono">Subtotal</th>
                        </tr>
                      </thead>
                      <tbody class="divide-y divide-line/60">
                        <c:forEach var="item" items="${o.items}">
                          <tr>
                            <td class="py-2.5 font-mono text-ink/70">${item.productSku}</td>
                            <td class="py-2.5 font-medium text-ink">${item.productName}</td>
                            <td class="py-2.5 text-center font-mono font-semibold">${item.quantity}</td>
                            <td class="py-2.5 text-right font-mono text-ink/70">$${item.unitPrice}</td>
                            <td class="py-2.5 text-right font-mono font-bold text-ink">$${item.lineTotal}</td>
                          </tr>
                        </c:forEach>
                      </tbody>
                      <tfoot>
                        <tr class="border-t border-line font-bold text-xs">
                          <td colspan="4" class="pt-3 text-right">Total Order Value:</td>
                          <td class="pt-3 text-right font-mono text-primary text-sm">$${o.totalAmount}</td>
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
              <td colspan="7" class="p-12 text-center text-ink/50 text-sm">
                No customer orders found in the system.
              </td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>

  <!-- Create Shipment Modal -->
  <div id="createShipmentModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/60 backdrop-blur-sm p-4">
    <div class="bg-white rounded-2xl border border-line shadow-2xl w-full max-w-lg overflow-hidden animate-in fade-in zoom-in-95 duration-200">
      
      <div class="h-16 px-6 border-b border-line flex items-center justify-between bg-bg/50">
        <div class="flex items-center gap-2">
          <div class="w-8 h-8 rounded-lg bg-primary/10 text-primary flex items-center justify-center font-display font-bold text-sm">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
          </div>
          <div>
            <h3 class="font-display font-semibold text-base text-ink">Generate Outbound Shipment</h3>
            <p id="modalSubtitle" class="text-xs text-ink/50 font-mono">Order #</p>
          </div>
        </div>
        <button onclick="closeShipmentModal()" class="text-ink/40 hover:text-ink transition p-1 rounded-lg hover:bg-bg">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
        </button>
      </div>

      <form action="${pageContext.request.contextPath}/orders/action" method="POST" class="p-6 space-y-4">
        <input type="hidden" name="action" value="ship">
        <input type="hidden" id="modalOrderId" name="orderId" value="">

        <div>
          <label class="block text-xs font-semibold text-ink/70 mb-1.5 uppercase font-mono">Origin Dispatch Warehouse <span class="text-amber">*</span></label>
          <select name="warehouseId" required class="w-full px-3.5 py-2.5 border border-line rounded-lg text-sm bg-white focus:border-primary focus:outline-none transition">
            <option value="">-- Select Origin Warehouse --</option>
            <c:forEach var="w" items="${warehouses}">
              <option value="${w.id}">${w.name} (${w.warehouseCode})</option>
            </c:forEach>
          </select>
          <p class="text-[11px] text-ink/40 mt-1">Stock for the ordered items will be automatically deducted from this warehouse.</p>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-semibold text-ink/70 mb-1.5 uppercase font-mono">Carrier Service <span class="text-amber">*</span></label>
            <select name="carrier" required class="w-full px-3.5 py-2.5 border border-line rounded-lg text-sm bg-white focus:border-primary focus:outline-none transition">
              <option value="DHL Express">DHL Express</option>
              <option value="FedEx Logistics">FedEx Logistics</option>
              <option value="UPS Freight">UPS Freight</option>
              <option value="Sri Lanka Express Post">Sri Lanka Express Post</option>
            </select>
          </div>

          <div>
            <label class="block text-xs font-semibold text-ink/70 mb-1.5 uppercase font-mono">Est. Delivery (Days)</label>
            <input type="number" name="deliveryDays" value="3" min="1" max="30" class="w-full px-3.5 py-2.5 border border-line rounded-lg text-sm bg-white font-mono focus:border-primary focus:outline-none transition">
          </div>
        </div>

        <div>
          <label class="block text-xs font-semibold text-ink/70 mb-1.5 uppercase font-mono">Delivery Destination Address</label>
          <textarea id="modalDestination" name="destination" rows="2" class="w-full px-3.5 py-2.5 border border-line rounded-lg text-sm bg-white focus:border-primary focus:outline-none transition"></textarea>
        </div>

        <div class="pt-4 border-t border-line flex items-center justify-end gap-3">
          <button type="button" onclick="closeShipmentModal()" class="px-4 py-2.5 rounded-lg border border-line text-sm font-semibold text-ink/70 hover:bg-bg transition">Cancel</button>
          <button type="submit" class="px-6 py-2.5 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition shadow-sm shadow-primary/20 flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
            Confirm &amp; Create Shipment
          </button>
        </div>

      </form>
    </div>
  </div>

  <script>
    function filterOrders(status, btn) {
      document.querySelectorAll('.order-tab').forEach(b => {
        b.classList.remove('bg-white', 'shadow-sm', 'font-semibold', 'text-ink');
        b.classList.add('text-ink/50');
      });
      btn.classList.remove('text-ink/50');
      btn.classList.add('bg-white', 'shadow-sm', 'font-semibold', 'text-ink');

      const rows = document.querySelectorAll('.order-row');
      rows.forEach(row => {
        const rowStatus = row.dataset.status;
        if (status === 'All') {
          row.style.display = '';
        } else if (status === 'PENDING' && (rowStatus === 'PENDING' || rowStatus === 'CREATED')) {
          row.style.display = '';
        } else if (rowStatus === status) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      });
    }

    function toggleDetails(id) {
      const row = document.getElementById(id);
      if (row.classList.contains('hidden')) {
        row.classList.remove('hidden');
      } else {
        row.classList.add('hidden');
      }
    }

    function openShipmentModal(orderId, orderCode, customerName, address) {
      document.getElementById('modalOrderId').value = orderId;
      document.getElementById('modalSubtitle').textContent = orderCode + ' · ' + customerName;
      document.getElementById('modalDestination').value = address || '';
      
      const modal = document.getElementById('createShipmentModal');
      modal.classList.remove('hidden');
      modal.classList.add('flex');
    }

    function closeShipmentModal() {
      const modal = document.getElementById('createShipmentModal');
      modal.classList.remove('flex');
      modal.classList.add('hidden');
    }
  </script>

<%@ include file="includes/footer.jspf" %>
