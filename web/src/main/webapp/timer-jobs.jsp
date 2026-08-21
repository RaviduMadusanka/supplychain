<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  String pageTitle = "Timer Services";
  String pageSubtitle = "EJB Timer Service Registry · Background automation & scheduled batch tasks";
  String activePage = "timers";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
  <div>
    <h2 class="text-xl font-display font-bold text-ink">EJB Timer Services &amp; Scheduling</h2>
    <p class="text-sm text-ink/50 mt-0.5"><%= pageSubtitle %></p>
  </div>
  <div class="flex items-center gap-2">
    <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-teal/10 border border-teal/20 text-teal text-xs font-mono font-semibold">
      <span class="w-2 h-2 rounded-full bg-teal animate-pulse"></span>
      Container Timers Active
    </span>
  </div>
</div>

<!-- Alerts -->
<c:if test="${not empty param.success}">
  <div class="mb-5 p-4 rounded-xl bg-teal/10 border border-teal/30 text-teal flex items-center justify-between text-sm font-medium shadow-xs">
    <div class="flex items-center gap-2">
      <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
      <span>${param.success}</span>
    </div>
    <button onclick="this.parentElement.remove()" class="text-teal/60 hover:text-teal">&times;</button>
  </div>
</c:if>
<c:if test="${not empty param.error}">
  <div class="mb-5 p-4 rounded-xl bg-amber/10 border border-amber/30 text-amber flex items-center justify-between text-sm font-medium shadow-xs">
    <div class="flex items-center gap-2">
      <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
      <span>${param.error}</span>
    </div>
    <button onclick="this.parentElement.remove()" class="text-amber/60 hover:text-amber">&times;</button>
  </div>
</c:if>

<!-- Timer KPI Cards -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
  <div class="card p-4 flex items-center justify-between hover:shadow-md transition">
    <div>
      <div class="text-xs text-ink/50 font-mono uppercase tracking-wide">Registered Timers</div>
      <div class="font-display text-2xl font-bold text-ink mt-0.5">${timerJobs != null ? timerJobs.size() : 4}</div>
      <div class="text-[10px] text-ink/40 font-mono mt-0.5">Automated batch jobs</div>
    </div>
    <div class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center font-bold">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
    </div>
  </div>

  <div class="card p-4 flex items-center justify-between hover:shadow-md transition">
    <div>
      <div class="text-xs text-ink/50 font-mono uppercase tracking-wide">Execution Mode</div>
      <div class="font-display text-2xl font-bold text-teal mt-0.5">EJB Singletons</div>
      <div class="text-[10px] text-ink/40 font-mono mt-0.5">Container Managed</div>
    </div>
    <div class="w-10 h-10 rounded-xl bg-teal/10 text-teal flex items-center justify-center font-bold">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
    </div>
  </div>

  <div class="card p-4 flex items-center justify-between hover:shadow-md transition">
    <div>
      <div class="text-xs text-ink/50 font-mono uppercase tracking-wide">Cluster Resilience</div>
      <div class="font-display text-2xl font-bold text-ink mt-0.5">High Availability</div>
      <div class="text-[10px] text-ink/40 font-mono mt-0.5">99.9% Uptime target</div>
    </div>
    <div class="w-10 h-10 rounded-xl bg-amber/10 text-amber flex items-center justify-center font-bold">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
    </div>
  </div>
</div>

