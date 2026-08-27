<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  if (request.getAttribute("users") == null) {
      response.sendRedirect(request.getContextPath() + "/dashboard/admin");
      return;
  }
  String pageTitle = "Executive Admin Dashboard";
  String pageSubtitle = "System overview, business intelligence analytics & audit monitoring";
  String activePage = "dashboard";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="relative overflow-hidden rounded-2xl bg-gradient-to-r from-[#12172B] via-[#1B254B] to-[#2547D0] text-white p-6 sm:p-8 mb-8 shadow-xl border border-white/10">
  <!-- Ambient background glow spheres -->
  <div class="absolute -right-12 -top-12 w-64 h-64 bg-primary/30 rounded-full blur-3xl pointer-events-none"></div>
  <div class="absolute right-1/3 -bottom-16 w-56 h-56 bg-teal/20 rounded-full blur-2xl pointer-events-none"></div>

  <div class="relative z-10 flex flex-col lg:flex-row lg:items-center justify-between gap-6">
    <div>
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 backdrop-blur-md border border-white/15 text-[11px] font-mono text-teal tracking-wider uppercase mb-3">
        <span class="w-2 h-2 rounded-full bg-teal animate-pulse"></span>
        Enterprise Command Center &middot; Live
      </div>
      <h2 class="text-2xl sm:text-3xl font-display font-extrabold tracking-tight text-white">
        Welcome back, <span class="text-transparent bg-clip-text bg-gradient-to-r from-white via-slate-100 to-teal"><%= userName %></span>
      </h2>
      <p class="text-sm text-white/70 mt-1 max-w-xl font-normal leading-relaxed">
        Real-time global supply chain oversight, automated EJB timer telemetry, and role-based access management.
      </p>
    </div>

    <div class="flex flex-wrap items-center gap-3">
      <a href="${pageContext.request.contextPath}/users" class="px-4 py-2.5 rounded-xl bg-white text-ink hover:bg-slate-100 text-xs font-bold transition shadow-lg flex items-center gap-2 hover:scale-[1.02]">
        <svg class="w-4 h-4 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"/></svg>
        <span>Add WH Manager</span>
      </a>
      <a href="${pageContext.request.contextPath}/monitoring" class="px-4 py-2.5 rounded-xl bg-white/10 hover:bg-white/20 backdrop-blur-md border border-white/20 text-white text-xs font-semibold transition flex items-center gap-2">
        <svg class="w-4 h-4 text-teal" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
        <span>Audit Trail</span>
      </a>
      <a href="${pageContext.request.contextPath}/timers" class="px-4 py-2.5 rounded-xl bg-white/10 hover:bg-white/20 backdrop-blur-md border border-white/20 text-white text-xs font-semibold transition flex items-center gap-2">
        <svg class="w-4 h-4 text-amber" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        <span>Timers</span>
      </a>
    </div>
  </div>
</div>

