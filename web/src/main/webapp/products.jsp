<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  String pageTitle = "Product Catalog";
  String pageSubtitle = "Explore global inventory, product specifications, categories & suppliers";
  String activePage = "catalog";
  String userName = "Admin";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
  <div>
    <h2 class="text-xl font-display font-bold text-ink">Product Catalog &amp; Specifications</h2>
    <p class="text-sm text-ink/50 mt-0.5"><%= pageSubtitle %></p>
  </div>
  
  <c:if test="${'ADMIN'.equalsIgnoreCase(userRole) || 'WAREHOUSE_MANAGER'.equalsIgnoreCase(userRole)}">
    <a href="${pageContext.request.contextPath}/product/add" class="inline-flex items-center gap-2 px-4 py-2 rounded-lg bg-primary text-white text-xs font-semibold hover:bg-primarydk shadow-sm transition">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
      Add New Product
    </a>
  </c:if>
</div>

<!-- KPI Summary Strip -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
  <div class="card p-4 flex items-center justify-between hover:shadow-md transition">
    <div>
      <div class="text-xs text-ink/50 font-mono uppercase tracking-wide">Total Products</div>
      <div class="font-display text-2xl font-bold text-ink mt-0.5">${products != null ? products.size() : 0}</div>
      <div class="text-[10px] text-ink/40 font-mono mt-0.5">Active SKUs cataloged</div>
    </div>
    <div class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center font-bold">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
    </div>
  </div>

  <div class="card p-4 flex items-center justify-between hover:shadow-md transition">
    <div>
      <div class="text-xs text-ink/50 font-mono uppercase tracking-wide">Categories</div>
      <div class="font-display text-2xl font-bold text-teal mt-0.5">${categories != null ? categories.size() : 0}</div>
      <div class="text-[10px] text-ink/40 font-mono mt-0.5">Product classifications</div>
    </div>
    <div class="w-10 h-10 rounded-xl bg-teal/10 text-teal flex items-center justify-center font-bold">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"/></svg>
    </div>
  </div>

  <div class="card p-4 flex items-center justify-between hover:shadow-md transition">
    <div>
      <div class="text-xs text-ink/50 font-mono uppercase tracking-wide">Suppliers / Vendors</div>
      <div class="font-display text-2xl font-bold text-amber mt-0.5">${vendors != null ? vendors.size() : 0}</div>
      <div class="text-[10px] text-ink/40 font-mono mt-0.5">Approved source partners</div>
    </div>
    <div class="w-10 h-10 rounded-xl bg-amber/10 text-amber flex items-center justify-center font-bold">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
    </div>
  </div>
</div>

<!-- Advanced Filter Bar -->
<div class="card p-4 mb-6 bg-white shadow-sm space-y-3">
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
    <!-- Keyword Search -->
    <div class="relative">
      <input type="text" id="prodSearch" onkeyup="filterCatalog()" placeholder="Search Name, SKU, or Details..." class="w-full pl-8 pr-3.5 py-2 rounded-lg border border-line bg-bg/50 text-xs focus:outline-none focus:ring-2 focus:ring-primary/20" />
      <svg class="w-3.5 h-3.5 text-ink/40 absolute left-2.5 top-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
    </div>

    <!-- Category Dropdown Filter -->
    <div>
      <select id="categoryFilter" onchange="filterCatalog()" class="w-full px-3 py-2 rounded-lg border border-line bg-bg/50 text-xs focus:outline-none focus:ring-2 focus:ring-primary/20">
        <option value="">All Categories</option>
        <c:forEach var="c" items="${categories}">
          <option value="${c.name.toLowerCase()}">${c.name}</option>
        </c:forEach>
      </select>
    </div>

    <!-- Vendor Dropdown Filter -->
    <div>
      <select id="vendorFilter" onchange="filterCatalog()" class="w-full px-3 py-2 rounded-lg border border-line bg-bg/50 text-xs focus:outline-none focus:ring-2 focus:ring-primary/20">
        <option value="">All Vendors</option>
        <c:forEach var="v" items="${vendors}">
          <option value="${v.companyName.toLowerCase()}">${v.companyName}</option>
        </c:forEach>
      </select>
    </div>

    <!-- View Mode Switcher -->
    <div class="flex items-center justify-between sm:justify-end gap-2 border-t sm:border-t-0 pt-2 sm:pt-0 border-line">
      <div class="flex bg-bg p-1 rounded-lg border border-line">
        <button type="button" id="viewGridBtn" onclick="switchView('grid')" class="px-2.5 py-1 text-xs rounded-md bg-white shadow-xs text-primary font-semibold transition" title="Grid View">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"/></svg>
        </button>
        <button type="button" id="viewTableBtn" onclick="switchView('table')" class="px-2.5 py-1 text-xs rounded-md text-ink/50 hover:text-ink transition" title="Table View">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16"/></svg>
        </button>
      </div>
      <span id="filteredCountBadge" class="text-xs font-mono font-semibold px-2.5 py-1 bg-bg border border-line rounded-lg text-ink/70">
        ${products != null ? products.size() : 0} items
      </span>
    </div>
  </div>
