<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  String pageTitle = "Audit Logs & Monitoring";
  String pageSubtitle = "System activity tracked via EJB Interceptors";
  String activePage = "monitoring";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
  <div>
    <h2 class="text-xl font-display font-bold text-ink">System Audit Trail</h2>
    <p class="text-sm text-ink/50 mt-0.5"><%= pageSubtitle %></p>
  </div>
  <div class="flex items-center gap-2">
    <span class="text-xs text-ink/60 font-medium">Active Filter:</span>
    <span id="activeFilterLabel" class="tag tag-blue font-semibold">Today</span>
    <span id="logCountBadge" class="text-xs font-mono font-semibold px-2 py-0.5 bg-bg border border-line rounded text-ink/70">0 records</span>
  </div>
</div>

<!-- Filter Controls Bar -->
<div class="card p-4 mb-6 bg-white flex flex-col lg:flex-row items-center justify-between gap-4 shadow-sm">
  <!-- Quick Date Buttons -->
  <div class="flex items-center gap-1.5 w-full lg:w-auto">
    <button type="button" id="btnToday" onclick="setFilterMode('today')" class="date-btn px-3.5 py-1.5 text-xs font-semibold rounded-lg bg-primary text-white transition shadow-sm">Today</button>
    <button type="button" id="btnYesterday" onclick="setFilterMode('yesterday')" class="date-btn px-3.5 py-1.5 text-xs font-medium rounded-lg text-ink/70 hover:bg-bg border border-line transition">Yesterday</button>
    <button type="button" id="btnAll" onclick="setFilterMode('all')" class="date-btn px-3.5 py-1.5 text-xs font-medium rounded-lg text-ink/70 hover:bg-bg border border-line transition">All Time</button>
  </div>

  <div class="flex flex-col sm:flex-row items-center gap-3 w-full lg:w-auto flex-1 justify-end">
    <!-- Date Picker for custom date selection -->
    <div class="flex items-center gap-2 w-full sm:w-auto">
      <span class="text-xs text-ink/50 font-mono whitespace-nowrap">Pick Date:</span>
      <input type="date" id="customDatePicker" onchange="setCustomDate(this.value)" class="px-3 py-1.5 rounded-lg border border-line bg-bg/50 text-xs font-mono text-ink focus:outline-none focus:ring-2 focus:ring-primary/20 w-full sm:w-auto" />
    </div>

    <!-- Keyword Search -->
    <div class="relative w-full sm:w-72">
      <input type="text" id="logSearch" onkeyup="applyFilters()" placeholder="Search action, entity, user..." class="w-full pl-8 pr-3.5 py-1.5 rounded-lg border border-line bg-bg/50 text-xs focus:outline-none focus:ring-2 focus:ring-primary/20" />
      <svg class="w-3.5 h-3.5 text-ink/40 absolute left-2.5 top-2.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
    </div>
  </div>
</div>

<div class="card overflow-hidden">
  <div class="max-h-[600px] overflow-y-auto scrollnice">
    <table class="w-full text-sm">
      <thead class="sticky top-0 bg-bg/95 backdrop-blur-sm z-10 shadow-sm">
        <tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
          <th class="px-5 py-3 font-medium w-44">Timestamp</th>
          <th class="px-5 py-3 font-medium">User</th>
          <th class="px-5 py-3 font-medium">Action</th>
          <th class="px-5 py-3 font-medium">Entity</th>
          <th class="px-5 py-3 font-medium">Details</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-line" id="auditTableBody">
        <c:choose>
          <c:when test="${not empty auditLogs}">
            <c:forEach var="log" items="${auditLogs}">
              <tr class="log-row hover:bg-bg/50 transition" 
                  data-date="${log.performedAt.toString().substring(0, 10)}"
                  data-user="${log.performedByFullName.toLowerCase()} ${log.performedByUserName.toLowerCase()}"
                  data-action="${log.action.toLowerCase()}"
                  data-entity="${log.entityName.toLowerCase()}"
                  data-details="${log.details.toLowerCase()}">
                <td class="px-5 py-3 text-xs font-mono text-ink/60 whitespace-nowrap">
                  ${log.performedAt.toString().replace('T', ' ').substring(0, 19)}
                </td>
                <td class="px-5 py-3">
                  <div class="font-medium text-ink">${log.performedByFullName}</div>
                  <div class="text-[10px] text-ink/50 font-mono">${log.performedByUserName}</div>
                </td>
                <td class="px-5 py-3">
                  <span class="px-2 py-0.5 rounded text-[10px] font-bold font-mono uppercase tracking-wider
                    ${log.action.toUpperCase() == 'CREATE' ? 'bg-teal/10 text-teal' : 
                      (log.action.toUpperCase() == 'UPDATE' || log.action.toUpperCase() == 'UPDATE_STATUS' ? 'bg-blue-500/10 text-blue-600' : 
                      (log.action.toUpperCase() == 'DELETE' ? 'bg-amber/10 text-amber' : 'bg-ink/10 text-ink/70'))}">
                    ${log.action}
                  </span>
                </td>
                <td class="px-5 py-3">
                  <div class="font-mono text-xs text-primary font-semibold">${log.entityName}</div>
                  <c:if test="${log.entityId != 0}">
                    <div class="text-[10px] text-ink/40 mt-0.5">ID: ${log.entityId}</div>
                  </c:if>
                </td>
                <td class="px-5 py-3 text-xs text-ink/70 max-w-sm truncate" title="${log.details}">
                  ${log.details}
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr><td colspan="5" class="p-10 text-center text-ink/50 text-sm">No audit logs recorded in the system yet.</td></tr>
          </c:otherwise>
        </c:choose>
        
        <!-- Placeholder row when filtering returns 0 rows -->
        <tr id="emptyFilterRow" class="hidden">
          <td colspan="5" class="p-12 text-center">
            <div class="text-ink/40 text-sm font-medium">No activity records found for the selected date or search criteria.</div>
            <button type="button" onclick="setFilterMode('all')" class="mt-2 text-xs text-primary font-semibold hover:underline">View All History &rarr;</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
  <div class="px-5 py-3 border-t border-line bg-bg/30 text-xs text-ink/50 flex justify-between items-center">
    <span>EJB Interceptor Activity Trail</span>
    <span class="font-mono flex items-center gap-1.5"><span class="w-1.5 h-1.5 rounded-full bg-teal"></span> Active Tracking</span>
  </div>
