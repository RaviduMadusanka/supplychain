<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Browse Products :: NexTrade SCM</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          ink:'#12172B', bg:'#F5F6FA', line:'#E4E7EF',
          primary:'#2547D0', primarydk:'#1B34A6', teal:'#0EA5A4', amber:'#E0572B'
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
  body{ font-family:'Inter',sans-serif; background:#F5F6FA; color:#12172B; padding-bottom:100px; }
  .font-display{ font-family:'Space Grotesk',sans-serif; }
  .font-mono{ font-family:'JetBrains Mono',monospace; }
  .card{ background:#fff; border:1px solid #E4E7EF; border-radius:12px; transition:0.2s; }
  .card:hover{ border-color:#2547D0; box-shadow:0 4px 20px rgba(37,71,208,0.08); transform:translateY(-2px); }
  
  .tag{ display:inline-flex; align-items:center; gap:.4rem; padding:.22rem .65rem; border-radius:4px; font-family:'JetBrains Mono',monospace; font-size:.68rem; font-weight:600; letter-spacing:.06em; text-transform:uppercase; }
  .tag-dot{ width:6px; height:6px; border-radius:50%; }
  .tag-teal{ background:#E3F7F6; color:#0B6E6D; } .tag-teal .tag-dot{ background:#0EA5A4; }
  .tag-amber{ background:#FDECE4; color:#A63D1B; } .tag-amber .tag-dot{ background:#E0572B; }
  .tag-slate{ background:#EEF0F5; color:#525A72; } .tag-slate .tag-dot{ background:#8A93AC; }
</style>
</head>
<body>

<header class="h-16 bg-white border-b border-line flex items-center justify-between px-8 sticky top-0 z-40">
  <div class="flex items-center gap-8">
    <div class="flex items-center gap-2">
      <div class="w-8 h-8 rounded-md bg-primary flex items-center justify-center font-display font-bold text-white text-sm">N</div>
      <div class="flex flex-col">
        <span class="font-display font-semibold text-sm leading-tight">NexTrade SCM</span>
        <span class="font-mono text-[9px] text-ink/40 tracking-wider">CUSTOMER PORTAL</span>
      </div>
    </div>
    <nav class="hidden md:flex gap-6">
      <a href="browse-products.jsp" class="text-sm font-semibold text-primary border-b-2 border-primary py-5">Browse Products</a>
      <a href="dashboard-customer.jsp" class="text-sm font-medium text-ink/50 hover:text-ink transition py-5 border-b-2 border-transparent">My Orders</a>
    </nav>
  </div>
  <div class="flex items-center gap-4">
    <div class="flex items-center gap-2">
      <div class="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-display text-sm font-semibold">C</div>
      <span class="text-sm font-medium">Colombo Retail Hub</span>
    </div>
    <div class="w-px h-6 bg-line"></div>
    <a href="login.jsp" class="text-xs font-semibold text-ink/50 hover:text-amber transition">Sign out</a>
  </div>
</header>

<main class="max-w-6xl mx-auto p-8">
  <div class="flex items-center justify-between mb-8">
    <div>
      <h1 class="font-display text-2xl font-semibold mb-1">Product Catalog</h1>
      <p class="text-sm text-ink/50">Browse and order inventory from global vendors.</p>
    </div>
    <div class="flex gap-3">
      <select class="px-4 py-2 border border-line rounded-lg text-sm bg-white focus:border-primary focus:outline-none">
        <option>All Categories</option>
        <option>Electronics</option>
        <option>Hardware</option>
        <option>Packaging</option>
      </select>
      <div class="relative">
        <svg class="w-4 h-4 absolute left-3 top-2.5 text-ink/40" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
        <input type="text" placeholder="Search SKU or name..." class="pl-9 pr-4 py-2 border border-line rounded-lg text-sm bg-white focus:border-primary focus:outline-none w-64">
      </div>
    </div>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <!-- Card 1 -->
    <div class="card p-6 flex flex-col h-full">
      <div class="flex justify-between items-start mb-4">
        <span class="px-2 py-1 rounded bg-bg text-ink/60 border border-line text-[11px] font-semibold tracking-wide uppercase">Electronics</span>
        <span class="font-mono text-xs text-ink/40">SKU-1001</span>
      </div>
      <h3 class="font-display font-semibold text-lg mb-1 leading-tight">Industrial Circuit Board</h3>
      <p class="text-sm text-ink/50 mb-6 flex-1">High-performance control board for heavy machinery.</p>
      
      <div class="flex items-end justify-between mb-6">
        <div>
          <div class="text-[11px] text-ink/50 font-medium mb-1">Unit Price</div>
          <div class="font-mono text-2xl font-semibold">$85.00</div>
        </div>
        <span class="tag tag-teal"><span class="tag-dot"></span>In Stock (420)</span>
      </div>
      
      <button class="w-full py-2.5 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition shadow-sm shadow-primary/20">Add to Order</button>
    </div>

    <!-- Card 2 -->
    <div class="card p-6 flex flex-col h-full">
      <div class="flex justify-between items-start mb-4">
        <span class="px-2 py-1 rounded bg-bg text-ink/60 border border-line text-[11px] font-semibold tracking-wide uppercase">Hardware</span>
        <span class="font-mono text-xs text-ink/40">SKU-1002</span>
      </div>
      <h3 class="font-display font-semibold text-lg mb-1 leading-tight">Steel Cargo Container Lock</h3>
      <p class="text-sm text-ink/50 mb-6 flex-1">Heavy-duty maritime security lock.</p>
      
      <div class="flex items-end justify-between mb-6">
        <div>
          <div class="text-[11px] text-ink/50 font-medium mb-1">Unit Price</div>
          <div class="font-mono text-2xl font-semibold">$29.20</div>
        </div>
        <span class="tag tag-amber"><span class="tag-dot"></span>Low Stock (45)</span>
      </div>
      
      <button class="w-full py-2.5 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition shadow-sm shadow-primary/20">Add to Order</button>
    </div>

    <!-- Card 3 -->
    <div class="card p-6 flex flex-col h-full bg-white/50">
      <div class="flex justify-between items-start mb-4">
        <span class="px-2 py-1 rounded bg-bg text-ink/60 border border-line text-[11px] font-semibold tracking-wide uppercase">Packaging</span>
        <span class="font-mono text-xs text-ink/40">SKU-1003</span>
      </div>
      <h3 class="font-display font-semibold text-lg mb-1 leading-tight text-ink/70">Packaging Wrap Roll 500m</h3>
      <p class="text-sm text-ink/40 mb-6 flex-1">Industrial grade shrink wrap for pallets.</p>
      
      <div class="flex items-end justify-between mb-6 opacity-70">
        <div>
          <div class="text-[11px] text-ink/50 font-medium mb-1">Unit Price</div>
          <div class="font-mono text-2xl font-semibold">$49.50</div>
        </div>
        <span class="tag tag-slate"><span class="tag-dot"></span>Out of Stock</span>
      </div>
      
      <button disabled class="w-full py-2.5 rounded-lg bg-line text-ink/40 text-sm font-semibold cursor-not-allowed">Add to Order</button>
    </div>
  </div>
</main>

<div class="fixed bottom-0 left-0 right-0 bg-white border-t border-line p-4 shadow-[0_-10px_30px_rgba(0,0,0,0.05)] z-50">
  <div class="max-w-6xl mx-auto flex items-center justify-between">
    <div class="flex items-center gap-4">
      <div class="w-12 h-12 rounded-lg bg-bg border border-line flex items-center justify-center relative">
        <svg class="w-6 h-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
        <span class="absolute -top-2 -right-2 w-5 h-5 rounded-full bg-amber text-white text-[10px] font-bold flex items-center justify-center border-2 border-white">0</span>
      </div>
      <div>
        <div class="text-xs font-medium text-ink/50 mb-0.5">Order Summary</div>
        <div class="font-mono text-lg font-semibold leading-none">0 items &middot; $0.00</div>
      </div>
    </div>
    <button class="px-8 py-3 rounded-lg bg-primary text-white font-semibold shadow-sm hover:bg-primarydk transition flex items-center gap-2" onclick="alert('Proceed to Place Order UI')">
      Proceed to Order <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
    </button>
  </div>
</div>

</body>
</html>