</div>

<!-- VIEW 1: PRODUCT GRID CARDS (8 PER PAGE) -->
<div id="productGridView" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
  <c:choose>
    <c:when test="${not empty products}">
      <c:forEach var="p" items="${products}">
        <div class="product-item card overflow-hidden flex flex-col group hover:border-primary transition duration-200"
             data-sku="${p.sku.toLowerCase()}"
             data-name="${p.name.toLowerCase()}"
             data-category="${p.categoryName != null ? p.categoryName.toLowerCase() : ''}"
             data-vendor="${p.vendorCompanyName != null ? p.vendorCompanyName.toLowerCase() : ''}">
          
          <!-- Image Box -->
          <div class="h-44 bg-bg border-b border-line overflow-hidden relative flex items-center justify-center">
            <c:choose>
              <c:when test="${not empty p.imageUrl}">
                <img src="${pageContext.request.contextPath}${p.imageUrl}" alt="${p.name}" class="w-full h-full object-cover group-hover:scale-105 transition duration-300">
              </c:when>
              <c:otherwise>
                <div class="flex flex-col items-center justify-center text-ink/20 group-hover:text-primary/40 transition">
                  <svg class="w-12 h-12 stroke-[1.2]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
                  <span class="text-[10px] font-mono mt-1 uppercase tracking-wider">No Image</span>
                </div>
              </c:otherwise>
            </c:choose>
            <div class="absolute top-2.5 right-2.5">
              <span class="tag tag-slate bg-white/90 backdrop-blur-xs border border-line shadow-xs font-mono text-[10px]">${p.sku}</span>
            </div>
          </div>

          <!-- Product Details -->
          <div class="p-4 flex-1 flex flex-col justify-between space-y-3">
            <div>
              <div class="flex items-center gap-1.5 mb-1.5">
                <span class="tag tag-teal text-[9px] px-2 py-0.5">${p.categoryName != null ? p.categoryName : 'General'}</span>
              </div>
              <h3 class="font-display font-semibold text-sm text-ink line-clamp-1 group-hover:text-primary transition" title="${p.name}">
                ${p.name}
              </h3>
            </div>

            <!-- Specs Matrix -->
            <div class="pt-3 border-t border-line grid grid-cols-2 gap-2 text-[11px]">
              <div>
                <span class="text-ink/40 font-mono uppercase block text-[9px]">Unit Weight</span>
                <span class="font-mono font-medium text-ink/80">${p.weight != null ? p.weight : '0.00'} kg</span>
              </div>
              <div>
                <span class="text-ink/40 font-mono uppercase block text-[9px]">Min Reorder</span>
                <span class="font-mono font-semibold ${p.reorderLevel <= 10 ? 'text-amber' : 'text-ink/80'}">${p.reorderLevel != null ? p.reorderLevel : 0} units</span>
              </div>
            </div>

            <!-- Vendor Footer -->
            <div class="pt-2 border-t border-dashed border-line flex items-center justify-between text-[11px] text-ink/60">
              <span class="truncate flex items-center gap-1" title="Vendor: ${p.vendorCompanyName}">
                <svg class="w-3.5 h-3.5 text-ink/40 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
                ${p.vendorCompanyName != null ? p.vendorCompanyName : 'Global Supplier'}
              </span>
            </div>
          </div>
        </div>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <div class="col-span-full card p-12 text-center text-ink/50 text-sm">
        No products cataloged yet.
      </div>
    </c:otherwise>
  </c:choose>
</div>