</div>

<script>
  var currentFilterMode = 'today';
  var customSelectedDate = '';

  function formatDate(d) {
    var year = d.getFullYear();
    var month = String(d.getMonth() + 1).padStart(2, '0');
    var day = String(d.getDate()).padStart(2, '0');
    return year + '-' + month + '-' + day;
  }

  var todayStr = formatDate(new Date());
  var yesterdayObj = new Date();
  yesterdayObj.setDate(yesterdayObj.getDate() - 1);
  var yesterdayStr = formatDate(yesterdayObj);

  function setFilterMode(mode) {
    currentFilterMode = mode;
    customSelectedDate = '';
    document.getElementById('customDatePicker').value = '';

    // Update active button styles
    document.querySelectorAll('.date-btn').forEach(function(b) {
      b.classList.remove('bg-primary', 'text-white', 'shadow-sm');
      b.classList.add('text-ink/70', 'border', 'border-line');
    });

    if (mode === 'today') {
      document.getElementById('btnToday').classList.add('bg-primary', 'text-white', 'shadow-sm');
      document.getElementById('btnToday').classList.remove('text-ink/70', 'border', 'border-line');
      document.getElementById('activeFilterLabel').textContent = 'Today (' + todayStr + ')';
    } else if (mode === 'yesterday') {
      document.getElementById('btnYesterday').classList.add('bg-primary', 'text-white', 'shadow-sm');
      document.getElementById('btnYesterday').classList.remove('text-ink/70', 'border', 'border-line');
      document.getElementById('activeFilterLabel').textContent = 'Yesterday (' + yesterdayStr + ')';
    } else if (mode === 'all') {
      document.getElementById('btnAll').classList.add('bg-primary', 'text-white', 'shadow-sm');
      document.getElementById('btnAll').classList.remove('text-ink/70', 'border', 'border-line');
      document.getElementById('activeFilterLabel').textContent = 'All Records';
    }

    applyFilters();
  }

  function setCustomDate(dateVal) {
    if (!dateVal) return;
    currentFilterMode = 'custom';
    customSelectedDate = dateVal;

    document.querySelectorAll('.date-btn').forEach(function(b) {
      b.classList.remove('bg-primary', 'text-white', 'shadow-sm');
      b.classList.add('text-ink/70', 'border', 'border-line');
    });

    document.getElementById('activeFilterLabel').textContent = 'Date: ' + dateVal;
    applyFilters();
  }

  function applyFilters() {
    var query = (document.getElementById('logSearch').value || '').toLowerCase().trim();
    var rows = document.querySelectorAll('.log-row');
    var visibleCount = 0;

    rows.forEach(function(row) {
      var rowDate = row.getAttribute('data-date') || '';
      var matchesDate = false;

      if (currentFilterMode === 'today') {
        matchesDate = (rowDate === todayStr);
      } else if (currentFilterMode === 'yesterday') {
        matchesDate = (rowDate === yesterdayStr);
      } else if (currentFilterMode === 'custom') {
        matchesDate = (rowDate === customSelectedDate);
      } else if (currentFilterMode === 'all') {
        matchesDate = true;
      }

      var userText = row.getAttribute('data-user') || '';
      var actionText = row.getAttribute('data-action') || '';
      var entityText = row.getAttribute('data-entity') || '';
      var detailsText = row.getAttribute('data-details') || '';
      
      var fullRowContent = userText + ' ' + actionText + ' ' + entityText + ' ' + detailsText + ' ' + rowDate;
      var matchesQuery = (!query || fullRowContent.indexOf(query) !== -1);

      if (matchesDate && matchesQuery) {
        row.style.display = '';
        visibleCount++;
      } else {
        row.style.display = 'none';
      }
    });

    document.getElementById('logCountBadge').textContent = visibleCount + ' records';
    var emptyRow = document.getElementById('emptyFilterRow');
    if (emptyRow) {
      if (visibleCount === 0) {
        emptyRow.classList.remove('hidden');
      } else {
        emptyRow.classList.add('hidden');
      }
    }
  }

  // Initial execution: filter for today
  document.addEventListener('DOMContentLoaded', function() {
    setFilterMode('today');
  });
</script>

<%@ include file="includes/footer.jspf" %>