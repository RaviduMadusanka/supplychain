<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  if (request.getAttribute("categories") == null) {
      response.sendRedirect(request.getContextPath() + "/system-config");
      return;
  }
  String pageTitle = "System Configuration";
  String pageSubtitle = "Manage master categories, status workflows & international trade tariffs";
  String activePage = "sysconfig";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

<!-- Top Header -->
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
  <div>
    <h2 class="text-xl font-display font-bold text-ink">System Configuration &amp; Master Data</h2>
    <p class="text-sm text-ink/50 mt-0.5"><%= pageSubtitle %></p>
  </div>
  <div class="flex items-center gap-2">
    <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary/10 border border-primary/20 text-primary text-xs font-mono font-semibold">
      <span class="w-2 h-2 rounded-full bg-primary animate-pulse"></span>
      Global Master Controls
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

<!-- Tab Switcher -->
<div class="mb-6 flex gap-2 border-b border-line pb-px bg-white p-1.5 rounded-xl border border-slate-200/80 w-fit shadow-xs">
  <button onclick="switchTab('tab-categories', this)" id="btn-categories" class="tab-btn active px-4 py-2 text-xs font-bold rounded-lg transition">
    Product Categories (${categories != null ? categories.size() : 0})
  </button>
  <button onclick="switchTab('tab-statuses', this)" id="btn-statuses" class="tab-btn px-4 py-2 text-xs font-semibold rounded-lg text-ink/60 hover:text-ink transition">
    Shipment Statuses (${statuses != null ? statuses.size() : 0})
  </button>
  <button onclick="switchTab('tab-tariffs', this)" id="btn-tariffs" class="tab-btn px-4 py-2 text-xs font-semibold rounded-lg text-ink/60 hover:text-ink transition">
    Cross-Border Tariffs (${countries != null ? countries.size() : 0})
  </button>
</div>

<!-- TAB 1: PRODUCT CATEGORIES -->
<div id="tab-categories" class="tab-pane space-y-4">
  <div class="flex items-center justify-between">
    <div>
      <h3 class="font-display font-bold text-sm text-ink">Catalog Product Categories</h3>
      <p class="text-xs text-ink/40">Hierarchical classifications for warehouse inventory &amp; customer catalog</p>
    </div>
    <button onclick="toggleModal('addCategoryModal')" class="px-3.5 py-2 rounded-xl bg-primary text-white text-xs font-bold shadow-xs hover:bg-primarydk transition flex items-center gap-1.5">
      <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"/></svg>
      Add Category
    </button>
  </div>

  <div class="card overflow-hidden shadow-sm">
    <table class="w-full text-sm">
      <thead>
        <tr class="text-left text-white text-xs font-mono uppercase tracking-wider bg-gradient-to-r from-[#12172B] via-[#1B254B] to-[#1E2538] border-b border-slate-700">
          <th class="px-5 py-3.5 font-semibold w-16 text-slate-300">ID</th>
          <th class="px-5 py-3.5 font-semibold text-white">Category Name</th>
          <th class="px-5 py-3.5 font-semibold text-slate-200">Description</th>
          <th class="px-5 py-3.5 font-semibold text-center text-teal">Linked Products</th>
          <th class="px-5 py-3.5 font-semibold text-right w-24 text-slate-300">Actions</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-line">
        <c:forEach var="cat" items="${categories}">
          <tr class="hover:bg-bg/40 transition">
            <td class="px-5 py-3 text-xs font-mono text-ink/50">#${cat.id}</td>
            <td class="px-5 py-3 font-semibold text-ink flex items-center gap-2">
              <span class="w-2.5 h-2.5 rounded-full bg-primary"></span>
              ${cat.name}
            </td>
            <td class="px-5 py-3 text-xs text-ink/60">${empty cat.description ? 'No description provided' : cat.description}</td>
            <td class="px-5 py-3 text-center">
              <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold font-mono bg-teal/10 text-teal border border-teal/20">
                ${cat.productCount} SKU(s)
              </span>
            </td>
            <td class="px-5 py-3 text-right">
              <form action="${pageContext.request.contextPath}/system-config/category/delete" method="POST" onsubmit="return confirm('Are you sure you want to delete category \'${cat.name}\'?');" class="inline">
                <input type="hidden" name="id" value="${cat.id}" />
                <button type="submit" class="text-ink/40 hover:text-amber p-1 transition rounded hover:bg-amber/10" title="Delete Category">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                </button>
              </form>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<!-- TAB 2: SHIPMENT STATUSES -->
