<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 Access Forbidden :: NexTrade SCM</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = { theme: { extend: { colors: {
        ink:'#12172B', sidebar:'#0B1220', primary:'#2547D0', primarydk:'#1B34A6',
        teal:'#0EA5A4', amber:'#E0572B', line:'#E4E7EF', bg:'#F5F6FA'
      }, fontFamily: { display:['"Space Grotesk"','sans-serif'], body:['Inter','sans-serif'], mono:['"JetBrains Mono"','monospace'] } } } }
    </script>
    <style>
      body{ font-family:'Inter',sans-serif; }
      .font-display{ font-family:'Space Grotesk',sans-serif; }
      .font-mono{ font-family:'JetBrains Mono',monospace; }
    </style>
</head>
<body class="bg-bg text-ink min-h-screen flex items-center justify-center p-6 relative overflow-hidden">

    <div class="absolute inset-0 opacity-[0.03]" style="background-image:radial-gradient(circle at 1px 1px, #12172B 1px, transparent 0); background-size:24px 24px;"></div>

    <div class="relative max-w-md w-full bg-white rounded-2xl shadow-2xl p-8 sm:p-10 text-center border border-line">
        <div class="w-16 h-16 rounded-2xl bg-amber/10 border border-amber/20 flex items-center justify-center mx-auto mb-6">
            <svg class="w-8 h-8 text-amber" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
        </div>
        
        <div class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber/10 text-amber text-xs font-mono font-bold tracking-wider uppercase mb-2">
          HTTP 403 &middot; Forbidden
        </div>
        <h1 class="font-display text-2xl font-bold text-ink mb-2">Access Privilege Restricted</h1>
        
        <p class="text-xs text-ink/60 mb-6 leading-relaxed">
            Your current authenticated session <strong class="text-ink">(${sessionScope.user != null ? sessionScope.user.username : 'Guest'})</strong> with role <strong class="text-primary font-mono">${sessionScope.user != null ? sessionScope.user.role : 'None'}</strong> does not possess the required RBAC security clearance to access this enterprise resource.
        </p>
        
        <div class="flex flex-col gap-2.5">
            <c:choose>
              <c:when test="${sessionScope.user.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/dashboard/admin" class="w-full py-2.5 rounded-xl bg-primary hover:bg-primarydk transition text-white text-xs font-bold shadow-sm flex items-center justify-center gap-2">
                  Return to Admin Dashboard &rarr;
                </a>
              </c:when>
              <c:when test="${sessionScope.user.role == 'WAREHOUSE_MANAGER'}">
                <a href="${pageContext.request.contextPath}/dashboard/warehouse" class="w-full py-2.5 rounded-xl bg-primary hover:bg-primarydk transition text-white text-xs font-bold shadow-sm flex items-center justify-center gap-2">
                  Return to Warehouse Dashboard &rarr;
                </a>
              </c:when>
              <c:when test="${sessionScope.user.role == 'VENDOR'}">
                <a href="${pageContext.request.contextPath}/dashboard/vendor" class="w-full py-2.5 rounded-xl bg-primary hover:bg-primarydk transition text-white text-xs font-bold shadow-sm flex items-center justify-center gap-2">
                  Return to Vendor Dashboard &rarr;
                </a>
              </c:when>
              <c:otherwise>
                <a href="${pageContext.request.contextPath}/browse-products.jsp" class="w-full py-2.5 rounded-xl bg-primary hover:bg-primarydk transition text-white text-xs font-bold shadow-sm flex items-center justify-center gap-2">
                  Return to Customer Portal &rarr;
                </a>
              </c:otherwise>
            </c:choose>
            
            <a href="${pageContext.request.contextPath}/logout" class="w-full py-2.5 rounded-xl border border-line hover:bg-bg transition text-ink text-xs font-semibold">
                Sign in with Different Account
            </a>
        </div>
    </div>
</body>
</html>