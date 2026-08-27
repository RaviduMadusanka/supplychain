<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  String pageTitle = "Audit Logs & System Monitoring";
  String pageSubtitle = "Activity stream and exception tracking via EJB Interceptors";
  String activePage = "monitoring";
  String userName = "Enterprise Admin";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
  <div>
    <h2 class="text-xl font-display font-bold text-ink">System Monitoring &amp; Security Logs</h2>
    <p class="text-sm text-ink/50 mt-0.5"><%= pageSubtitle %></p>
  </div>

  <div class="flex bg-white p-1 rounded-xl border border-line shadow-xs">
    <button type="button" id="tabAuditBtn" onclick="switchMonitorTab('audit')" class="px-4 py-2 text-xs font-bold rounded-lg bg-primary text-white transition flex items-center gap-2">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
      <span>EJB Audit Trail (${auditLogs != null ? auditLogs.size() : 0})</span>
    </button>
    <button type="button" id="tabExBtn" onclick="switchMonitorTab('exception')" class="px-4 py-2 text-xs font-semibold rounded-lg text-ink/60 hover:text-ink transition flex items-center gap-2">
      <svg class="w-4 h-4 text-amber" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
      <span>Exception Logs (${exceptionLogs != null ? exceptionLogs.size() : 0})</span>
    </button>
  </div>
</div>

<div id="tabAuditView" class="space-y-4">
  <div class="card p-4 bg-white flex flex-col lg:flex-row items-center justify-between gap-4 shadow-sm">
    <div class="flex items-center gap-1.5 w-full lg:w-auto">
      <button type="button" id="btnToday" onclick="setFilterMode('today')" class="date-btn px-3.5 py-1.5 text-xs font-semibold rounded-lg bg-primary text-white transition shadow-sm">Today</button>
      <button type="button" id="btnYesterday" onclick="setFilterMode('yesterday')" class="date-btn px-3.5 py-1.5 text-xs font-medium rounded-lg text-ink/70 hover:bg-bg border border-line transition">Yesterday</button>
      <button type="button" id="btnAll" onclick="setFilterMode('all')" class="date-btn px-3.5 py-1.5 text-xs font-medium rounded-lg text-ink/70 hover:bg-bg border border-line transition">All Time</button>
    </div>

    <div class="flex flex-col sm:flex-row items-center gap-3 w-full lg:w-auto flex-1 justify-end">
      <div class="flex items-center gap-2 w-full sm:w-auto">
        <span class="text-xs text-ink/50 font-mono whitespace-nowrap">Pick Date:</span>
        <input type="date" id="customDatePicker" onchange="setCustomDate(this.value)" class="px-3 py-1.5 rounded-lg border border-line bg-bg/50 text-xs font-mono text-ink focus:outline-none focus:ring-2 focus:ring-primary/20 w-full sm:w-auto" />
      </div>

      <div class="relative w-full sm:w-72">
        <input type="text" id="logSearch" onkeyup="applyFilters()" placeholder="Search action, entity, user..." class="w-full pl-8 pr-3.5 py-1.5 rounded-lg border border-line bg-bg/50 text-xs focus:outline-none focus:ring-2 focus:ring-primary/20" />
        <svg class="w-3.5 h-3.5 text-ink/40 absolute left-2.5 top-2.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
      </div>

      <span id="logCountBadge" class="text-xs font-mono font-semibold px-2.5 py-1 bg-bg border border-line rounded text-ink/70">
        ${auditLogs != null ? auditLogs.size() : 0} logs
      </span>
    </div>
  </div>

  <div class="card overflow-hidden shadow-sm">
    <div class="max-h-[600px] overflow-y-auto scrollnice">
      <table class="w-full text-sm">
        <thead class="sticky top-0 z-10 shadow-md">
          <tr class="text-left text-white text-xs font-mono uppercase tracking-wider bg-gradient-to-r from-[#12172B] via-[#1B254B] to-[#1E2538] border-b border-slate-700">
            <th class="px-5 py-3.5 font-semibold w-44 text-slate-300">Timestamp</th>
            <th class="px-5 py-3.5 font-semibold text-white">Performed By</th>
            <th class="px-5 py-3.5 font-semibold text-teal">Action</th>
            <th class="px-5 py-3.5 font-semibold text-slate-200">Entity</th>
            <th class="px-5 py-3.5 font-semibold text-slate-200">Event Details</th>
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
                  <td class="px-5 py-3 font-mono text-xs text-ink/60 whitespace-nowrap">
                    ${log.performedAt.toString().replace('T', ' ')}
                  </td>
                  <td class="px-5 py-3">
                    <div class="font-medium text-ink">${log.performedByFullName}</div>
                    <div class="text-xs font-mono text-primary">${log.performedByUserName}</div>
                  </td>
                  <td class="px-5 py-3">
                    <c:choose>
                      <c:when test="${log.action == 'CREATE'}"><span class="tag tag-teal"><span class="tag-dot"></span>Created</span></c:when>
                      <c:when test="${log.action == 'UPDATE' || log.action == 'UPDATE_STATUS'}"><span class="tag tag-blue"><span class="tag-dot"></span>Updated</span></c:when>
                      <c:when test="${log.action == 'DELETE'}"><span class="tag tag-amber"><span class="tag-dot"></span>Deleted</span></c:when>
                      <c:when test="${log.action == 'EXECUTE_TIMER'}"><span class="tag tag-slate"><span class="tag-dot"></span>Timer Run</span></c:when>
                      <c:otherwise><span class="tag tag-slate"><span class="tag-dot"></span>${log.action}</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td class="px-5 py-3 font-mono text-xs text-ink/70">${log.entityName} #${log.entityId}</td>
                  <td class="px-5 py-3 text-xs text-ink/80 max-w-md truncate" title="${log.details}">
                    ${log.details}
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr>
                <td colspan="5" class="px-5 py-8 text-center text-ink/40 text-xs">No audit logs found.</td>
              </tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </div>
