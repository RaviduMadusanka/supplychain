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
<title>Customer Orders & Tracking Dashboard :: NexTrade SCM</title>
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
  body{ font-family:'Inter',sans-serif; background:#F5F6FA; color:#12172B; }
  .font-display{ font-family:'Space Grotesk',sans-serif; }
  .font-mono{ font-family:'JetBrains Mono',monospace; }
  .card{ background:#fff; border:1px solid #E4E7EF; border-radius:16px; }
  
  .tag{ display:inline-flex; align-items:center; gap:.4rem; padding:.25rem .65rem; border-radius:6px; font-family:'JetBrains Mono',monospace; font-size:.70rem; font-weight:600; }
  .tag-dot{ width:6px; height:6px; border-radius:50%; }
  .tag-blue{ background:#EAEEFC; color:#1B34A6; } .tag-blue .tag-dot{ background:#2547D0; }
  .tag-teal{ background:#E3F7F6; color:#0B6E6D; } .tag-teal .tag-dot{ background:#0EA5A4; }
  .tag-amber{ background:#FDECE4; color:#A63D1B; } .tag-amber .tag-dot{ background:#E0572B; }
  .tag-slate{ background:#EEF0F5; color:#525A72; } .tag-slate .tag-dot{ background:#8A93AC; }
</style>
</head>
<body>

<header class="h-16 bg-white border-b border-line flex items-center justify-between px-6 md:px-10 sticky top-0 z-40 shadow-xs">
  <div class="flex items-center gap-8">
    <a href="${pageContext.request.contextPath}/customer/browse" class="flex items-center gap-2.5">
      <div class="w-8 h-8 rounded-lg bg-primary flex items-center justify-center font-display font-bold text-white text-sm shadow-sm shadow-primary/30">N</div>
      <div class="flex flex-col">
        <span class="font-display font-bold text-sm text-ink leading-tight">NexTrade SCM</span>
        <span class="font-mono text-[9px] text-primary font-semibold tracking-wider">CUSTOMER PORTAL</span>
      </div>
    </a>
    <nav class="hidden md:flex gap-6">
      <a href="${pageContext.request.contextPath}/customer/browse" class="text-sm font-medium text-ink/60 hover:text-ink transition py-5 border-b-2 border-transparent">Browse Products</a>
      <a href="${pageContext.request.contextPath}/dashboard/customer" class="text-sm font-bold text-primary border-b-2 border-primary py-5">My Orders &amp; Tracking</a>
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

<main class="max-w-6xl mx-auto px-6 py-8">
  <c:if test="${not empty param.success}">
    <div class="mb-6 p-4 rounded-xl bg-teal/10 border border-teal/30 text-teal flex items-center justify-between text-sm font-medium">
      <div class="flex items-center gap-2.5">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
        <span>${param.success}</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-teal/60 hover:text-teal text-lg">&times;</button>
    </div>
  </c:if>
  <c:if test="${not empty param.error}">
    <div class="mb-6 p-4 rounded-xl bg-amber/10 border border-amber/30 text-amber flex items-center justify-between text-sm font-medium">
      <div class="flex items-center gap-2.5">
        <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
        <span>${param.error}</span>
      </div>
      <button onclick="this.parentElement.remove()" class="text-amber/60 hover:text-amber text-lg">&times;</button>
    </div>
  </c:if>

  <div class="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-8">
    <div>
      <div class="flex items-center gap-2 mb-1">
        <h1 class="font-display text-2xl font-bold text-ink">Welcome back, <%= sessionUser != null ? sessionUser.getFullName() : "Customer" %></h1>
        <span class="tag tag-blue"><span class="tag-dot"></span>Verified Customer</span>
      </div>
      <p class="text-xs text-ink/50">Track cross-border procurement orders, freight milestones &amp; customs documentation.</p>
    </div>
    <a href="${pageContext.request.contextPath}/customer/browse" class="px-5 py-2.5 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primarydk shadow-sm shadow-primary/30 flex items-center gap-2 transition self-start md:self-auto">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
      + Place New Order
    </a>
  </div>

  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
    <div class="card p-5">
      <div class="text-xs font-mono uppercase text-ink/50 mb-1">Total Orders Placed</div>
      <div class="font-display text-2xl font-bold text-ink">${totalOrders != null ? totalOrders : 0}</div>
      <div class="text-[11px] text-ink/40 mt-1">Lifetime customer orders</div>
    </div>
    <div class="card p-5 border-t-4 border-t-primary">
      <div class="text-xs font-mono uppercase text-primary mb-1">In-Transit / Processing</div>
      <div class="font-display text-2xl font-bold text-primary">${inTransitCount != null ? inTransitCount : 0}</div>
      <div class="text-[11px] text-primary/70 mt-1">Active freight en route</div>
    </div>
    <div class="card p-5 border-t-4 border-t-teal">
      <div class="text-xs font-mono uppercase text-teal mb-1">Delivered Shipments</div>
      <div class="font-display text-2xl font-bold text-teal">${deliveredCount != null ? deliveredCount : 0}</div>
      <div class="text-[11px] text-teal/70 mt-1">Fulfilled successfully</div>
    </div>
    <div class="card p-5">
      <div class="text-xs font-mono uppercase text-ink/50 mb-1">Total Procurement</div>
      <div class="font-display text-2xl font-bold text-ink">$<fmt:formatNumber value="${totalSpent != null ? totalSpent : 0.00}" minFractionDigits="2" maxFractionDigits="2" /></div>
      <div class="text-[11px] text-ink/40 mt-1">Including VAT &amp; tariffs</div>
    </div>
  </div>

  <div class="card overflow-hidden shadow-xs">
    <div class="px-6 py-4 border-b border-line bg-bg/60 flex items-center justify-between">
      <div class="flex items-center gap-2">
        <h3 class="font-display font-bold text-sm text-ink">My Order History &amp; Waybills</h3>
        <span class="text-xs font-mono text-ink/40 font-semibold">(${orders != null ? orders.size() : 0})</span>
      </div>
      <div class="text-xs text-ink/40 font-mono">Live synchronization</div>
    </div>

    <table class="w-full text-sm">
      <thead>
        <tr class="text-left text-ink/50 text-xs font-mono uppercase tracking-wider border-b border-line bg-bg/30">
          <th class="px-6 py-3.5">Order Ref</th>
          <th class="px-6 py-3.5">Placed On</th>
          <th class="px-6 py-3.5">Items &amp; SKU</th>
          <th class="px-6 py-3.5">Total Amount</th>
          <th class="px-6 py-3.5">Status</th>
          <th class="px-6 py-3.5 text-right">Waybill &amp; Tracking</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-line">
        <c:choose>
          <c:when test="${not empty orders}">
            <c:forEach var="o" items="${orders}">
              <tr class="hover:bg-bg/40 transition">
                <td class="px-6 py-4 font-mono text-xs font-bold text-primary">${o.orderCode}</td>
                <td class="px-6 py-4 text-xs text-ink/70">
                  <fmt:parseDate value="${o.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                  <fmt:formatDate value="${parsedDate}" pattern="dd MMM yyyy, HH:mm" />
                </td>
                <td class="px-6 py-4 text-xs text-ink/80">
                  <span class="font-semibold">${o.itemCount} unit(s)</span>
                  <c:if test="${not empty o.items}">
                    <span class="text-ink/40 block font-mono text-[11px]">${o.items[0].productName}</span>
                  </c:if>
                </td>
                <td class="px-6 py-4 font-mono font-bold text-ink">
                  $<fmt:formatNumber value="${o.totalAmount}" minFractionDigits="2" maxFractionDigits="2" />
                </td>
                <td class="px-6 py-4">
                  <c:choose>
                    <c:when test="${o.statusName == 'DELIVERED' || o.statusName == 'COMPLETED'}">
                      <span class="tag tag-teal"><span class="tag-dot"></span>Delivered</span>
                    </c:when>
                    <c:when test="${o.statusName == 'IN_TRANSIT'}">
                      <span class="tag tag-amber"><span class="tag-dot"></span>In Transit</span>
                    </c:when>
                    <c:otherwise>
                      <span class="tag tag-blue"><span class="tag-dot"></span>${o.statusName}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="px-6 py-4 text-right">
                  <a href="${pageContext.request.contextPath}/shipment/track?code=${o.orderCode}" class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-line bg-white hover:bg-bg text-primary text-xs font-bold transition shadow-2xs">
                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7"/></svg>
                    Track Waybill &rarr;
                  </a>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="6" class="p-12 text-center text-ink/50 text-sm">
                No orders placed yet. Click <strong><a href="${pageContext.request.contextPath}/customer/browse" class="text-primary hover:underline">+ Place New Order</a></strong> to browse products.
              </td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>
</main>

</body>
</html>