<!-- VIEW 2: PRODUCT TABLE -->
<div id="productTableView" class="card overflow-hidden hidden">
  <table class="w-full text-sm">
    <thead>
      <tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
        <th class="px-5 py-3 font-medium">SKU</th>
        <th class="px-5 py-3 font-medium">Product Name</th>
        <th class="px-5 py-3 font-medium">Category</th>
        <th class="px-5 py-3 font-medium">Unit Weight</th>
        <th class="px-5 py-3 font-medium">Reorder Level</th>
        <th class="px-5 py-3 font-medium">Supplier / Vendor</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-line">
      <c:choose>
        <c:when test="${not empty products}">
          <c:forEach var="p" items="${products}">
            <tr class="product-table-row hover:bg-bg/50 transition"
                data-sku="${p.sku.toLowerCase()}"
                data-name="${p.name.toLowerCase()}"
                data-category="${p.categoryName != null ? p.categoryName.toLowerCase() : ''}"
                data-vendor="${p.vendorCompanyName != null ? p.vendorCompanyName.toLowerCase() : ''}">
              <td class="px-5 py-3 font-mono text-xs font-semibold text-primary">${p.sku}</td>
              <td class="px-5 py-3">
                <div class="font-medium text-ink">${p.name}</div>
              </td>
              <td class="px-5 py-3">
                <span class="tag tag-teal text-[9px]">${p.categoryName != null ? p.categoryName : 'General'}</span>
              </td>
              <td class="px-5 py-3 font-mono text-xs text-ink/70">${p.weight != null ? p.weight : '0.00'} kg</td>
              <td class="px-5 py-3 font-mono text-xs font-semibold ${p.reorderLevel <= 10 ? 'text-amber' : 'text-ink/80'}">${p.reorderLevel} units</td>
              <td class="px-5 py-3 text-xs text-ink/70">${p.vendorCompanyName != null ? p.vendorCompanyName : 'Global Supplier'}</td>
            </tr>
          </c:forEach>
        </c:when>
      </c:choose>
    </tbody>
  </table>
</div>

<!-- Empty Filter Result Placeholder -->
<div id="noMatchMessage" class="card p-12 text-center hidden mt-4">
  <div class="text-ink/40 text-sm font-medium">No products match your filter or search criteria.</div>
  <button type="button" onclick="resetFilters()" class="mt-2 text-xs text-primary font-semibold hover:underline">Clear all filters</button>
</div>

<!-- PAGINATION BAR (8 ITEMS PER PAGE) -->
<div id="paginationBar" class="card p-4 mt-6 bg-white flex flex-col sm:flex-row items-center justify-between gap-4 shadow-sm">
  <div class="text-xs text-ink/60 font-medium">
    Showing <span id="pageRangeStart" class="font-bold text-ink">1</span> to <span id="pageRangeEnd" class="font-bold text-ink">8</span> of <span id="pageTotalItems" class="font-bold text-primary">${products != null ? products.size() : 0}</span> products
  </div>
  
  <div class="flex items-center gap-1.5" id="paginationButtons">
    <!-- Rendered dynamically by JavaScript -->
  </div>
</div>