<div id="tab-statuses" class="tab-pane hidden space-y-4">
  <div class="flex items-center justify-between">
    <div>
      <h3 class="font-display font-bold text-sm text-ink">Shipment &amp; Logistics Status Workflows</h3>
      <p class="text-xs text-ink/40">Defines the lifecycle states of order fulfillment and freight tracking</p>
    </div>
    <button onclick="toggleModal('addStatusModal')" class="px-3.5 py-2 rounded-xl bg-primary text-white text-xs font-bold shadow-xs hover:bg-primarydk transition flex items-center gap-1.5">
      <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"/></svg>
      Add Status
    </button>
  </div>

  <div class="card overflow-hidden shadow-sm">
    <table class="w-full text-sm">
      <thead>
        <tr class="text-left text-white text-xs font-mono uppercase tracking-wider bg-gradient-to-r from-[#12172B] via-[#1B254B] to-[#1E2538] border-b border-slate-700">
          <th class="px-5 py-3.5 font-semibold w-16 text-slate-300">ID</th>
          <th class="px-5 py-3.5 font-semibold text-white">Status Identifier</th>
          <th class="px-5 py-3.5 font-semibold text-slate-200">Workflow Description</th>
          <th class="px-5 py-3.5 font-semibold text-right w-24 text-slate-300">Actions</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-line">
        <c:forEach var="st" items="${statuses}">
          <tr class="hover:bg-bg/40 transition">
            <td class="px-5 py-3 text-xs font-mono text-ink/50">#${st.id}</td>
            <td class="px-5 py-3">
              <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-mono font-bold
                ${st.name == 'DELIVERED' ? 'bg-teal/10 text-teal border border-teal/20' : 
                  (st.name == 'IN_TRANSIT' ? 'bg-blue-500/10 text-blue-600 border border-blue-500/20' : 
                  (st.name == 'DELAYED' || st.name == 'CANCELLED' ? 'bg-amber/10 text-amber border border-amber/20' : 'bg-slate-100 text-slate-700'))}">
                <span class="w-1.5 h-1.5 rounded-full ${st.name == 'DELIVERED' ? 'bg-teal' : (st.name == 'IN_TRANSIT' ? 'bg-blue-600' : 'bg-amber')}"></span>
                ${st.name}
              </span>
            </td>
            <td class="px-5 py-3 text-xs text-ink/60">${st.description}</td>
            <td class="px-5 py-3 text-right">
              <form action="${pageContext.request.contextPath}/system-config/status/delete" method="POST" onsubmit="return confirm('Are you sure you want to delete status \'${st.name}\'?');" class="inline">
                <input type="hidden" name="id" value="${st.id}" />
                <button type="submit" class="text-ink/40 hover:text-amber p-1 transition rounded hover:bg-amber/10" title="Delete Status">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                </button>
              </form>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<!-- TAB 3: CROSS-BORDER TARIFFS & TAXES -->
<div id="tab-tariffs" class="tab-pane hidden space-y-4">
  <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
    <div>
      <h3 class="font-display font-bold text-sm text-ink">International Trade &amp; Customs Tariffs</h3>
      <p class="text-xs text-ink/40">Configured Value Added Tax (VAT) and import duty percentages applied to cross-border orders</p>
    </div>
    <button type="button" onclick="toggleModal('addCountryModal')" class="px-4 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primarydk shadow-sm flex items-center gap-1.5 transition self-start sm:self-auto">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
      + Add Country &amp; Tariffs
    </button>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
    <c:forEach var="ctry" items="${countries}">
      <div class="card p-5 hover:shadow-md transition relative overflow-hidden border-t-4 border-t-primary">
        <div class="flex items-center justify-between mb-3">
          <div class="font-display font-bold text-base text-ink">${ctry.name}</div>
          <span class="text-xs font-mono font-semibold px-2 py-0.5 rounded bg-bg text-ink/60 border border-line">Hub Region</span>
        </div>

        <div class="space-y-2 text-xs py-3 border-y border-line my-3">
          <div class="flex justify-between items-center">
            <span class="text-ink/50">VAT Percentage:</span>
            <span class="font-mono font-bold text-ink">${ctry.vatPercentage}%</span>
          </div>
          <div class="flex justify-between items-center">
            <span class="text-ink/50">Import Duty / Tariff:</span>
            <span class="font-mono font-bold text-teal">${ctry.importTaxPercentage}%</span>
          </div>
        </div>

        <button onclick="openTaxModal(${ctry.id}, '${ctry.name}', ${ctry.vatPercentage}, ${ctry.importTaxPercentage})" class="w-full py-2 rounded-lg border border-line bg-white hover:bg-bg text-ink/70 text-xs font-semibold transition shadow-xs">
          Edit Tariffs &rarr;
        </button>
      </div>
    </c:forEach>
  </div>
