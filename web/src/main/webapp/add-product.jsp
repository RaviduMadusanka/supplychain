<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  String pageTitle = "Add Product";
  String pageSubtitle = "Create a new product in the catalog.";
  String activePage = "addproduct";
  String userName = "Saman Kumara";
  String userRole = "Warehouse Manager";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="flex items-center justify-end mb-6">
    <a href="${pageContext.request.contextPath}/inventory" class="px-4 py-2 border border-line rounded-lg text-sm font-medium hover:bg-bg transition flex items-center gap-2">
      &larr; Back to Inventory
    </a>
  </div>

  <c:if test="${not empty error}">
    <div class="mb-6 p-4 rounded-lg bg-amber/10 border border-amber/20 text-amber text-sm font-medium">
      ${error}
    </div>
  </c:if>

  <form action="${pageContext.request.contextPath}/product/add" method="post" enctype="multipart/form-data">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      
      <!-- Left Column: Product Details -->
      <div class="lg:col-span-2 space-y-6">
        <div class="card p-6 shadow-sm">
          <h3 class="font-display font-semibold text-lg mb-6">Product Details</h3>
          
          <div class="space-y-5">
            <div>
              <label class="block text-xs font-medium text-ink/70 mb-1.5">Product Name</label>
              <input type="text" name="name" class="w-full px-4 py-2.5 border border-line rounded-lg text-sm focus:outline-none focus:border-primary transition" placeholder="e.g. Industrial Ball Bearings (Set of 50)" required>
            </div>
            
            <div class="grid grid-cols-2 gap-5">
              <div>
                <label class="block text-xs font-medium text-ink/70 mb-1.5">Category</label>
                <select name="category" class="w-full px-4 py-2.5 border border-line rounded-lg text-sm focus:outline-none focus:border-primary transition bg-white" required>
                  <option value="">Select category...</option>
                  <c:forEach var="cat" items="${categories}">
                    <option value="${cat.id}">${cat.name}</option>
                  </c:forEach>
                </select>
              </div>
              <div>
                <label class="block text-xs font-medium text-ink/70 mb-1.5">Vendor</label>
                <select name="vendor" class="w-full px-4 py-2.5 border border-line rounded-lg text-sm focus:outline-none focus:border-primary transition bg-white" required>
                  <option value="">Select vendor...</option>
                  <c:forEach var="ven" items="${vendors}">
                    <option value="${ven.id}">${ven.companyName}</option>
                  </c:forEach>
                </select>
              </div>
            </div>

            <div class="grid grid-cols-2 gap-5">
              <div>
                <label class="block text-xs font-medium text-ink/70 mb-1.5">Weight (Kg)</label>
                <input type="number" step="0.01" name="weight" class="w-full px-4 py-2.5 border border-line rounded-lg text-sm focus:outline-none focus:border-primary transition" placeholder="0.00">
              </div>
              <div>
                <label class="block text-xs font-medium text-ink/70 mb-1.5">Reorder Level</label>
                <input type="number" name="reorderLevel" class="w-full px-4 py-2.5 border border-line rounded-lg text-sm focus:outline-none focus:border-primary transition" placeholder="0">
              </div>
            </div>

            <div>
              <label class="block text-xs font-medium text-ink/70 mb-1.5">SKU / Product Code</label>
              <input type="text" name="sku" class="w-full px-4 py-2.5 border border-line rounded-lg text-sm focus:outline-none focus:border-primary transition" placeholder="Auto-generated if left blank">
            </div>
          </div>
        </div>
      </div>

      <!-- Right Column -->
      <div class="space-y-6">
        
        <!-- Product Image -->
        <div class="card p-6 shadow-sm">
          <h3 class="font-display font-semibold text-lg mb-6">Product Image</h3>
          
          <div class="w-full h-40 border-2 border-dashed border-primary/20 bg-primary/5 rounded-xl flex items-center justify-center mb-4">
            <svg class="w-10 h-10 text-primary/40" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
          </div>
          
          <div>
            <label class="block text-xs font-medium text-ink/70 mb-1.5">Upload Image</label>
            <input type="file" name="productImage" accept=".png, .jpg, .jpeg" class="w-full text-sm text-ink/60 file:mr-3 file:py-1.5 file:px-3 file:rounded-lg file:border-0 file:text-xs file:font-semibold file:bg-bg file:text-ink hover:file:bg-line transition">
            <p class="text-[10px] text-ink/40 mt-2">PNG or JPG, up to 5MB. Optional &mdash; a placeholder icon is used if left blank.</p>
          </div>
        </div>

        <!-- Status -->
        <div class="card p-6 shadow-sm">
          <h3 class="font-display font-semibold text-lg mb-6">Status</h3>
          
          <div>
            <label class="block text-xs font-medium text-ink/70 mb-1.5">Availability</label>
            <select name="status" class="w-full px-4 py-2.5 border border-line rounded-lg text-sm focus:outline-none focus:border-primary transition bg-white">
              <option value="ACTIVE">Active &mdash; visible in catalog</option>
              <option value="DRAFT">Draft &mdash; hidden from catalog</option>
            </select>
          </div>
        </div>

      </div>
    </div>

    <!-- Actions -->
    <div class="flex items-center justify-end gap-4 mt-8 border-t border-line pt-6">
      <a href="${pageContext.request.contextPath}/inventory" class="px-6 py-2.5 rounded-lg border border-line text-sm font-semibold hover:bg-bg transition shadow-sm">Cancel</a>
      <button type="submit" class="px-6 py-2.5 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition shadow-sm flex items-center gap-2">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
        Save Product
      </button>
    </div>
  </form>

<%@ include file="includes/footer.jspf" %>