</div>

<div id="tabExceptionView" class="hidden space-y-4">
  <div class="p-4 rounded-xl bg-amber/5 border border-amber/20 flex items-center justify-between text-xs text-amber leading-relaxed">
    <div class="flex items-center gap-2">
      <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
      <span><strong>ExceptionLoggingInterceptor:</strong> Automatically intercepts and logs EJB container and business exceptions into the PostgreSQL database without dropping transactional integrity.</span>
    </div>
  </div>

  <div class="card overflow-hidden shadow-sm">
    <div class="max-h-[600px] overflow-y-auto scrollnice">
      <table class="w-full text-sm">
        <thead class="sticky top-0 z-10 shadow-md">
          <tr class="text-left text-white text-xs font-mono uppercase tracking-wider bg-gradient-to-r from-[#12172B] via-[#1B254B] to-[#1E2538] border-b border-slate-700">
            <th class="px-5 py-3.5 font-semibold w-44 text-slate-300">Occurred At</th>
            <th class="px-5 py-3.5 font-semibold text-white">Source EJB Component</th>
            <th class="px-5 py-3.5 font-semibold text-amber">Exception Type</th>
            <th class="px-5 py-3.5 font-semibold text-slate-200">Error Message</th>
            <th class="px-5 py-3.5 font-semibold text-right text-slate-300">Stack Trace</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-line">
          <c:choose>
            <c:when test="${not empty exceptionLogs}">
              <c:forEach var="ex" items="${exceptionLogs}">
                <tr class="hover:bg-bg/40 transition">
                  <td class="px-5 py-3.5 font-mono text-xs text-ink/60 whitespace-nowrap">
                    ${ex.occurredAt != null ? ex.occurredAt.toString().replace('T', ' ') : 'N/A'}
                  </td>
                  <td class="px-5 py-3.5 font-mono text-xs font-semibold text-primary">
                    ${ex.sourceComponent}
                  </td>
                  <td class="px-5 py-3.5">
                    <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold bg-amber/10 text-amber border border-amber/20">
                      ${ex.exceptionType.substring(ex.exceptionType.lastIndexOf('.') + 1)}
                    </span>
                  </td>
                  <td class="px-5 py-3.5 text-xs text-ink/80 max-w-sm truncate" title="${ex.message}">
                    ${ex.message}
                  </td>
                  <td class="px-5 py-3.5 text-right">
                    <button type="button" onclick="toggleTrace('trace-${ex.id}')" class="px-2.5 py-1 rounded-lg border border-line text-[11px] font-mono hover:bg-bg text-ink/70">
                      View Trace &darr;
                    </button>
                  </td>
                </tr>

                <tr id="trace-${ex.id}" style="display:none;" class="bg-slate-900 text-slate-100">
                  <td colspan="5" class="p-4 font-mono text-[11px] leading-relaxed overflow-x-auto whitespace-pre-wrap">
                    <div class="text-amber font-bold mb-1">${ex.exceptionType}: ${ex.message}</div>
                    <div class="text-slate-400">${ex.stackTrace}</div>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr>
                <td colspan="5" class="px-5 py-12 text-center text-ink/40 text-xs">
                  No system exceptions logged. All EJB components running normally.
                </td>
              </tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script>
  function switchMonitorTab(tab) {
    const auditView = document.getElementById('tabAuditView');
    const exView = document.getElementById('tabExceptionView');
    const tabAuditBtn = document.getElementById('tabAuditBtn');
    const tabExBtn = document.getElementById('tabExBtn');

    if (tab === 'audit') {
      auditView.classList.remove('hidden');
      exView.classList.add('hidden');
      tabAuditBtn.classList.add('bg-primary', 'text-white');
      tabAuditBtn.classList.remove('text-ink/60');
      tabExBtn.classList.remove('bg-primary', 'text-white');
      tabExBtn.classList.add('text-ink/60');
    } else {
      auditView.classList.add('hidden');
      exView.classList.remove('hidden');
      tabExBtn.classList.add('bg-primary', 'text-white');
      tabExBtn.classList.remove('text-ink/60');
      tabAuditBtn.classList.remove('bg-primary', 'text-white');
      tabAuditBtn.classList.add('text-ink/60');
    }
  }

  function toggleTrace(id) {
    const row = document.getElementById(id);
    if (!row) return;
    row.style.display = (row.style.display === 'none' || row.style.display === '') ? 'table-row' : 'none';
  }

  let currentFilter = 'today';
  let customDateValue = '';

  function setFilterMode(mode) {
    currentFilter = mode;
    customDateValue = '';
    document.getElementById('customDatePicker').value = '';
    
    document.querySelectorAll('.date-btn').forEach(b => {
      b.classList.remove('bg-primary', 'text-white', 'shadow-sm');
      b.classList.add('text-ink/70', 'border', 'border-line');
    });

    const btnMap = {
      'today': document.getElementById('btnToday'),
      'yesterday': document.getElementById('btnYesterday'),
      'all': document.getElementById('btnAll')
    };

    if (btnMap[mode]) {
      btnMap[mode].classList.add('bg-primary', 'text-white', 'shadow-sm');
      btnMap[mode].classList.remove('text-ink/70', 'border', 'border-line');
    }

    applyFilters();
  }

  function setCustomDate(val) {
    if (!val) return;
    currentFilter = 'custom';
    customDateValue = val;
    
    document.querySelectorAll('.date-btn').forEach(b => {
      b.classList.remove('bg-primary', 'text-white', 'shadow-sm');
      b.classList.add('text-ink/70', 'border', 'border-line');
    });

    applyFilters();
  }

  function applyFilters() {
    const query = document.getElementById('logSearch').value.toLowerCase().trim();
    const rows = document.querySelectorAll('.log-row');

    const todayStr = new Date().toISOString().split('T')[0];
    const yestDate = new Date();
    yestDate.setDate(yestDate.getDate() - 1);
    const yestStr = yestDate.toISOString().split('T')[0];

    let visibleCount = 0;

    rows.forEach(row => {
      const rowDate = row.dataset.date;
      const user = row.dataset.user;
      const action = row.dataset.action;
      const entity = row.dataset.entity;
      const details = row.dataset.details;

      let dateMatch = false;
      if (currentFilter === 'all') {
        dateMatch = true;
      } else if (currentFilter === 'today') {
        dateMatch = (rowDate === todayStr);
      } else if (currentFilter === 'yesterday') {
        dateMatch = (rowDate === yestStr);
      } else if (currentFilter === 'custom') {
        dateMatch = (rowDate === customDateValue);
      }

      let searchMatch = true;
      if (query) {
        searchMatch = user.includes(query) || action.includes(query) || entity.includes(query) || details.includes(query) || rowDate.includes(query);
      }

      if (dateMatch && searchMatch) {
        row.style.display = '';
        visibleCount++;
      } else {
        row.style.display = 'none';
      }
    });

    document.getElementById('logCountBadge').innerText = visibleCount + ' logs';
  }

  document.addEventListener('DOMContentLoaded', () => {
    const todayStr = new Date().toISOString().split('T')[0];
    const todayRows = Array.from(document.querySelectorAll('.log-row')).filter(r => r.dataset.date === todayStr);
    if (todayRows.length === 0) {
      setFilterMode('all');
    } else {
      setFilterMode('today');
    }
  });
</script>

<%@ include file="includes/footer.jspf" %>