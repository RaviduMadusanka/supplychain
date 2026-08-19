<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  String pageTitle = "Warehouses";
  String pageSubtitle = "Facility capacity & real-time utilization overview";
  String activePage = "warehouses";
  String userName = "Saman Kumara";
  String userRole = "Warehouse Manager";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <!-- Success / Error notification -->
  <c:if test="${param.success == 'WarehouseAdded'}">
    <div class="mb-6 p-4 rounded-xl bg-teal/10 border border-teal/30 text-teal flex items-center justify-between text-sm font-medium">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
        <span>Warehouse facility has been registered successfully!</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-teal/60 hover:text-teal">&times;</button>
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="mb-6 p-4 rounded-xl bg-amber/10 border border-amber/30 text-amber flex items-center justify-between text-sm font-medium">
      <div class="flex items-center gap-2">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
        <span>${error}</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-amber/60 hover:text-amber">&times;</button>
    </div>
  </c:if>

  <!-- Top Action Bar -->
  <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-6">
    <div>
      <h2 class="text-lg font-semibold text-ink">Global Storage Facilities</h2>
      <p class="text-xs text-ink/50 mt-0.5">Manage storage locations and track real-time unit utilization rates.</p>
    </div>
    <button onclick="openAddWarehouseModal()" class="px-4 py-2.5 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition shadow-sm flex items-center gap-2">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
      Add Warehouse
    </button>
  </div>

  <!-- Warehouse Cards Grid -->
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <c:choose>
      <c:when test="${not empty warehouses}">
        <c:forEach var="w" items="${warehouses}">
          <c:set var="utilPercent" value="${w.utilizationPercentage}" />
          
          <div class="card p-6 flex flex-col justify-between hover:shadow-md transition-shadow">
            <div>
              <div class="flex items-start justify-between mb-3">
                <div>
                  <h3 class="font-display font-semibold text-base text-ink leading-snug">${w.name}</h3>
                  <span class="font-mono text-xs text-ink/40 tracking-wider">${w.warehouseCode}</span>
                </div>
                <c:choose>
                  <c:when test="${utilPercent >= 90}">
                    <span class="tag tag-amber"><span class="tag-dot"></span>${utilPercent}%</span>
                  </c:when>
                  <c:when test="${utilPercent >= 70}">
                    <span class="tag tag-amber"><span class="tag-dot"></span>${utilPercent}%</span>
                  </c:when>
                  <c:otherwise>
                    <span class="tag tag-teal"><span class="tag-dot"></span>${utilPercent}%</span>
                  </c:otherwise>
                </c:choose>
              </div>

              <div class="text-xs text-ink/60 mb-4 flex items-center gap-1.5">
                <svg class="w-3.5 h-3.5 text-ink/40 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                <span>${w.location} <c:if test="${not empty w.countryName}">&middot; <strong class="font-medium text-ink/70">${w.countryName}</strong></c:if></span>
              </div>

              <!-- Utilization progress bar -->
              <div class="space-y-1.5 mb-5">
                <div class="h-2.5 bg-line rounded-full overflow-hidden p-0.5">
                  <div class="h-full rounded-full transition-all duration-500 ${utilPercent >= 85 ? 'bg-amber' : 'bg-primary'}" style="width:${utilPercent}%"></div>
                </div>
                <div class="flex justify-between text-xs font-mono text-ink/50">
                  <span>${w.currentUtilization} used</span>
                  <span>${w.capacity} capacity</span>
                </div>
              </div>
            </div>

            <div class="pt-4 border-t border-line flex items-center justify-between text-xs text-ink/60">
              <span>Facility Manager:</span>
              <span class="font-medium text-ink font-mono">${w.managerName}</span>
            </div>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <div class="col-span-full card p-12 text-center">
          <div class="w-16 h-16 mx-auto mb-4 rounded-2xl bg-bg border border-line flex items-center justify-center text-ink/30">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 9.5L12 3l9 6.5V21H3V9.5z"/></svg>
          </div>
          <h3 class="font-display font-semibold text-lg text-ink mb-1">No Warehouses Found</h3>
          <p class="text-sm text-ink/50 mb-6 max-w-md mx-auto">Get started by creating your first global or regional storage facility.</p>
          <button onclick="openAddWarehouseModal()" class="px-5 py-2.5 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition shadow-sm inline-flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
            Add New Warehouse
          </button>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

  <!-- Add Warehouse Modal -->
  <div id="addWarehouseModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/60 backdrop-blur-sm p-4">
    <div class="bg-white rounded-2xl border border-line shadow-2xl w-full max-w-lg overflow-hidden animate-in fade-in zoom-in-95 duration-200">
      
      <div class="h-16 px-6 border-b border-line flex items-center justify-between bg-bg/50">
        <div class="flex items-center gap-2">
          <div class="w-8 h-8 rounded-lg bg-primary/10 text-primary flex items-center justify-center font-display font-bold text-sm">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9.5L12 3l9 6.5V21H3V9.5z"/></svg>
          </div>
          <h3 class="font-display font-semibold text-base text-ink">Register New Warehouse</h3>
        </div>
        <button onclick="closeAddWarehouseModal()" class="text-ink/40 hover:text-ink transition p-1 rounded-lg hover:bg-bg">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
        </button>
      </div>

      <form action="${pageContext.request.contextPath}/warehouses" method="POST" class="p-6 space-y-4">
        
        <div>
          <label class="block text-xs font-semibold text-ink/70 mb-1.5 uppercase font-mono">Warehouse Code</label>
          <input type="text" name="warehouseCode" placeholder="e.g. WH-COL-02 (leave blank to auto-generate)" class="w-full px-3.5 py-2.5 border border-line rounded-lg text-sm bg-white font-mono focus:border-primary focus:outline-none transition">
        </div>

        <div>
          <label class="block text-xs font-semibold text-ink/70 mb-1.5 uppercase font-mono">Warehouse Name <span class="text-amber">*</span></label>
          <input type="text" name="name" required placeholder="e.g. Kandy Regional Hub" class="w-full px-3.5 py-2.5 border border-line rounded-lg text-sm bg-white focus:border-primary focus:outline-none transition">
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-semibold text-ink/70 mb-1.5 uppercase font-mono">Storage Capacity (Units) <span class="text-amber">*</span></label>
            <input type="number" name="capacity" required min="1" placeholder="e.g. 50000" class="w-full px-3.5 py-2.5 border border-line rounded-lg text-sm bg-white font-mono focus:border-primary focus:outline-none transition">
          </div>

          <div>
            <label class="block text-xs font-semibold text-ink/70 mb-1.5 uppercase font-mono">Country <span class="text-amber">*</span></label>
            <select name="countryId" required class="w-full px-3.5 py-2.5 border border-line rounded-lg text-sm bg-white focus:border-primary focus:outline-none transition">
              <option value="">-- Select Country --</option>
              <c:forEach var="c" items="${countries}">
                <option value="${c.id}">${c.name}</option>
              </c:forEach>
            </select>
          </div>
        </div>

        <div>
          <label class="block text-xs font-semibold text-ink/70 mb-1.5 uppercase font-mono">Facility Location / Address</label>
          <textarea name="location" rows="2" placeholder="e.g. Peliyagoda Industrial Zone, Colombo" class="w-full px-3.5 py-2.5 border border-line rounded-lg text-sm bg-white focus:border-primary focus:outline-none transition"></textarea>
        </div>

        <div class="pt-4 border-t border-line flex items-center justify-end gap-3">
          <button type="button" onclick="closeAddWarehouseModal()" class="px-4 py-2.5 rounded-lg border border-line text-sm font-semibold text-ink/70 hover:bg-bg transition">Cancel</button>
          <button type="submit" class="px-6 py-2.5 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition shadow-sm shadow-primary/20 flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
            Save Facility
          </button>
        </div>

      </form>
    </div>
  </div>

  <script>
    function openAddWarehouseModal() {
      const modal = document.getElementById('addWarehouseModal');
      modal.classList.remove('hidden');
      modal.classList.add('flex');
    }

    function closeAddWarehouseModal() {
      const modal = document.getElementById('addWarehouseModal');
      modal.classList.remove('flex');
      modal.classList.add('hidden');
    }
  </script>

<%@ include file="includes/footer.jspf" %>
