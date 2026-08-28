<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  String pageTitle = "Vendors & Suppliers";
  String pageSubtitle = "Manage approved global suppliers, procurement partners & performance";
  String activePage = "vendors";
  String userName = "Saman Kumara";
  String userRole = "Warehouse Manager";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<div class="flex items-center justify-between mb-6">
  <div>
    <h2 class="text-xl font-display font-bold text-ink">Vendors & Suppliers</h2>
    <p class="text-sm text-ink/50 mt-0.5">Manage approved global suppliers, procurement partners &amp; performance</p>
  </div>
  <button onclick="toggleModal('addVendorModal')" class="px-4 py-2.5 rounded-xl bg-primary hover:bg-primarydk text-white text-xs font-semibold shadow-sm shadow-primary/20 inline-flex items-center gap-2 transition">
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
    Add New Vendor
  </button>
</div>

<c:if test="${not empty param.success}">
  <div class="mb-5 p-4 rounded-xl bg-teal/10 border border-teal/30 text-teal flex items-center justify-between text-sm font-medium">
    <div class="flex items-center gap-2">
      <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
      <span>${param.success}</span>
    </div>
    <button onclick="this.parentElement.remove()" class="text-teal/60 hover:text-teal">&times;</button>
  </div>
</c:if>
<c:if test="${not empty param.error}">
  <div class="mb-5 p-4 rounded-xl bg-amber/10 border border-amber/30 text-amber flex items-center justify-between text-sm font-medium">
    <div class="flex items-center gap-2">
      <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
      <span>${param.error}</span>
    </div>
    <button onclick="this.parentElement.remove()" class="text-amber/60 hover:text-amber">&times;</button>
  </div>
</c:if>

<div class="flex items-center gap-3 mb-5">
  <input type="text" id="vendorSearch" onkeyup="filterVendors()" placeholder="Search vendor code, company, contact, country..." class="flex-1 px-3.5 py-2 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
  <select id="statusFilter" onchange="filterVendors()" class="px-3 py-2 rounded-lg border border-line bg-white text-sm text-ink/70">
    <option value="ALL">All statuses</option>
    <option value="ACTIVE">Active</option>
    <option value="SUSPENDED">Suspended</option>
  </select>
</div>

<div class="bg-white rounded-2xl border border-line shadow-sm overflow-hidden">
  <table class="w-full text-sm">
    <thead>
      <tr class="text-left text-white/80 text-xs font-mono uppercase tracking-wider border-b border-ink bg-ink">
        <th class="px-5 py-3.5">Vendor Code</th>
        <th class="px-5 py-3.5">Company Name</th>
        <th class="px-5 py-3.5">Contact Person</th>
        <th class="px-5 py-3.5">Country / Origin</th>
        <th class="px-5 py-3.5">Quality Rating</th>
        <th class="px-5 py-3.5">Account Status</th>
        <th class="px-5 py-3.5">Procurement Actions</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-line">
      <c:choose>
        <c:when test="${not empty vendors}">
          <c:forEach var="v" items="${vendors}">
            <tr class="vendor-row hover:bg-bg/60 transition" data-status="${v.statusName}">
              <td class="px-5 py-4 font-mono text-xs text-primary font-semibold">${v.vendorCode}</td>
              <td class="px-5 py-4 font-medium text-ink">${v.companyName}</td>
              <td class="px-5 py-4 text-ink/70">${v.contactPerson}</td>
              <td class="px-5 py-4 text-ink/80">${v.countryName}</td>
              <td class="px-5 py-4">
                <span class="font-mono font-semibold text-teal">${v.rating}</span>
                <span class="text-amber ml-1">&#9733;</span>
              </td>
              <td class="px-5 py-4">
                <c:choose>
                  <c:when test="${v.statusName == 'ACTIVE'}">
                    <span class="tag tag-teal"><span class="tag-dot"></span>Active</span>
                  </c:when>
                  <c:otherwise>
                    <span class="tag tag-amber"><span class="tag-dot"></span>${v.statusName}</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="px-5 py-4 text-right">
                <a href="${pageContext.request.contextPath}/purchase-orders" class="px-2.5 py-1.5 rounded-lg border border-line text-xs font-medium hover:bg-bg transition text-primary">Issue PO &rarr;</a>
              </td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr><td colspan="7" class="p-12 text-center text-ink/50 text-sm">No vendors registered yet. Click <strong>"+ Onboard New Vendor"</strong> to add your first supplier.</td></tr>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>