</div>

<!-- MODAL 1: ADD CATEGORY -->
<div id="addCategoryModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-xs p-4">
  <div class="bg-white rounded-2xl p-6 w-full max-w-md shadow-2xl border border-line">
    <div class="flex justify-between items-center mb-4">
      <h3 class="font-display font-bold text-base text-ink">Add Product Category</h3>
      <button onclick="toggleModal('addCategoryModal')" class="text-ink/40 hover:text-ink text-lg">&times;</button>
    </div>
    <form action="${pageContext.request.contextPath}/system-config/category/add" method="POST" class="space-y-4">
      <div>
        <label class="block text-xs font-mono uppercase text-ink/60 mb-1">Category Name *</label>
        <input type="text" name="name" required placeholder="e.g. Industrial Automation" class="w-full px-3.5 py-2.5 rounded-xl border border-line text-sm focus:outline-none focus:border-primary" />
      </div>
      <div>
        <label class="block text-xs font-mono uppercase text-ink/60 mb-1">Description</label>
        <textarea name="description" rows="3" placeholder="Brief description of products in this category..." class="w-full px-3.5 py-2.5 rounded-xl border border-line text-sm focus:outline-none focus:border-primary"></textarea>
      </div>
      <div class="flex justify-end gap-2 pt-2">
        <button type="button" onclick="toggleModal('addCategoryModal')" class="px-4 py-2 rounded-xl border border-line text-xs font-semibold text-ink/70 hover:bg-bg">Cancel</button>
        <button type="submit" class="px-5 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primarydk">Save Category</button>
      </div>
    </form>
  </div>
</div>

<!-- MODAL 2: ADD STATUS -->
<div id="addStatusModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-xs p-4">
  <div class="bg-white rounded-2xl p-6 w-full max-w-md shadow-2xl border border-line">
    <div class="flex justify-between items-center mb-4">
      <h3 class="font-display font-bold text-base text-ink">Add Shipment Status</h3>
      <button onclick="toggleModal('addStatusModal')" class="text-ink/40 hover:text-ink text-lg">&times;</button>
    </div>
    <form action="${pageContext.request.contextPath}/system-config/status/add" method="POST" class="space-y-4">
      <div>
        <label class="block text-xs font-mono uppercase text-ink/60 mb-1">Status Code Name *</label>
        <input type="text" name="name" required placeholder="e.g. CUSTOMS_CLEARED" class="w-full px-3.5 py-2.5 rounded-xl border border-line text-sm uppercase focus:outline-none focus:border-primary" />
      </div>
      <div>
        <label class="block text-xs font-mono uppercase text-ink/60 mb-1">Description</label>
        <input type="text" name="description" placeholder="e.g. Cleared through regional port authority" class="w-full px-3.5 py-2.5 rounded-xl border border-line text-sm focus:outline-none focus:border-primary" />
      </div>
      <div class="flex justify-end gap-2 pt-2">
        <button type="button" onclick="toggleModal('addStatusModal')" class="px-4 py-2 rounded-xl border border-line text-xs font-semibold text-ink/70 hover:bg-bg">Cancel</button>
        <button type="submit" class="px-5 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primarydk">Create Status</button>
      </div>
    </form>
  </div>
</div>

<!-- MODAL 3: EDIT TARIFFS -->
<div id="editTaxModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-xs p-4">
  <div class="bg-white rounded-2xl p-6 w-full max-w-md shadow-2xl border border-line">
    <div class="flex justify-between items-center mb-4">
      <h3 class="font-display font-bold text-base text-ink" id="taxModalTitle">Edit Tax Rates</h3>
      <button onclick="toggleModal('editTaxModal')" class="text-ink/40 hover:text-ink text-lg">&times;</button>
    </div>
    <form action="${pageContext.request.contextPath}/system-config/tax/update" method="POST" class="space-y-4">
      <input type="hidden" id="taxCountryId" name="countryId" />
      <div>
        <label class="block text-xs font-mono uppercase text-ink/60 mb-1">VAT Percentage (%) *</label>
        <input type="number" step="0.01" min="0" max="100" id="taxVat" name="vat" required class="w-full px-3.5 py-2.5 rounded-xl border border-line text-sm focus:outline-none focus:border-primary" />
      </div>
      <div>
        <label class="block text-xs font-mono uppercase text-ink/60 mb-1">Import Duty / Tariff (%) *</label>
        <input type="number" step="0.01" min="0" max="100" id="taxImport" name="importTax" required class="w-full px-3.5 py-2.5 rounded-xl border border-line text-sm focus:outline-none focus:border-primary" />
      </div>
      <div class="flex justify-end gap-2 pt-2">
        <button type="button" onclick="toggleModal('editTaxModal')" class="px-4 py-2 rounded-xl border border-line text-xs font-semibold text-ink/70 hover:bg-bg">Cancel</button>
        <button type="submit" class="px-5 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primarydk">Update Rates</button>
      </div>
    </form>
  </div>