<div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5 mb-8">
  <div class="relative overflow-hidden rounded-2xl bg-white border border-slate-200/80 p-5 shadow-sm hover:shadow-md hover:border-primary/40 transition group">
    <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-primary to-blue-400"></div>
    <div class="flex items-center justify-between mb-3">
      <span class="text-[11px] font-mono uppercase tracking-wider text-slate-500 font-semibold">Total Accounts</span>
      <span class="px-2 py-0.5 rounded-full text-[10px] font-mono font-bold bg-blue-50 text-primary border border-blue-100">RBAC Active</span>
    </div>
    <div class="flex items-baseline gap-2">
      <div class="font-display text-3xl font-extrabold text-ink">${users != null ? users.size() : 6}</div>
      <span class="text-xs text-emerald-600 font-semibold">&uarr; Verified</span>
    </div>
    <div class="text-[11px] text-slate-500 mt-2 flex items-center gap-1.5 font-medium">
      <span class="w-1.5 h-1.5 rounded-full bg-primary"></span>
      ${adminCount} Admins &middot; ${whCount} WH &middot; ${vendorUserCount} Vendors
    </div>
  </div>

  <div class="relative overflow-hidden rounded-2xl bg-white border border-slate-200/80 p-5 shadow-sm hover:shadow-md hover:border-teal/40 transition group">
    <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-teal to-emerald-400"></div>
    <div class="flex items-center justify-between mb-3">
      <span class="text-[11px] font-mono uppercase tracking-wider text-slate-500 font-semibold">Active Products</span>
      <span class="px-2 py-0.5 rounded-full text-[10px] font-mono font-bold bg-teal/10 text-teal border border-teal/20">Master SKUs</span>
    </div>
    <div class="flex items-baseline gap-2">
      <div class="font-display text-3xl font-extrabold text-teal">${products != null ? products.size() : 4}</div>
      <span class="text-xs text-slate-400 font-mono">Catalog items</span>
    </div>
    <div class="text-[11px] text-slate-500 mt-2 flex items-center gap-1.5 font-medium">
      <span class="w-1.5 h-1.5 rounded-full bg-teal"></span>
      Distributed across 3 regional hubs
    </div>
  </div>

  <div class="relative overflow-hidden rounded-2xl bg-white border border-slate-200/80 p-5 shadow-sm hover:shadow-md hover:border-amber/40 transition group">
    <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-amber to-orange-400"></div>
    <div class="flex items-center justify-between mb-3">
      <span class="text-[11px] font-mono uppercase tracking-wider text-slate-500 font-semibold">Stock Health Alerts</span>
      <span class="px-2 py-0.5 rounded-full text-[10px] font-mono font-bold ${lowStockCount > 0 ? 'bg-amber/10 text-amber border border-amber/20' : 'bg-emerald-50 text-emerald-600 border border-emerald-100'}">
        ${lowStockCount > 0 ? 'Attention Needed' : 'All Optimal'}
      </span>
    </div>
    <div class="flex items-baseline gap-2">
      <div class="font-display text-3xl font-extrabold ${lowStockCount > 0 ? 'text-amber' : 'text-ink'}">${lowStockCount}</div>
      <span class="text-xs ${lowStockCount > 0 ? 'text-amber font-semibold' : 'text-emerald-600 font-semibold'}">${lowStockCount > 0 ? 'Low stock items' : 'No shortages'}</span>
    </div>
    <div class="text-[11px] text-slate-500 mt-2 flex items-center gap-1.5 font-medium">
      <span class="w-1.5 h-1.5 rounded-full ${lowStockCount > 0 ? 'bg-amber' : 'bg-emerald-500'}"></span>
      Automated reorder thresholds
    </div>
  </div>

  <div class="relative overflow-hidden rounded-2xl bg-white border border-slate-200/80 p-5 shadow-sm hover:shadow-md hover:border-purple-400 transition group">
    <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-purple-500 to-indigo-500"></div>
    <div class="flex items-center justify-between mb-3">
      <span class="text-[11px] font-mono uppercase tracking-wider text-slate-500 font-semibold">EJB Timer Services</span>
      <span class="px-2 py-0.5 rounded-full text-[10px] font-mono font-bold bg-purple-50 text-purple-700 border border-purple-100">Automated</span>
    </div>
    <div class="flex items-baseline gap-2">
      <div class="font-display text-3xl font-extrabold text-ink">${timers != null ? timers.size() : 4}</div>
      <span class="text-xs text-emerald-600 font-semibold font-mono">100% Scheduled</span>
    </div>
    <div class="text-[11px] text-slate-500 mt-2 flex items-center gap-1.5 font-medium">
      <span class="w-1.5 h-1.5 rounded-full bg-purple-500"></span>
      Background cluster jobs active
    </div>
  </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
  <div class="lg:col-span-2 rounded-2xl bg-white border border-slate-200/80 p-6 shadow-sm flex flex-col justify-between">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-4 pb-3 border-b border-slate-100">
      <div>
        <h3 class="font-display font-bold text-base text-ink flex items-center gap-2">
          <span>Supply Chain Procurement &amp; Revenue Trend</span>
        </h3>
        <p class="text-xs text-slate-400 mt-0.5">Aggregated financial performance metrics &amp; fulfillment volumes ($ USD)</p>
      </div>
      <div class="flex items-center gap-2">
        <span class="text-[11px] font-mono font-semibold px-2.5 py-1 bg-slate-100 text-slate-700 rounded-lg">Fiscal 2026</span>
      </div>
    </div>
    <div class="relative h-64 w-full">
      <canvas id="revenueChart"></canvas>
    </div>
  </div>

  <div class="rounded-2xl bg-white border border-slate-200/80 p-6 shadow-sm flex flex-col justify-between">
    <div class="mb-2 pb-3 border-b border-slate-100">
      <h3 class="font-display font-bold text-base text-ink">User Access Distribution</h3>
      <p class="text-xs text-slate-400 mt-0.5">Role-based security accounts breakdown</p>
    </div>
    <div class="relative h-56 w-full flex items-center justify-center my-auto">
      <canvas id="rolesChart"></canvas>
    </div>
    <div class="grid grid-cols-2 gap-2 text-center text-xs pt-3 border-t border-slate-100 mt-2 bg-slate-50/60 p-2.5 rounded-xl">
      <div><span class="text-slate-400 text-[10px] uppercase font-mono block font-medium">Admins</span><strong class="text-primary font-bold">${adminCount}</strong></div>
      <div><span class="text-slate-400 text-[10px] uppercase font-mono block font-medium">WH Managers</span><strong class="text-teal font-bold">${whCount}</strong></div>
    </div>
  </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
  <div class="rounded-2xl bg-white border border-slate-200/80 p-6 shadow-sm flex flex-col justify-between">
    <div class="flex items-center justify-between mb-4 pb-3 border-b border-slate-100">
      <div>
        <h3 class="font-display font-bold text-base text-ink">Warehouse Inventory Capacity</h3>
        <p class="text-xs text-slate-400 mt-0.5">Stock units vs. minimum safety levels by global hub</p>
      </div>
      <span class="text-[11px] font-mono font-semibold px-2.5 py-1 bg-teal/10 text-teal rounded-md">Units</span>
    </div>
    <div class="relative h-64 w-full">
      <canvas id="warehouseChart"></canvas>
    </div>
  </div>

  <div class="rounded-2xl bg-white border border-slate-200/80 p-6 shadow-sm flex flex-col justify-between">
    <div class="flex items-center justify-between mb-4 pb-3 border-b border-slate-100">
      <div>
        <h3 class="font-display font-bold text-base text-ink flex items-center gap-2">
          <span>Live EJB Audit Stream</span>
          <span class="w-2 h-2 rounded-full bg-emerald-500 animate-ping"></span>
        </h3>
        <p class="text-xs text-slate-400 mt-0.5">Real-time security &amp; logistics activity intercepted</p>
      </div>
      <a href="${pageContext.request.contextPath}/monitoring" class="text-xs text-primary font-bold hover:underline flex items-center gap-1">
        Full Trail &rarr;
      </a>
    </div>

    <div class="space-y-2.5 overflow-y-auto max-h-[250px] pr-1 scrollnice">
      <c:choose>
        <c:when test="${not empty recentLogs}">
          <c:forEach var="log" items="${recentLogs}">
            <div class="flex items-start gap-3 p-3 rounded-xl hover:bg-slate-50/90 transition border border-slate-100 group">
              <span class="px-2 py-0.5 rounded text-[9px] font-bold font-mono uppercase mt-0.5 flex-shrink-0 shadow-2xs
                ${log.action.toUpperCase() == 'CREATE' ? 'bg-teal/15 text-teal border border-teal/30' : 
                  (log.action.toUpperCase() == 'UPDATE' || log.action.toUpperCase() == 'STOCK_UPDATE' ? 'bg-blue-500/15 text-blue-600 border border-blue-500/30' : 
                  (log.action.toUpperCase() == 'GOODS_RECEIVED' ? 'bg-purple-500/15 text-purple-600 border border-purple-500/30' : 'bg-slate-200 text-slate-700'))}">
                ${log.action}
              </span>
              <div class="flex-1 min-w-0">
                <div class="text-xs text-ink font-semibold truncate group-hover:text-primary transition" title="${log.details}">${log.details}</div>
                <div class="text-[10px] text-slate-400 font-mono mt-0.5 flex items-center gap-2">
                  <span>${log.performedByFullName}</span>
                  <span>&bull;</span>
                  <span>${log.performedAt.toString().replace('T', ' ')}</span>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="text-xs text-slate-400 p-8 text-center">No recent audit logs available.</div>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="pt-3 border-t border-slate-100 mt-3 flex items-center justify-between text-[11px] text-slate-400 font-mono">
      <span class="flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-teal"></span> Interceptors Active</span>
      <span>PostgreSQL Cluster: Synced</span>
    </div>
  </div>