<div id="addVendorModal" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-ink/50 backdrop-blur-sm p-4">
  <div class="w-full max-w-lg bg-white rounded-2xl border border-line shadow-2xl flex flex-col max-h-[92vh] overflow-hidden">
    <div class="h-16 px-6 border-b border-line flex items-center justify-between bg-bg flex-shrink-0">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-lg bg-primsoft text-primary flex items-center justify-center">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
        </div>
        <div>
          <div class="font-display font-semibold text-sm text-ink">Onboard New Vendor</div>
          <div class="text-xs text-ink/50 font-mono">Register supplier company &amp; procurement origin</div>
        </div>
      </div>
      <button onclick="toggleModal('addVendorModal')" class="text-ink/40 hover:text-ink transition">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
      </button>
    </div>
    <form action="${pageContext.request.contextPath}/vendors/action" method="POST" class="p-6 space-y-4 overflow-y-auto scrollnice">
      <div>
        <label class="block text-xs font-semibold text-ink/70 uppercase font-mono mb-1.5">Company Name <span class="text-amber">*</span></label>
        <input type="text" name="companyName" required placeholder="e.g. Apex Tech Components Ltd" class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm focus:border-primary focus:outline-none" />
      </div>
      <div>
        <label class="block text-xs font-semibold text-ink/70 uppercase font-mono mb-1.5">Contact Person</label>
        <input type="text" name="contactPerson" placeholder="e.g. Sanduni Wickrama" class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm focus:border-primary focus:outline-none" />
      </div>
      <div class="grid grid-cols-2 gap-3">
        <div>
          <label class="block text-xs font-semibold text-ink/70 uppercase font-mono mb-1.5">Email Address</label>
          <input type="email" name="email" placeholder="contact@supplier.com" class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm focus:border-primary focus:outline-none" />
        </div>
        <div>
          <label class="block text-xs font-semibold text-ink/70 uppercase font-mono mb-1.5">Phone Number</label>
          <input type="text" name="phone" placeholder="+94 11 234 5678" class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm focus:border-primary focus:outline-none" />
        </div>
      </div>
      <div class="grid grid-cols-2 gap-3">
        <div>
          <label class="block text-xs font-semibold text-ink/70 uppercase font-mono mb-1.5">Country / Origin <span class="text-amber">*</span></label>
          <select name="countryId" required class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm bg-white focus:border-primary focus:outline-none">
            <option value="">-- Select Country --</option>
            <c:forEach var="c" items="${countries}">
              <option value="${c.id}">${c.name} &middot; VAT ${c.vatPercentage}%</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="block text-xs font-semibold text-ink/70 uppercase font-mono mb-1.5">Initial Quality Rating</label>
          <input type="number" name="rating" step="0.1" min="1.0" max="5.0" value="5.0" class="w-full px-3.5 py-2.5 rounded-lg border border-line text-sm font-mono focus:border-primary focus:outline-none" />
        </div>
      </div>
      <div class="p-3.5 rounded-xl bg-bg border border-line text-xs text-ink/60">
        <div class="font-semibold text-ink mb-1 font-mono">Origin Policy</div>
        The selected vendor country determines customs tariffs and freight rates for Purchase Orders.
      </div>
      <div class="pt-3 border-t border-line flex items-center justify-end gap-3">
        <button type="button" onclick="toggleModal('addVendorModal')" class="px-4 py-2.5 rounded-lg border border-line text-xs font-semibold text-ink/70 hover:bg-bg transition">Cancel</button>
        <button type="submit" class="px-5 py-2.5 rounded-lg bg-primary text-white text-xs font-semibold hover:bg-primarydk shadow-sm shadow-primary/20 transition">Onboard Vendor</button>
      </div>
    </form>
  </div>
</div>

<script>
  function toggleModal(id) {
    var el = document.getElementById(id);
    if (el) el.classList.toggle('hidden');
  }
  function filterVendors() {
    var query = (document.getElementById('vendorSearch').value || '').toLowerCase();
    var status = (document.getElementById('statusFilter').value || 'ALL').toUpperCase();
    document.querySelectorAll('.vendor-row').forEach(function(row) {
      var matchQ = !query || row.textContent.toLowerCase().indexOf(query) !== -1;
      var matchS = status === 'ALL' || (row.dataset.status || '').toUpperCase() === status;
      row.style.display = (matchQ && matchS) ? '' : 'none';
    });
  }
</script>

<%@ include file="includes/footer.jspf" %>