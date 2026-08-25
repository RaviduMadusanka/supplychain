<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
  com.globaltrade.core.dto.UserDTO sessionUser = (com.globaltrade.core.dto.UserDTO) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Waybill & Shipment Tracking :: NexTrade SCM</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          ink:'#12172B', bg:'#F5F6FA', line:'#E4E7EF',
          primary:'#2547D0', primarydk:'#1B34A6', teal:'#0EA5A4', amber:'#E0572B',
          primsoft:'#EAEEFC', tealsoft:'#E3F7F6', ambersoft:'#FDECE4'
        },
        fontFamily: {
          display: ['"Space Grotesk"', 'sans-serif'],
          body: ['Inter', 'sans-serif'],
          mono: ['"JetBrains Mono"', 'monospace']
        }
      }
    }
  }
</script>
<style>
  body{ font-family:'Inter',sans-serif; background:#F5F6FA; color:#12172B; padding-bottom:60px; }
  .font-display{ font-family:'Space Grotesk',sans-serif; }
  .font-mono{ font-family:'JetBrains Mono',monospace; }
  .card{ background:#fff; border:1px solid #E4E7EF; border-radius:16px; }
  
  .route-line{ background-image:linear-gradient(to right,#C7CCDD 60%, transparent 0%); background-size:10px 2px; background-repeat:repeat-x; height:3px; }
  .route-node{ width:20px; height:20px; border-radius:50%; border:3px solid #C7CCDD; background:#fff; z-index:2; }
  .route-node.done{ border-color:#0EA5A4; background:#0EA5A4; }
  .route-node.active{ border-color:#2547D0; background:#2547D0; box-shadow:0 0 0 4px #EAEEFC; }

  .tag{ display:inline-flex; align-items:center; gap:.4rem; padding:.25rem .65rem; border-radius:6px; font-family:'JetBrains Mono',monospace; font-size:.70rem; font-weight:600; }
  .tag-dot{ width:6px; height:6px; border-radius:50%; }
  .tag-teal{ background:#E3F7F6; color:#0B6E6D; } .tag-teal .tag-dot{ background:#0EA5A4; }
  .tag-amber{ background:#FDECE4; color:#A63D1B; } .tag-amber .tag-dot{ background:#E0572B; }
  .tag-slate{ background:#EEF0F5; color:#525A72; } .tag-slate .tag-dot{ background:#8A93AC; }
  .tag-blue{ background:#EAEEFC; color:#1B34A6; } .tag-blue .tag-dot{ background:#2547D0; }
</style>
</head>
<body>

<!-- HEADER -->
<header class="h-16 bg-white border-b border-line flex items-center justify-between px-6 md:px-10 sticky top-0 z-40 shadow-xs">
  <div class="flex items-center gap-8">
    <a href="${pageContext.request.contextPath}/customer/browse" class="flex items-center gap-2.5">
      <div class="w-8 h-8 rounded-lg bg-primary flex items-center justify-center font-display font-bold text-white text-sm shadow-sm shadow-primary/30">N</div>
      <div class="flex flex-col">
        <span class="font-display font-bold text-sm text-ink leading-tight">NexTrade SCM</span>
        <span class="font-mono text-[9px] text-primary font-semibold tracking-wider">WAYBILL &amp; FREIGHT TRACKING</span>
      </div>
    </a>
    <nav class="hidden md:flex gap-6">
      <a href="${pageContext.request.contextPath}/customer/browse" class="text-sm font-medium text-ink/60 hover:text-ink transition py-5 border-b-2 border-transparent">Browse Products</a>
      <a href="${pageContext.request.contextPath}/dashboard/customer" class="text-sm font-medium text-ink/60 hover:text-ink transition py-5 border-b-2 border-transparent">My Orders</a>
    </nav>
  </div>
  <div class="flex items-center gap-5">
    <div class="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-bg border border-line">
      <div class="w-6 h-6 rounded-lg bg-primsoft text-primary flex items-center justify-center font-display text-xs font-bold">
        <%= sessionUser != null && sessionUser.getFullName() != null && !sessionUser.getFullName().isEmpty() ? sessionUser.getFullName().substring(0, 1) : "C" %>
      </div>
      <span class="text-xs font-semibold text-ink"><%= sessionUser != null ? sessionUser.getFullName() : "Customer" %></span>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="text-xs font-semibold text-ink/50 hover:text-amber transition">Sign out</a>
  </div>
</header>

<main class="max-w-4xl mx-auto px-6 py-8">

  <!-- SEARCH BAR -->
  <div class="card p-4 mb-8 shadow-xs">
    <form action="${pageContext.request.contextPath}/shipment/track" method="GET" class="flex flex-col sm:flex-row gap-3">
      <div class="relative flex-1">
        <svg class="w-5 h-5 absolute left-3.5 top-3.5 text-ink/40" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
        <input type="text" name="code" value="${not empty searchCode ? searchCode : (not empty order ? order.orderCode : '')}" placeholder="Enter Waybill Ref (SHP-...) or Order Ref (ORD-...)" required class="w-full pl-11 pr-4 py-3 border border-line rounded-xl font-mono text-sm bg-white focus:border-primary focus:outline-none" />
      </div>
      <button type="submit" class="px-6 py-3 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primarydk shadow-sm shadow-primary/30 flex items-center justify-center gap-2 transition">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7"/></svg>
        Track Waybill
      </button>
    </form>
  </div>

  <c:if test="${not empty error}">
    <div class="mb-6 p-4 rounded-xl bg-amber/10 border border-amber/30 text-amber flex items-center justify-between text-sm font-medium">
      <div class="flex items-center gap-2.5">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
        <span>${error}</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-amber/60 hover:text-amber text-lg">&times;</button>
    </div>
  </c:if>

  <c:choose>
    <c:when test="${not empty order}">
      <!-- TRACKING CARD -->
      <div class="card p-8 shadow-sm mb-6">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 pb-6 border-b border-line">
          <div>
            <div class="flex items-center gap-3 mb-1">
              <span class="font-mono text-xs font-bold text-ink/40">${not empty order.shipmentCode ? order.shipmentCode : 'SHP-PENDING'}</span>
              <span class="text-xs text-ink/30 font-mono">&middot; Order ${order.orderCode}</span>
            </div>
            <h1 class="font-display text-2xl font-bold text-ink">
              ${order.originWarehouseName} &rarr; ${not empty order.countryName ? order.countryName : 'Destination'}
            </h1>
          </div>
          <div>
            <c:choose>
              <c:when test="${order.statusName == 'DELIVERED' || order.statusName == 'COMPLETED'}">
                <span class="tag tag-teal text-xs py-1.5 px-3"><span class="tag-dot"></span>Delivered</span>
              </c:when>
              <c:when test="${order.statusName == 'IN_TRANSIT' || order.statusName == 'PROCESSING'}">
                <span class="tag tag-blue text-xs py-1.5 px-3"><span class="tag-dot"></span>In Transit</span>
              </c:when>
              <c:otherwise>
                <span class="tag tag-amber text-xs py-1.5 px-3"><span class="tag-dot"></span>${order.statusName}</span>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- 4-STEP ROUTE TIMELINE -->
        <div class="py-8">
          <div class="flex items-center gap-0 mb-4 px-4">
            <div class="route-node done"></div>
            <div class="flex-1 route-line" style="background-image:none;background:#0EA5A4"></div>
            <div class="route-node <c:choose><c:when test="${order.statusName == 'IN_TRANSIT' || order.statusName == 'DELIVERED' || order.statusName == 'COMPLETED'}">done</c:when><c:otherwise>active</c:otherwise></c:choose>"></div>
            <div class="flex-1 route-line" <c:if test="${order.statusName == 'IN_TRANSIT' || order.statusName == 'DELIVERED' || order.statusName == 'COMPLETED'}">style="background-image:none;background:#0EA5A4"</c:if>></div>
            <div class="route-node <c:choose><c:when test="${order.statusName == 'DELIVERED' || order.statusName == 'COMPLETED'}">done</c:when><c:when test="${order.statusName == 'IN_TRANSIT'}">active</c:when><c:otherwise></c:otherwise></c:choose>"></div>
            <div class="flex-1 route-line" <c:if test="${order.statusName == 'DELIVERED' || order.statusName == 'COMPLETED'}">style="background-image:none;background:#0EA5A4"</c:if>></div>
            <div class="route-node <c:if test='${order.statusName == \"DELIVERED\" || order.statusName == \"COMPLETED\"}'>done</c:if>"></div>
          </div>

          <div class="grid grid-cols-4 text-center gap-2">
            <div>
              <div class="text-xs font-bold text-teal">Order Placed</div>
              <div class="text-[11px] text-ink/50 font-mono mt-0.5">
                <fmt:parseDate value="${order.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="orderDate" type="both" />
                <fmt:formatDate value="${orderDate}" pattern="dd MMM, HH:mm" />
              </div>
            </div>
            <div>
              <div class="text-xs font-bold <c:choose><c:when test="${order.statusName == 'IN_TRANSIT' || order.statusName == 'DELIVERED' || order.statusName == 'COMPLETED'}">text-teal</c:when><c:otherwise>text-primary</c:otherwise></c:choose>">Hub Dispatched</div>
              <div class="text-[11px] text-ink/50 font-mono mt-0.5">${order.originWarehouseName}</div>
            </div>
            <div>
              <div class="text-xs font-bold <c:choose><c:when test="${order.statusName == 'DELIVERED' || order.statusName == 'COMPLETED'}">text-teal</c:when><c:when test="${order.statusName == 'IN_TRANSIT'}">text-primary</c:when><c:otherwise>text-ink/40</c:otherwise></c:choose>">In Transit / Customs</div>
              <div class="text-[11px] text-ink/50 font-mono mt-0.5">
                <c:choose>
                  <c:when test="${order.crossBorder}">Cross-Border Customs</c:when>
                  <c:otherwise>Domestic Freight</c:otherwise>
                </c:choose>
              </div>
            </div>
            <div>
              <div class="text-xs font-bold <c:choose><c:when test="${order.statusName == 'DELIVERED' || order.statusName == 'COMPLETED'}">text-teal</c:when><c:otherwise>text-ink/40</c:otherwise></c:choose>">Final Delivery</div>
              <div class="text-[11px] text-ink/50 font-mono mt-0.5">
                <c:choose>
                  <c:when test="${order.statusName == 'DELIVERED' || order.statusName == 'COMPLETED'}">Completed</c:when>
                  <c:otherwise>
                    <fmt:parseDate value="${order.estimatedDelivery}" pattern="yyyy-MM-dd'T'HH:mm" var="estDate" type="both" />
                    <fmt:formatDate value="${estDate}" pattern="dd MMM yyyy" />
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
        </div>

        <!-- DETAILS GRID -->
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6 pt-6 border-t border-line text-xs">
          <div>
            <span class="text-ink/40 block mb-1 font-mono uppercase">Logistics Carrier</span>
            <span class="font-bold text-ink text-sm">${order.carrierName}</span>
          </div>
          <div>
            <span class="text-ink/40 block mb-1 font-mono uppercase">Origin Facility</span>
            <span class="font-bold text-ink text-sm">${order.originWarehouseName}</span>
          </div>
          <div>
            <span class="text-ink/40 block mb-1 font-mono uppercase">Destination Address</span>
            <span class="font-bold text-ink text-sm">${order.destination}</span>
          </div>
          <div>
            <span class="text-ink/40 block mb-1 font-mono uppercase">Total Paid</span>
            <span class="font-bold text-primary font-mono text-sm">$<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2" maxFractionDigits="2" /></span>
          </div>
        </div>

        <!-- ITEMS IN SHIPMENT -->
        <c:if test="${not empty order.items}">
          <div class="mt-6 pt-6 border-t border-line">
            <h4 class="text-xs font-mono uppercase text-ink/50 mb-3">Manifest &amp; Contents (${order.itemCount} Units)</h4>
            <div class="space-y-2">
              <c:forEach var="item" items="${order.items}">
                <div class="flex items-center justify-between p-3 rounded-xl bg-bg border border-line text-xs">
                  <div class="flex items-center gap-3">
                    <span class="w-6 h-6 rounded-lg bg-white border border-line flex items-center justify-center font-mono font-bold text-ink/60 text-[11px]">${item.quantity}x</span>
                    <div>
                      <span class="font-bold text-ink">${item.productName}</span>
                      <span class="font-mono text-ink/40 ml-2">${item.productSku}</span>
                    </div>
                  </div>
                  <span class="font-mono font-semibold text-ink">$<fmt:formatNumber value="${item.unitPrice}" minFractionDigits="2" maxFractionDigits="2" /> each</span>
                </div>
              </c:forEach>
            </div>
          </div>
        </c:if>

      </div>

      <div class="flex justify-between items-center text-xs">
        <a href="${pageContext.request.contextPath}/dashboard/customer" class="text-primary font-bold hover:underline">&larr; Back to Customer Dashboard</a>
        <span class="text-ink/40">Real-time status synced with GlassFish SCM EJB Engine</span>
      </div>
    </c:when>
    <c:otherwise>
      <div class="card p-12 text-center shadow-xs">
        <div class="w-12 h-12 rounded-2xl bg-primsoft text-primary mx-auto flex items-center justify-center mb-3">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7"/></svg>
        </div>
        <h3 class="font-display font-bold text-lg text-ink mb-1">Enter Waybill Reference Number</h3>
        <p class="text-xs text-ink/50 max-w-sm mx-auto mb-6">Type your order code (e.g. <code>ORD-...</code>) or waybill reference (<code>SHP-...</code>) above to view real-time freight updates.</p>
        <a href="${pageContext.request.contextPath}/dashboard/customer" class="text-xs font-bold text-primary hover:underline">&larr; View My Orders</a>
      </div>
    </c:otherwise>
  </c:choose>

</main>

</body>
</html>