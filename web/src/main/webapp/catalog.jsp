<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Browse Products :: NexTrade SCM</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = { theme: { extend: { colors: {
    ink:'#12172B', sidebar:'#0B1220', primary:'#2547D0', teal:'#0EA5A4', amber:'#E0572B', line:'#E4E7EF', bg:'#F5F6FA'
  }, fontFamily: { display:['"Space Grotesk"','sans-serif'], body:['Inter','sans-serif'], mono:['"JetBrains Mono"','monospace'] } } } }
</script>
<style>
  body{ font-family:'Inter',sans-serif; } .font-display{ font-family:'Space Grotesk',sans-serif; } .font-mono{ font-family:'JetBrains Mono',monospace; }
  .card{ background:#fff; border:1px solid #E4E7EF; border-radius:10px; }
  .tag{ display:inline-flex; align-items:center; gap:.4rem; padding:.22rem .65rem; border-radius:4px; font-family:'JetBrains Mono',monospace; font-size:.68rem; font-weight:600; letter-spacing:.06em; text-transform:uppercase; }
  .tag-dot{ width:6px; height:6px; border-radius:50%; }
  .tag-teal{ background:#E3F7F6; color:#0B6E6D; } .tag-teal .tag-dot{ background:#0EA5A4; }
  .tag-amber{ background:#FDECE4; color:#A63D1B; } .tag-amber .tag-dot{ background:#E0572B; }
</style>
</head>
<body class="bg-bg text-ink">
<header class="h-16 bg-white border-b border-line flex items-center justify-between px-8">
  <div class="flex items-center">
    <div class="w-8 h-8 rounded-md bg-primary flex items-center justify-center font-display font-bold text-white text-sm mr-2">N</div>
    <span class="font-display font-semibold">NexTrade SCM</span><span class="ml-2 text-xs text-ink/40 font-mono">CUSTOMER PORTAL</span>
  </div>
  <div class="flex items-center gap-4">
    <a href="dashboard-customer.jsp" class="text-sm text-ink/60 hover:text-ink">My Orders</a>
    <div class="w-8 h-8 rounded-full bg-primary flex items-center justify-center text-white text-xs font-semibold">C</div>
  </div>
</header>

<main class="max-w-5xl mx-auto p-8">
  <div class="flex items-center justify-between mb-6">
    <div>
      <h1 class="font-display text-2xl font-semibold mb-1">Browse Products</h1>
      <p class="text-sm text-ink/50">3 products available across our warehouse network</p>
    </div>
    <input type="text" placeholder="Search products..." class="w-64 px-3.5 py-2 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
  </div>

  <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
    <div class="card p-5">
      <div class="w-10 h-10 rounded-lg bg-primsoft bg-[#EAEEFC] text-primary flex items-center justify-center mb-3">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
      </div>
      <div class="font-medium text-sm mb-0.5">Industrial Circuit Board</div>
      <div class="text-xs text-ink/40 font-mono mb-3">SKU-1001 &middot; Electronics</div>
      <div class="flex items-center justify-between mb-4">
        <span class="font-display text-lg font-semibold">$85.00</span>
        <span class="tag tag-teal"><span class="tag-dot"></span>420 in stock</span>
      </div>
      <button onclick="window.location.href='checkout.jsp?sku=SKU-1001'" class="w-full py-2 rounded-lg bg-primary hover:bg-primarydk transition text-white text-sm font-semibold">Order Now</button>
    </div>

    <div class="card p-5">
      <div class="w-10 h-10 rounded-lg bg-[#EAEEFC] text-primary flex items-center justify-center mb-3">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
      </div>
      <div class="font-medium text-sm mb-0.5">Steel Cargo Container Lock</div>
      <div class="text-xs text-ink/40 font-mono mb-3">SKU-1002 &middot; Hardware</div>
      <div class="flex items-center justify-between mb-4">
        <span class="font-display text-lg font-semibold">$29.20</span>
        <span class="tag tag-amber"><span class="tag-dot"></span>45 left</span>
      </div>
      <button onclick="window.location.href='checkout.jsp?sku=SKU-1002'" class="w-full py-2 rounded-lg bg-primary hover:bg-primarydk transition text-white text-sm font-semibold">Order Now</button>
    </div>

    <div class="card p-5">
      <div class="w-10 h-10 rounded-lg bg-[#EAEEFC] text-primary flex items-center justify-center mb-3">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4M4 12l6-6M4 12l6 6"/></svg>
      </div>
      <div class="font-medium text-sm mb-0.5">Packaging Wrap Roll 500m</div>
      <div class="text-xs text-ink/40 font-mono mb-3">SKU-1003 &middot; Packaging Materials</div>
      <div class="flex items-center justify-between mb-4">
        <span class="font-display text-lg font-semibold">$49.50</span>
        <span class="tag tag-amber"><span class="tag-dot"></span>Out of stock</span>
      </div>
      <button disabled class="w-full py-2 rounded-lg bg-line text-ink/30 text-sm font-semibold cursor-not-allowed">Out of Stock</button>
    </div>
  </div>
</main>
</body>
</html>
