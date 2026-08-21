<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  String pageTitle = "Vendor Performance";
  String pageSubtitle = "Monitor supplier reliability, ratings, and operational status";
  String activePage = "vendorperf";
  
  // Try to get from session
  String userName = "Saman Kumara";
  String userRole = "Warehouse Manager";
  com.globaltrade.core.dto.UserDTO sessionUser = (com.globaltrade.core.dto.UserDTO) session.getAttribute("user");
  if (sessionUser != null) {
      userName = sessionUser.getFullName();
      userRole = sessionUser.getRole();
  }
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<div class="flex items-center justify-between mb-6">
  <div>
    <h2 class="text-xl font-display font-bold text-ink">Vendor Performance Overview</h2>
    <p class="text-sm text-ink/50 mt-0.5"><%= pageSubtitle %></p>
  </div>
</div>

<!-- KPI Cards -->
<div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
  <div class="card p-5 border-t-4 border-t-teal hover:shadow-md transition">
    <div class="text-xs text-ink/50 mb-1 font-mono uppercase tracking-wide">Average Rating</div>
    <div class="font-display text-3xl font-bold flex items-baseline gap-2">
      ${avgRating != null ? avgRating : '0.00'}
      <span class="text-amber text-lg">&#9733;</span>
    </div>
    <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Across ${totalVendors} suppliers</div>
  </div>
  
  <div class="card p-5 hover:shadow-md transition">
    <div class="text-xs text-ink/50 mb-1 font-mono uppercase tracking-wide flex items-center justify-between">
      Active Partners <span class="tag tag-teal"><span class="tag-dot"></span>Active</span>
    </div>
    <div class="font-display text-3xl font-bold text-ink">${activeCount != null ? activeCount : 0}</div>
    <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Currently approved</div>
  </div>
  
  <div class="card p-5 hover:shadow-md transition">
    <div class="text-xs text-ink/50 mb-1 font-mono uppercase tracking-wide flex items-center justify-between">
      Suspended <span class="tag tag-amber"><span class="tag-dot"></span>Alert</span>
    </div>
    <div class="font-display text-3xl font-bold ${suspendedCount > 0 ? 'text-amber' : 'text-ink'}">${suspendedCount != null ? suspendedCount : 0}</div>
    <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Action required</div>
  </div>
  
  <div class="card p-5 hover:shadow-md transition">
    <div class="text-xs text-ink/50 mb-1 font-mono uppercase tracking-wide">Total Suppliers</div>
    <div class="font-display text-3xl font-bold text-primary">${totalVendors != null ? totalVendors : 0}</div>
    <div class="text-[10px] text-ink/40 font-mono mt-1 uppercase">Global network</div>
  </div>
</div>

<div class="flex items-center gap-3 mb-5">
  <input type="text" id="perfSearch" onkeyup="filterPerformance()" placeholder="Search by vendor code or company name..." class="flex-1 px-3.5 py-2 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
</div>

<div class="bg-white rounded-2xl border border-line shadow-sm overflow-hidden">
  <table class="w-full text-sm">
    <thead>
      <tr class="text-left text-white/80 text-xs font-mono uppercase tracking-wider border-b border-ink bg-ink">
        <th class="px-5 py-3.5">Vendor</th>
        <th class="px-5 py-3.5">Origin</th>
        <th class="px-5 py-3.5">Quality Rating</th>
        <th class="px-5 py-3.5 w-1/4">Performance Bar</th>
        <th class="px-5 py-3.5">Status</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-line">
      <c:choose>
        <c:when test="${not empty vendors}">
          <c:forEach var="v" items="${vendors}">
            <tr class="perf-row hover:bg-bg/60 transition">
              <td class="px-5 py-4">
                <div class="font-medium text-ink">${v.companyName}</div>
                <div class="font-mono text-[10px] text-primary font-semibold mt-0.5">${v.vendorCode}</div>
              </td>
              <td class="px-5 py-4 text-ink/70">
                <div class="flex items-center gap-1.5 text-xs">
                  <span class="text-sm">&#127760;</span> ${v.countryName}
                </div>
              </td>
              <td class="px-5 py-4">
                <span class="font-mono font-bold ${v.rating >= 4.0 ? 'text-teal' : (v.rating >= 2.5 ? 'text-ink' : 'text-amber')} text-base">${v.rating}</span>
                <span class="text-amber ml-0.5">&#9733;</span>
              </td>
              <td class="px-5 py-4">
                <div class="w-full bg-line rounded-full h-2.5 mb-1 overflow-hidden">
                  <div class="h-2.5 rounded-full ${v.rating >= 4.0 ? 'bg-teal' : (v.rating >= 2.5 ? 'bg-primary' : 'bg-amber')}" style="width: ${(v.rating / 5.0) * 100}%"></div>
                </div>
                <div class="text-[10px] text-ink/50 font-mono text-right">${(v.rating / 5.0) * 100}% Satisfaction</div>
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
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr>
            <td colspan="5" class="p-12 text-center text-ink/50 text-sm">
              No performance records available.
            </td>
          </tr>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>

<script>
  function filterPerformance() {
    var query = (document.getElementById('perfSearch').value || '').toLowerCase();
    document.querySelectorAll('.perf-row').forEach(function(row) {
      var text = row.querySelector('td:first-child').textContent.toLowerCase();
      row.style.display = (!query || text.indexOf(query) !== -1) ? '' : 'none';
    });
  }
</script>

<%@ include file="includes/footer.jspf" %>