<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    <a href="${pageContext.request.contextPath}/inventory" class="card p-5 hover:border-primary transition group block">
      <div class="text-xs text-ink/50 mb-1 group-hover:text-primary transition">Total SKUs</div>
      <div class="font-display text-3xl font-semibold">${totalSkus != null ? totalSkus : 0}</div>
      <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Across all warehouses</div>
    </a>
    <a href="${pageContext.request.contextPath}/inventory" class="card p-5 border-amber bg-amber/10 hover:border-amber hover:bg-amber/20 transition group block shadow-sm">
      <div class="text-xs text-amber mb-1 font-bold flex items-center justify-between">Low Stock Alerts <span class="tag bg-amber text-white border-transparent"><span class="tag-dot bg-white"></span>Attention</span></div>
      <div class="font-display text-3xl font-bold text-amber">${lowStockCount != null ? lowStockCount : 0}</div>
      <div class="text-[10px] text-amber/80 font-mono mt-1 uppercase font-bold">Requires restocking</div>
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
            <a href="${pageContext.request.contextPath}/inventory" class="text-xs text-primary hover:text-primarydk font-medium transition">View Inventory &rarr;</a>
          </div>
          <a href="${pageContext.request.contextPath}/inventory" class="px-3 py-1.5 rounded-lg bg-bg text-ink text-xs font-semibold hover:bg-line transition border border-line">Update Stock</a>
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
            <c:choose>
              <c:when test="${not empty stocks}">
                <c:forEach var="s" items="${stocks}">
                  <tr class="hover:bg-bg/50 transition ${s.stockQty == 0 ? 'opacity-60' : ''}">
                    <td class="px-5 py-3">
                      <div class="font-medium">${s.productName}</div>
                    </td>
                    <td class="px-5 py-3 text-xs">${s.warehouseName}</td>
                    <td class="px-5 py-3 text-right font-mono font-medium ${s.stockQty < s.productReorderLevel ? 'text-amber' : ''}">${s.stockQty}</td>
                    <td class="px-5 py-3 text-right font-mono text-xs text-ink/60">$${s.unitPrice}</td>
                    <td class="px-5 py-3 text-right">
                      <c:choose>
                        <c:when test="${s.stockQty == 0}">
                          <span class="tag tag-amber"><span class="tag-dot"></span>Out of Stock</span>
                        </c:when>
                        <c:when test="${s.stockQty < s.productReorderLevel}">
                          <span class="tag tag-amber"><span class="tag-dot"></span>Low Stock</span>
                        </c:when>
                        <c:otherwise>
                          <span class="tag tag-teal"><span class="tag-dot"></span>In Stock</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr><td colspan="5" class="px-5 py-6 text-center text-ink/50 text-sm">No stock available.</td></tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>

    <div class="space-y-6">
      <div class="card p-0 overflow-hidden border-amber/50 shadow-sm">
        <div class="px-5 py-4 border-b border-amber/30 bg-amber/10 flex items-center justify-between">
          <h3 class="font-display font-bold text-sm text-amber flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
            Low Stock Alerts
          </h3>
        </div>
        <div class="divide-y divide-line">
          <c:choose>
            <c:when test="${lowStockCount > 0}">
              <c:forEach var="s" items="${stocks}">
                <c:if test="${s.statusName == 'LOW_STOCK' || s.statusName == 'OUT_OF_STOCK'}">
                  <div class="p-4 hover:bg-bg/30 transition">
                    <div class="text-xs font-bold text-ink mb-1">${s.productName}</div>
                    <div class="text-[11px] text-ink/60 mb-3">${s.warehouseName}</div>
                    <div class="flex items-center justify-between">
                      <span class="text-xs font-mono text-amber font-bold">${s.stockQty} left (Min: ${s.productReorderLevel})</span>
                      <a href="${pageContext.request.contextPath}/inventory" class="px-4 py-1.5 rounded bg-amber text-white text-[11px] font-bold hover:bg-amber/90 transition shadow-sm">Resolve</a>
                    </div>
                  </div>
                </c:if>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div class="p-4 text-xs text-ink/50 text-center">No low stock alerts.</div>
            </c:otherwise>
          </c:choose>
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

<!-- Startup Alert Modal for Low Stock -->
<c:if test="${lowStockCount > 0}">
  <div id="startupAlertModal" class="flex fixed inset-0 z-[100] items-center justify-center bg-ink/50 backdrop-blur-sm">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-sm p-6 transform transition-all translate-y-0 scale-100">
      <div class="flex items-center gap-3 mb-4 text-amber">
        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
        <h3 class="font-display font-semibold text-xl">Low Stock Warning</h3>
      </div>
      <p class="text-sm text-ink/70 mb-4">You have <strong>${lowStockCount}</strong> items that are low on stock or out of stock.</p>
      
      <div class="max-h-32 overflow-y-auto mb-5 border border-line rounded-lg p-2 bg-bg/50">
        <c:forEach var="s" items="${stocks}">
          <c:if test="${s.statusName == 'LOW_STOCK' || s.statusName == 'OUT_OF_STOCK'}">
            <div class="text-xs mb-1 last:mb-0">&bull; ${s.productName} (${s.stockQty} left)</div>
          </c:if>
        </c:forEach>
      </div>

      <div class="flex justify-end">
        <button onclick="document.getElementById('startupAlertModal').style.display='none'" class="px-5 py-2.5 rounded-lg bg-amber text-white text-sm font-semibold hover:bg-amber/90 transition shadow-sm">Got it</button>
      </div>
    </div>
  </div>
</c:if>

<%@ include file="includes/footer.jspf" %>
