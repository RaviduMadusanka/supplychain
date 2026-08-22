<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  if (request.getAttribute("products") == null) {
      response.sendRedirect(request.getContextPath() + "/vendor/products");
      return;
  }
  String pageTitle = "Contracted Products Catalog";
  String pageSubtitle = "Official technical specifications and items contracted for supply by your company";
  String activePage = "vendorproducts";
  String userName = "Supplier Partner";
  String userRole = "Vendor";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<!-- Top Header -->
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
  <div>
    <div class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-md bg-primary/10 text-primary text-[11px] font-mono font-semibold uppercase tracking-wider mb-1">
      Contracted Portfolio
    </div>
    <h2 class="text-xl font-display font-bold text-ink">Products Contracted to ${vendor.companyName}</h2>
    <p class="text-xs text-ink/50 mt-0.5"><%= pageSubtitle %></p>
  </div>
  
  <div class="flex items-center gap-2">
    <span class="text-xs font-mono font-bold px-3 py-1.5 rounded-lg bg-bg border border-line text-ink/70">
      ${products != null ? products.size() : 0} Contracted SKUs
    </span>
  </div>
</div>

<!-- Info Banner -->
<div class="mb-6 p-4 rounded-xl bg-slate-100 border border-line flex items-start gap-3 text-xs text-ink/70 leading-relaxed">
  <svg class="w-5 h-5 text-primary flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
  <div>
    <strong class="text-ink font-semibold">Master Catalog Notice:</strong> 
    Products and global SKUs are managed and authorized by Enterprise Administrators and Warehouse Logistics Coordinators. 
    Below are the verified products your organization is contracted to supply upon receiving Purchase Orders.
  </div>
</div>

<!-- Products Table Card -->
<div class="card overflow-hidden shadow-sm">
  <table class="w-full text-sm">
    <thead>
      <tr class="text-left text-white text-xs font-mono uppercase tracking-wider bg-gradient-to-r from-[#12172B] via-[#1B254B] to-[#1E2538] border-b border-slate-700">
        <th class="px-5 py-3.5 font-semibold text-slate-300">SKU Code</th>
        <th class="px-5 py-3.5 font-semibold text-white">Product Name</th>
        <th class="px-5 py-3.5 font-semibold text-teal">Category</th>
        <th class="px-5 py-3.5 font-semibold text-slate-200">Unit Weight</th>
        <th class="px-5 py-3.5 font-semibold text-slate-200">Safety Buffer</th>
        <th class="px-5 py-3.5 font-semibold text-right text-slate-300">Contract Status</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-line">
      <c:choose>
        <c:when test="${not empty products}">
          <c:forEach var="p" items="${products}">
            <tr class="hover:bg-bg/40 transition">
              <td class="px-5 py-3.5 font-mono text-xs font-bold text-primary">${p.sku}</td>
              <td class="px-5 py-3.5 font-medium text-ink flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-teal"></span>
                ${p.name}
              </td>
              <td class="px-5 py-3.5">
                <span class="tag tag-teal text-[10px]">${p.categoryName}</span>
              </td>
              <td class="px-5 py-3.5 font-mono text-xs text-ink/70">${p.weight} kg</td>
              <td class="px-5 py-3.5 font-mono text-xs text-ink font-semibold">${p.reorderLevel} units</td>
              <td class="px-5 py-3.5 text-right">
                <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-[10px] font-mono font-bold bg-teal/10 text-teal border border-teal/20">
                  <span class="w-1.5 h-1.5 rounded-full bg-teal"></span> Active Supply
                </span>
              </td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr>
            <td colspan="6" class="px-5 py-8 text-center text-xs text-ink/40">No products currently contracted under your supplier account.</td>
          </tr>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>

<%@ include file="includes/footer.jspf" %>