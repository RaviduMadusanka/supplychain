<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  if (request.getAttribute("vendor") == null) {
      response.sendRedirect(request.getContextPath() + "/dashboard/vendor");
      return;
  }
  String pageTitle = "Vendor Dashboard";
  String pageSubtitle = "Procurement requests, supplier metrics & order fulfillment";
  String activePage = "dashboard";
  String userName = "Supplier Partner";
  String userRole = "Vendor";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<div class="relative overflow-hidden rounded-2xl bg-gradient-to-r from-[#12172B] via-[#1B254B] to-[#2547D0] text-white p-6 sm:p-8 mb-8 shadow-xl border border-white/10">
  <div class="relative z-10 flex flex-col lg:flex-row lg:items-center justify-between gap-6">
    <div>
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 backdrop-blur-md border border-white/15 text-[11px] font-mono text-teal tracking-wider uppercase mb-3">
        <span class="w-2 h-2 rounded-full bg-teal animate-pulse"></span>
        Verified Global Supplier Partner
      </div>
      <h2 class="text-2xl sm:text-3xl font-display font-extrabold tracking-tight text-white">
        ${vendor.companyName}
      </h2>
      <p class="text-sm text-white/70 mt-1 max-w-xl font-mono">
        Supplier Code: <strong class="text-white">${vendor.vendorCode}</strong> &middot; Region: <strong>${vendor.countryName}</strong> &middot; Contact: <strong>${vendor.contactPerson}</strong>
      </p>
    </div>

    <div class="flex items-center gap-3">
      <a href="${pageContext.request.contextPath}/vendor/products" class="px-4 py-2.5 rounded-xl bg-white text-ink hover:bg-slate-100 text-xs font-bold transition shadow-lg flex items-center gap-2">
        <svg class="w-4 h-4 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
        <span>Contracted Products</span>
      </a>
      <a href="${pageContext.request.contextPath}/purchase-orders" class="px-4 py-2.5 rounded-xl bg-white/10 hover:bg-white/20 backdrop-blur-md border border-white/20 text-white text-xs font-semibold transition flex items-center gap-2">
        <svg class="w-4 h-4 text-teal" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
        <span>Restock Orders</span>
      </a>
    </div>
  </div>
</div>

<c:if test="${not empty param.success}">
  <div class="mb-5 p-4 rounded-xl bg-teal/10 border border-teal/30 text-teal flex items-center justify-between text-sm font-medium shadow-xs">
    <div class="flex items-center gap-2">
      <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
      <span>${param.success}</span>
    </div>
    <button onclick="this.parentElement.remove()" class="text-teal/60 hover:text-teal">&times;</button>
  </div>
</c:if>