</div>

<!-- MODAL 4: ADD COUNTRY & TARIFFS -->
<div id="addCountryModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-xs p-4">
  <div class="bg-white rounded-2xl p-6 w-full max-w-md shadow-2xl border border-line">
    <div class="flex justify-between items-center mb-4">
      <div class="flex items-center gap-2.5">
        <div class="w-8 h-8 rounded-lg bg-primsoft text-primary flex items-center justify-center">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        </div>
        <div>
          <h3 class="font-display font-bold text-base text-ink">Add Trade Origin Country</h3>
          <p class="text-xs text-ink/40 font-mono">Register new nation &amp; customs rate</p>
        </div>
      </div>
      <button onclick="toggleModal('addCountryModal')" class="text-ink/40 hover:text-ink text-lg">&times;</button>
    </div>
    <form action="${pageContext.request.contextPath}/system-config/country/add" method="POST" class="space-y-4">
      <div>
        <label class="block text-xs font-mono uppercase text-ink/60 mb-1">Country Name *</label>
        <input type="text" name="name" required placeholder="e.g. China, United States, Japan, Germany" class="w-full px-3.5 py-2.5 rounded-xl border border-line text-sm focus:outline-none focus:border-primary" />
      </div>
      <div class="grid grid-cols-2 gap-3">
        <div>
          <label class="block text-xs font-mono uppercase text-ink/60 mb-1">VAT Percentage (%) *</label>
          <input type="number" step="0.01" min="0" max="100" name="vat" value="15.00" required class="w-full px-3.5 py-2.5 rounded-xl border border-line text-sm focus:outline-none focus:border-primary" />
        </div>
        <div>
          <label class="block text-xs font-mono uppercase text-ink/60 mb-1">Import Duty / Tariff (%) *</label>
          <input type="number" step="0.01" min="0" max="100" name="importTax" value="12.00" required class="w-full px-3.5 py-2.5 rounded-xl border border-line text-sm focus:outline-none focus:border-primary" />
        </div>
      </div>
      <div class="p-3 rounded-xl bg-bg border border-line text-xs text-ink/60">
        This country will immediately become selectable for Vendor company registration and Cross-border tariffs calculation.
      </div>
      <div class="flex justify-end gap-2 pt-2">
        <button type="button" onclick="toggleModal('addCountryModal')" class="px-4 py-2 rounded-xl border border-line text-xs font-semibold text-ink/70 hover:bg-bg">Cancel</button>
        <button type="submit" class="px-5 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primarydk">Register Country</button>
      </div>
    </form>
  </div>
</div>

<script>
  function toggleModal(id) {
    const el = document.getElementById(id);
    if (el) {
      if (el.classList.contains('hidden')) {
        el.classList.remove('hidden');
        el.classList.add('flex');
      } else {
        el.classList.add('hidden');
        el.classList.remove('flex');
      }
    }
  }

  function switchTab(tabId, btn) {
    document.querySelectorAll('.tab-pane').forEach(el => el.classList.add('hidden'));
    document.querySelectorAll('.tab-btn').forEach(el => {
      el.classList.remove('active', 'bg-primary', 'text-white');
      el.classList.add('text-ink/60');
    });

    const activeEl = document.getElementById(tabId);
    if (activeEl) activeEl.classList.remove('hidden');

    if (btn) {
      btn.classList.add('active', 'bg-primary', 'text-white');
      btn.classList.remove('text-ink/60');
    }
  }

  function openTaxModal(id, name, vat, imp) {
    document.getElementById('taxCountryId').value = id;
    document.getElementById('taxModalTitle').innerText = 'Edit Tariffs for ' + name;
    document.getElementById('taxVat').value = vat;
    document.getElementById('taxImport').value = imp;
    toggleModal('editTaxModal');
  }

  // Handle URL tab parameter
  document.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    const tab = urlParams.get('tab');
    if (tab === 'statuses') {
      switchTab('tab-statuses', document.getElementById('btn-statuses'));
    } else if (tab === 'tariffs') {
      switchTab('tab-tariffs', document.getElementById('btn-tariffs'));
    } else {
      switchTab('tab-categories', document.getElementById('btn-categories'));
    }
  });
</script>

<style>
  .tab-btn.active {
    background-color: #2547D0;
    color: #ffffff;
  }
</style>

<%@ include file="includes/footer.jspf" %>