<!-- Timer Jobs List -->
<div class="space-y-4">
  <c:choose>
    <c:when test="${not empty timerJobs}">
      <c:forEach var="job" items="${timerJobs}">
        <div class="card p-5 hover:border-primary/50 transition duration-200 shadow-sm">
          <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-4">
            <div class="flex items-center gap-3.5">
              <span class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center flex-shrink-0">
                <c:choose>
                  <c:when test="${job.jobType == 'INVENTORY_CHECK'}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
                  </c:when>
                  <c:when test="${job.jobType == 'VENDOR_EVAL'}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14"/></svg>
                  </c:when>
                  <c:when test="${job.jobType == 'SHIPMENT_TRACKING'}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10a1 1 0 001 1h1m8-1a1 1 0 01-1 1H9m4-1V8a1 1 0 011-1h2.586a1 1 0 01.707.293l3.414 3.414a1 1 0 01.293.707V16a1 1 0 01-1 1h-1m-6-1a1 1 0 001 1h1M5 17a2 2 0 104 0m-4 0a2 2 0 114 0m6 0a2 2 0 104 0m-4 0a2 2 0 114 0"/></svg>
                  </c:when>
                  <c:otherwise>
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                  </c:otherwise>
                </c:choose>
              </span>
              <div>
                <div class="font-display font-bold text-sm text-ink">${job.jobName}</div>
                <div class="text-[11px] text-ink/50 font-mono mt-0.5 flex items-center gap-2">
                  <span>Type: <strong class="text-primary font-semibold">${job.jobType}</strong></span>
                  <span>&bull;</span>
                  <span>Persistence: ${job.isPersistent ? 'Database' : 'In-Memory (Container)'}</span>
                </div>
              </div>
            </div>
            
            <div class="flex items-center gap-2">
              <span class="tag tag-blue"><span class="tag-dot"></span>${job.creationType}</span>
              <c:choose>
                <c:when test="${job.status == 'SCHEDULED'}">
                  <span class="tag tag-teal"><span class="tag-dot"></span>Active Schedule</span>
                </c:when>
                <c:otherwise>
                  <span class="tag tag-amber"><span class="tag-dot"></span>Paused</span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <!-- Execution Metrics Grid -->
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 text-xs pt-4 border-t border-line bg-bg/30 p-3 rounded-xl">
            <div>
              <div class="text-[10px] text-ink/40 font-mono uppercase tracking-wider mb-1">Schedule Interval</div>
              <div class="font-mono font-medium text-ink/80 text-xs">${job.scheduleExpression}</div>
            </div>
            <div>
              <div class="text-[10px] text-ink/40 font-mono uppercase tracking-wider mb-1">Last Executed</div>
              <div class="font-mono text-xs">
                <c:choose>
                  <c:when test="${not empty job.lastRunAt}">
                    ${job.lastRunAt.toString().replace('T', ' ')}
                    <span class="text-teal font-bold ml-1">&#10003; ${job.lastRunStatus}</span>
                  </c:when>
                  <c:otherwise>
                    <span class="text-ink/40">Never</span>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
            <div>
              <div class="text-[10px] text-ink/40 font-mono uppercase tracking-wider mb-1">Next Expected Trigger</div>
              <div class="font-mono text-xs text-primary font-medium">
                <c:choose>
                  <c:when test="${not empty job.nextRunAt}">
                    ${job.nextRunAt.toString().replace('T', ' ')}
                  </c:when>
                  <c:otherwise>
                    Scheduled
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
            
            <!-- Actions -->
            <div class="flex items-center justify-start sm:justify-end gap-2">
              <form action="${pageContext.request.contextPath}/timers/trigger" method="POST" class="inline">
                <input type="hidden" name="jobType" value="${job.jobType}" />
                <button type="submit" class="px-3.5 py-1.5 rounded-lg bg-primary text-white text-xs font-semibold hover:bg-primarydk shadow-xs transition inline-flex items-center gap-1.5" title="Trigger immediately on demand">
                  <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                  Run Now
                </button>
              </form>

              <form action="${pageContext.request.contextPath}/timers/toggle" method="POST" class="inline">
                <input type="hidden" name="jobId" value="${job.id}" />
                <button type="submit" class="px-3 py-1.5 rounded-lg border border-line text-xs font-medium bg-white hover:bg-bg text-ink/70 transition shadow-xs">
                  ${job.status == 'PAUSED' ? 'Resume' : 'Pause'}
                </button>
              </form>
            </div>
          </div>
        </div>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <div class="card p-12 text-center text-ink/50 text-sm">
        No timer services registered in the container.
      </div>
    </c:otherwise>
  </c:choose>
</div>

<%@ include file="includes/footer.jspf" %>