<div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5 mb-8">
  <div class="card p-5 relative overflow-hidden border-t-4 border-t-teal hover:shadow-md transition">
    <div class="text-[11px] text-ink/50 uppercase font-mono tracking-wider font-semibold mb-1">Overall Rating</div>
    <div class="flex items-baseline gap-2">
      <div class="font-display text-3xl font-extrabold text-teal">${vendor.rating != null ? vendor.rating : '4.50'}</div>
      <span class="text-xs text-teal font-semibold">&starf;&starf;&starf;&starf;&starf;</span>
    </div>
    <div class="text-[11px] text-ink/40 font-mono mt-1">EJB Evaluated Standing</div>
  </div>

  <div class="card p-5 relative overflow-hidden border-t-4 border-t-primary hover:shadow-md transition">
    <div class="text-[11px] text-ink/50 uppercase font-mono tracking-wider font-semibold mb-1">On-time Delivery</div>
    <div class="font-display text-3xl font-extrabold text-ink">${performance != null && performance.onTimeDeliveryRate != null ? performance.onTimeDeliveryRate : '98.5'}%</div>
    <div class="text-[11px] text-ink/40 font-mono mt-1">Reliability index</div>
  </div>

  <div class="card p-5 relative overflow-hidden border-t-4 border-t-amber hover:shadow-md transition">
    <div class="text-[11px] text-ink/50 uppercase font-mono tracking-wider font-semibold mb-1">Pending Action</div>
    <div class="font-display text-3xl font-extrabold ${openOrderCount > 0 ? 'text-amber' : 'text-ink'}">${openOrderCount}</div>
    <div class="text-[11px] text-ink/40 font-mono mt-1">${openOrderCount > 0 ? 'Orders awaiting acceptance' : 'All orders processed'}</div>
  </div>

  <div class="card p-5 relative overflow-hidden border-t-4 border-t-purple-500 hover:shadow-md transition">
    <div class="text-[11px] text-ink/50 uppercase font-mono tracking-wider font-semibold mb-1">Cataloged SKUs</div>
    <div class="font-display text-3xl font-extrabold text-ink">${vendorProducts != null ? vendorProducts.size() : 0}</div>
    <div class="text-[11px] text-ink/40 font-mono mt-1">Active products supplied</div>
  </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
  <div class="lg:col-span-2 space-y-6">
    <div class="card overflow-hidden shadow-sm">
      <div class="px-5 py-4 border-b border-line flex items-center justify-between bg-white">
        <div>
          <h3 class="font-display font-bold text-sm text-ink">Inbound Restock Purchase Orders</h3>
          <p class="text-xs text-ink/40 mt-0.5">Orders assigned to ${vendor.companyName} by warehouse managers</p>
        </div>
        <a href="${pageContext.request.contextPath}/purchase-orders" class="text-primary text-xs font-semibold hover:underline">View All &rarr;</a>
      </div>

      <table class="w-full text-sm">
        <thead>
          <tr class="text-left text-white text-xs font-mono uppercase tracking-wider bg-gradient-to-r from-[#12172B] via-[#1B254B] to-[#1E2538] border-b border-slate-700">
            <th class="px-5 py-3.5 font-semibold text-slate-300">PO Ref</th>
            <th class="px-5 py-3.5 font-semibold text-white">Destination WH</th>
            <th class="px-5 py-3.5 font-semibold text-teal">Amount</th>
            <th class="px-5 py-3.5 font-semibold text-slate-200">Status</th>
            <th class="px-5 py-3.5 font-semibold text-right text-slate-300">Action</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-line">
          <c:choose>
            <c:when test="${not empty vendorPOs}">
              <c:forEach var="po" items="${vendorPOs}">
                <tr class="hover:bg-bg/40 transition">
                  <td class="px-5 py-3.5 font-mono text-xs font-bold text-primary">${po.poCode}</td>
                  <td class="px-5 py-3.5 text-xs font-medium text-ink">${po.warehouseName}</td>
                  <td class="px-5 py-3.5 font-mono text-xs font-bold text-ink">
                    $${String.format("%,.2f", po.totalAmount)}
                  </td>
                  <td class="px-5 py-3.5">
                    <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-[10px] font-mono font-bold
                      ${po.status == 'COMPLETED' || po.status == 'DELIVERED' ? 'bg-teal/10 text-teal border border-teal/20' : 
                        (po.status == 'PROCESSING' || po.status == 'IN_TRANSIT' ? 'bg-blue-500/10 text-blue-600 border border-blue-500/20' : 
                        (po.status == 'PENDING' ? 'bg-amber/10 text-amber border border-amber/20' : 'bg-slate-100 text-slate-700'))}">
                      <span class="w-1.5 h-1.5 rounded-full ${po.status == 'COMPLETED' ? 'bg-teal' : (po.status == 'PENDING' ? 'bg-amber' : 'bg-blue-600')}"></span>
                      ${po.status}
                    </span>
                  </td>
                  <td class="px-5 py-3.5 text-right">
                    <c:choose>
                      <c:when test="${po.status == 'PENDING'}">
                        <div class="flex items-center justify-end gap-1.5">
                          <form action="${pageContext.request.contextPath}/purchase-orders/action" method="POST" class="inline">
                            <input type="hidden" name="action" value="accept" />
                            <input type="hidden" name="poId" value="${po.id}" />
                            <button type="submit" class="px-2.5 py-1 rounded bg-teal text-white text-[11px] font-bold hover:bg-teal/90 shadow-2xs transition">Accept</button>
                          </form>
                          <form action="${pageContext.request.contextPath}/purchase-orders/action" method="POST" class="inline">
                            <input type="hidden" name="action" value="reject" />
                            <input type="hidden" name="poId" value="${po.id}" />
                            <button type="submit" class="px-2.5 py-1 rounded bg-amber text-white text-[11px] font-bold hover:bg-amber/90 shadow-2xs transition">Reject</button>
                          </form>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <span class="text-xs text-ink/40 font-mono">&#10003; Acknowledged</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr>
                <td colspan="5" class="px-5 py-8 text-center text-xs text-ink/40">No purchase orders currently assigned to your vendor account.</td>
              </tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </div>

  <div class="space-y-6">
    <div class="card p-5 shadow-sm">
      <div class="border-b border-line pb-3 mb-4">
        <h3 class="font-display font-bold text-sm text-ink">Supplier Scorecard</h3>
        <p class="text-xs text-ink/40">Automated EJB performance tracking</p>
      </div>

      <div class="space-y-4">
        <div>
          <div class="flex items-center justify-between text-xs mb-1.5">
            <span class="text-ink/60 font-medium">On-time Delivery Rate</span>
            <span class="font-mono font-bold text-teal">${performance != null && performance.onTimeDeliveryRate != null ? performance.onTimeDeliveryRate : '98.5'}%</span>
          </div>
          <div class="w-full bg-bg rounded-full h-2 overflow-hidden border border-line">
            <div class="bg-teal h-2 rounded-full transition-all duration-500" style="width: ${performance != null && performance.onTimeDeliveryRate != null ? performance.onTimeDeliveryRate : '98.5'}%"></div>
          </div>
        </div>

        <div>
          <div class="flex items-center justify-between text-xs mb-1.5">
            <span class="text-ink/60 font-medium">Quality Compliance Score</span>
            <span class="font-mono font-bold text-primary">${performance != null && performance.qualityScore != null ? performance.qualityScore : '92.0'}%</span>
          </div>
          <div class="w-full bg-bg rounded-full h-2 overflow-hidden border border-line">
            <div class="bg-primary h-2 rounded-full transition-all duration-500" style="width: ${performance != null && performance.qualityScore != null ? performance.qualityScore : '92.0'}%"></div>
          </div>
        </div>

        <div class="pt-3 border-t border-line flex items-center justify-between text-xs">
          <span class="text-ink/60 font-medium">Average Response Time</span>
          <span class="font-mono font-bold text-ink">${performance != null && performance.responseTimeHours != null ? performance.responseTimeHours : '4.50'} hrs</span>
        </div>

        <div class="flex items-center justify-between text-xs">
          <span class="text-ink/60 font-medium">Supplier Compliance Standing</span>
          <span class="tag tag-teal text-[10px]">Tier 1 - Certified</span>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file="includes/footer.jspf" %>