</div>

<div class="rounded-2xl bg-[#12172B] text-white p-5 shadow-lg border border-slate-800 flex flex-col md:flex-row items-center justify-between gap-4">
  <div class="flex items-center gap-3.5">
    <div class="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center font-bold text-teal border border-white/10">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
    </div>
    <div>
      <div class="text-xs font-bold text-white font-display">NexTrade Global SCM Core Enterprise Platform</div>
      <div class="text-[11px] text-slate-400 font-mono mt-0.5">GlassFish 7.0 &middot; Jakarta EE 10 &middot; Hibernate PostgreSQL &middot; EJB 3.2 Stateless/Singleton</div>
    </div>
  </div>
  <div class="flex items-center gap-3">
    <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-500/20 text-emerald-400 text-xs font-mono font-semibold border border-emerald-500/30">
      <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
      Cluster Uptime: 99.9%
    </span>
  </div>
</div>

<script>
  const ctxRevenue = document.getElementById('revenueChart').getContext('2d');

  const revGradient = ctxRevenue.createLinearGradient(0, 0, 0, 260);
  revGradient.addColorStop(0, 'rgba(37, 71, 208, 0.25)');
  revGradient.addColorStop(1, 'rgba(37, 71, 208, 0.00)');

  new Chart(ctxRevenue, {
    type: 'line',
    data: {
      labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'],
      datasets: [
        {
          label: 'Customer Revenue ($)',
          data: [12500, 18200, 15400, 22100, 28400, 26700, 34200, 39500],
          borderColor: '#2547D0',
          backgroundColor: revGradient,
          borderWidth: 3,
          tension: 0.38,
          fill: true,
          pointBackgroundColor: '#ffffff',
          pointBorderColor: '#2547D0',
          pointBorderWidth: 2.5,
          pointRadius: 4,
          pointHoverRadius: 6
        },
        {
          label: 'Procurement Volume ($)',
          data: [8200, 11500, 9800, 14200, 19100, 16800, 22400, 25800],
          borderColor: '#0EA5A4',
          backgroundColor: 'transparent',
          borderWidth: 2.5,
          borderDash: [6, 6],
          tension: 0.38,
          pointBackgroundColor: '#ffffff',
          pointBorderColor: '#0EA5A4',
          pointBorderWidth: 2,
          pointRadius: 3.5,
          pointHoverRadius: 5
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      interaction: { mode: 'index', intersect: false },
      plugins: {
        legend: {
          position: 'top',
          labels: { font: { family: 'Inter', size: 11, weight: '600' }, boxWidth: 12, usePointStyle: true }
        }
      },
      scales: {
        x: {
          grid: { display: false },
          ticks: { font: { family: 'JetBrains Mono', size: 10 }, color: '#64748B' }
        },
        y: {
          grid: { color: '#F1F5F9' },
          ticks: { font: { family: 'JetBrains Mono', size: 10 }, color: '#64748B' }
        }
      }
    }
  });

  const ctxRoles = document.getElementById('rolesChart').getContext('2d');
  const adminVal = ${adminCount != null && adminCount > 0 ? adminCount : 2};
  const whVal = ${whCount != null && whCount > 0 ? whCount : 1};
  const vendorVal = ${vendorUserCount != null && vendorUserCount > 0 ? vendorUserCount : 2};
  const customerVal = ${customerCount != null && customerCount > 0 ? customerCount : 1};

  new Chart(ctxRoles, {
    type: 'doughnut',
    data: {
      labels: ['Admins', 'WH Managers', 'Vendors', 'Customers'],
      datasets: [{
        data: [adminVal, whVal, vendorVal, customerVal],
        backgroundColor: ['#2547D0', '#0EA5A4', '#E0572B', '#64748B'],
        borderWidth: 3,
        borderColor: '#ffffff',
        hoverOffset: 4
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: '72%',
      plugins: {
        legend: {
          position: 'bottom',
          labels: { font: { family: 'Inter', size: 10, weight: '600' }, boxWidth: 10, padding: 12 }
        }
      }
    }
  });

  const ctxWh = document.getElementById('warehouseChart').getContext('2d');
  new Chart(ctxWh, {
    type: 'bar',
    data: {
      labels: ['Colombo Central', 'Singapore Hub', 'Dubai Logistics'],
      datasets: [
        {
          label: 'In Stock (Units)',
          data: [420, 150, 85],
          backgroundColor: '#2547D0',
          borderRadius: 8,
          borderSkipped: false
        },
        {
          label: 'Safety Threshold',
          data: [50, 45, 30],
          backgroundColor: '#E2E8F0',
          borderRadius: 8,
          borderSkipped: false
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: 'top',
          labels: { font: { family: 'Inter', size: 11, weight: '600' }, boxWidth: 12 }
        }
      },
      scales: {
        x: {
          grid: { display: false },
          ticks: { font: { family: 'Inter', size: 11, weight: '500' }, color: '#1E293B' }
        },
        y: {
          grid: { color: '#F1F5F9' },
          ticks: { font: { family: 'JetBrains Mono', size: 10 }, color: '#64748B' }
        }
      }
    }
  });
</script>

<%@ include file="includes/footer.jspf" %>