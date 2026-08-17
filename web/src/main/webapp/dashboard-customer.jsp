<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Orders :: NexTrade SCM</title>
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
  body{ font-family:'Inter',sans-serif; background:#F5F6FA; color:#12172B; }
  .font-display{ font-family:'Space Grotesk',sans-serif; }
  .font-mono{ font-family:'JetBrains Mono',monospace; }
  .card{ background:#fff; border:1px solid #E4E7EF; border-radius:12px; }
  
  .tag{ display:inline-flex; align-items:center; gap:.4rem; padding:.22rem .65rem; border-radius:4px; font-family:'JetBrains Mono',monospace; font-size:.68rem; font-weight:600; letter-spacing:.06em; text-transform:uppercase; }
  .tag-dot{ width:6px; height:6px; border-radius:50%; }
  .tag-blue{ background:#EAEEFC; color:#1B34A6; } .tag-blue .tag-dot{ background:#2547D0; }
  .tag-teal{ background:#E3F7F6; color:#0B6E6D; } .tag-teal .tag-dot{ background:#0EA5A4; }
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
      <a href="browse-products.jsp" class="text-sm font-medium text-ink/50 hover:text-ink transition py-5 border-b-2 border-transparent">Browse Products</a>
      <a href="dashboard-customer.jsp" class="text-sm font-semibold text-primary border-b-2 border-primary py-5">My Orders</a>
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

<main class="max-w-5xl mx-auto p-8">
  <div class="flex items-end justify-between mb-8">
    <div>
      <h1 class="font-display text-2xl font-semibold mb-1">Welcome back</h1>
      <p class="text-sm text-ink/50">Track your orders and shipments in one place.</p>
    </div>
    <a href="browse-products.jsp" class="px-5 py-2.5 rounded-lg bg-primary text-white text-sm font-semibold shadow-sm hover:bg-primarydk transition">+ Place New Order</a>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
    <div class="card p-5">
      <div class="text-xs font-medium text-ink/50 mb-1">Total Orders</div>
      <div class="font-display text-3xl font-semibold">1</div>
    </div>
    <div class="card p-5 border-primary/20 bg-primary/5">
      <div class="text-xs font-semibold text-primary mb-1">In Transit</div>
      <div class="font-display text-3xl font-semibold text-primary">1</div>
    </div>
    <div class="card p-5">
      <div class="text-xs font-medium text-ink/50 mb-1">Delivered</div>
      <div class="font-display text-3xl font-semibold text-teal">0</div>
    </div>
  </div>

  <div class="card mb-6 overflow-hidden">
    <div class="px-5 py-4 border-b border-line bg-bg/50">
      <h3 class="font-display font-semibold text-sm">Your Orders</h3>
    </div>
    <table class="w-full text-sm">
      <thead>
        <tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
          <th class="px-5 py-3 font-medium">Order Ref</th>
          <th class="px-5 py-3 font-medium text-right">Total</th>
          <th class="px-5 py-3 font-medium">Placed</th>
          <th class="px-5 py-3 font-medium">Status</th>
          <th class="px-5 py-3 font-medium text-right"></th>
        </tr>
      </thead>
      <tbody class="divide-y divide-line">
        <tr class="hover:bg-bg/50 transition">
          <td class="px-5 py-4 font-mono font-medium text-ink">ORD-20260701-001</td>
          <td class="px-5 py-4 font-mono text-right font-semibold">$4,250.00</td>
          <td class="px-5 py-4 text-xs font-mono text-ink/60">01 Jul 2026</td>
          <td class="px-5 py-4"><span class="tag tag-blue"><span class="tag-dot"></span>Processing</span></td>
          <td class="px-5 py-4 text-right">
            <a href="shipment-tracking.jsp" class="text-primary text-xs font-semibold hover:underline">Track shipment &rarr;</a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</main>

</body>
</html>