<script>
  const PAGE_SIZE = 8;
  let currentPage = 1;
  let currentMatchingGridItems = [];
  let currentMatchingTableRows = [];

  function switchView(mode) {
    var grid = document.getElementById('productGridView');
    var table = document.getElementById('productTableView');
    var gridBtn = document.getElementById('viewGridBtn');
    var tableBtn = document.getElementById('viewTableBtn');

    if (mode === 'grid') {
      grid.classList.remove('hidden');
      table.classList.add('hidden');
      gridBtn.classList.add('bg-white', 'shadow-xs', 'text-primary', 'font-semibold');
      gridBtn.classList.remove('text-ink/50');
      tableBtn.classList.remove('bg-white', 'shadow-xs', 'text-primary', 'font-semibold');
      tableBtn.classList.add('text-ink/50');
    } else {
      grid.classList.add('hidden');
      table.classList.remove('hidden');
      tableBtn.classList.add('bg-white', 'shadow-xs', 'text-primary', 'font-semibold');
      tableBtn.classList.remove('text-ink/50');
      gridBtn.classList.remove('bg-white', 'shadow-xs', 'text-primary', 'font-semibold');
      gridBtn.classList.add('text-ink/50');
    }
  }

  function filterCatalog() {
    var query = (document.getElementById('prodSearch').value || '').toLowerCase().trim();
    var cat = (document.getElementById('categoryFilter').value || '').toLowerCase();
    var ven = (document.getElementById('vendorFilter').value || '').toLowerCase();

    var allGridItems = Array.from(document.querySelectorAll('.product-item'));
    var allTableRows = Array.from(document.querySelectorAll('.product-table-row'));

    function evaluate(el) {
      var sku = el.getAttribute('data-sku') || '';
      var name = el.getAttribute('data-name') || '';
      var c = el.getAttribute('data-category') || '';
      var v = el.getAttribute('data-vendor') || '';

      var matchesQuery = (!query || (sku.indexOf(query) !== -1 || name.indexOf(query) !== -1 || v.indexOf(query) !== -1));
      var matchesCat = (!cat || c.indexOf(cat) !== -1);
      var matchesVen = (!ven || v.indexOf(ven) !== -1);

      return matchesQuery && matchesCat && matchesVen;
    }

    currentMatchingGridItems = allGridItems.filter(evaluate);
    currentMatchingTableRows = allTableRows.filter(evaluate);

    currentPage = 1;
    renderPagination();
  }

  function renderPagination() {
    var totalItems = currentMatchingGridItems.length;
    var totalPages = Math.ceil(totalItems / PAGE_SIZE) || 1;

    if (currentPage > totalPages) currentPage = totalPages;
    if (currentPage < 1) currentPage = 1;

    // Hide all items first
    document.querySelectorAll('.product-item').forEach(el => el.style.display = 'none');
    document.querySelectorAll('.product-table-row').forEach(el => el.style.display = 'none');

    var startIndex = (currentPage - 1) * PAGE_SIZE;
    var endIndex = Math.min(startIndex + PAGE_SIZE, totalItems);

    // Show only the 8 items for the current page
    for (var i = startIndex; i < endIndex; i++) {
      if (currentMatchingGridItems[i]) currentMatchingGridItems[i].style.display = '';
      if (currentMatchingTableRows[i]) currentMatchingTableRows[i].style.display = '';
    }

    // Update counters
    document.getElementById('filteredCountBadge').textContent = totalItems + ' items';
    document.getElementById('pageTotalItems').textContent = totalItems;
    document.getElementById('pageRangeStart').textContent = totalItems === 0 ? 0 : (startIndex + 1);
    document.getElementById('pageRangeEnd').textContent = endIndex;

    var noMatch = document.getElementById('noMatchMessage');
    var paginationBar = document.getElementById('paginationBar');

    if (totalItems === 0) {
      noMatch.classList.remove('hidden');
      paginationBar.classList.add('hidden');
    } else {
      noMatch.classList.add('hidden');
      paginationBar.classList.remove('hidden');
    }

    // Build page buttons
    var btnContainer = document.getElementById('paginationButtons');
    btnContainer.innerHTML = '';

    // Prev Button
    var prevBtn = document.createElement('button');
    prevBtn.type = 'button';
    prevBtn.innerHTML = '&larr; Prev';
    prevBtn.className = 'px-3 py-1.5 text-xs font-semibold rounded-lg border border-line transition ' + 
      (currentPage === 1 ? 'opacity-40 cursor-not-allowed bg-bg text-ink/40' : 'bg-white hover:bg-bg text-ink shadow-xs');
    prevBtn.disabled = (currentPage === 1);
    prevBtn.onclick = function() { if (currentPage > 1) { currentPage--; renderPagination(); window.scrollTo({top: 0, behavior: 'smooth'}); } };
    btnContainer.appendChild(prevBtn);

    // Numeric Buttons
    for (let p = 1; p <= totalPages; p++) {
      if (totalPages > 7) {
        // Simple ellipsis handling for large page sets
        if (p !== 1 && p !== totalPages && Math.abs(p - currentPage) > 1) {
          if (p === 2 || p === totalPages - 1) {
            var dotSpan = document.createElement('span');
            dotSpan.className = 'px-1.5 text-xs text-ink/40 font-mono';
            dotSpan.textContent = '...';
            btnContainer.appendChild(dotSpan);
          }
          continue;
        }
      }

      var pageBtn = document.createElement('button');
      pageBtn.type = 'button';
      pageBtn.textContent = p;
      pageBtn.className = 'w-8 h-8 flex items-center justify-center text-xs font-semibold rounded-lg transition ' + 
        (p === currentPage ? 'bg-primary text-white shadow-sm' : 'bg-white border border-line text-ink/70 hover:bg-bg');
      pageBtn.onclick = (function(pageNumber) {
        return function() {
          currentPage = pageNumber;
          renderPagination();
          window.scrollTo({top: 0, behavior: 'smooth'});
        };
      })(p);
      btnContainer.appendChild(pageBtn);
    }

    // Next Button
    var nextBtn = document.createElement('button');
    nextBtn.type = 'button';
    nextBtn.innerHTML = 'Next &rarr;';
    nextBtn.className = 'px-3 py-1.5 text-xs font-semibold rounded-lg border border-line transition ' + 
      (currentPage === totalPages ? 'opacity-40 cursor-not-allowed bg-bg text-ink/40' : 'bg-white hover:bg-bg text-ink shadow-xs');
    nextBtn.disabled = (currentPage === totalPages);
    nextBtn.onclick = function() { if (currentPage < totalPages) { currentPage++; renderPagination(); window.scrollTo({top: 0, behavior: 'smooth'}); } };
    btnContainer.appendChild(nextBtn);
  }

  function resetFilters() {
    document.getElementById('prodSearch').value = '';
    document.getElementById('categoryFilter').value = '';
    document.getElementById('vendorFilter').value = '';
    filterCatalog();
  }

  // Initial load
  document.addEventListener('DOMContentLoaded', function() {
    filterCatalog();
  });
</script>

<%@ include file="includes/footer.jspf" %>