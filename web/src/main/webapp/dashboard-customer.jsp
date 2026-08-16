<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Orders :: NexTrade SCM</title>
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
  .tag-blue{ background:#EAEEFC; color:#1B34A6; } .tag-blue .tag-dot{ background:#2547D0; }
  .tag-teal{ background:#E3F7F6; color:#0B6E6D; } .tag-teal .tag-dot{ background:#0EA5A4; }
  .tag-slate{ background:#EEF0F5; color:#525A72; } .tag-slate .tag-dot{ background:#8A93AC; }
</style>
</head>
<body class="bg-bg text-ink">
<header class="h-16 bg-white border-b border-line flex items-center justify-between px-8">
  <div class="flex items-center">
    <div class="w-8 h-8 rounded-md bg-primary flex items-center justify-center font-display font-bold text-white text-sm mr-2">N</div>
    <span class="font-display font-semibold">NexTrade SCM</span><span class="ml-2 text-xs text-ink/40 font-mono">CUSTOMER PORTAL</span>
  </div>
  <div class="flex items-center gap-2">
    <div class="w-8 h-8 rounded-full bg-primary flex items-center justify-center text-white text-xs font-semibold">C</div>
    <span class="text-sm font-medium">Colombo Retail Hub</span>
  </div>
</header>

<main class="max-w-5xl mx-auto p-8">
  <h1 class="font-display text-2xl font-semibold mb-1">Welcome back</h1>
  <p class="text-sm text-ink/50 mb-8">Track your orders and shipments in one place.</p>

  <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
    <div class="card p-5"><div class="text-xs text-ink/50 mb-1">Total Orders</div><div class="font-display text-3xl font-semibold">1</div></div>
    <div class="card p-5"><div class="text-xs text-ink/50 mb-1">In Transit</div><div class="font-display text-3xl font-semibold text-primary">1</div></div>
    <div class="card p-5"><div class="text-xs text-ink/50 mb-1">Delivered</div><div class="font-display text-3xl font-semibold text-teal">0</div></div>
  </div>

  <div class="card mb-6">
    <div class="px-5 py-4 border-b border-line flex items-center justify-between">
      <h3 class="font-display font-semibold text-sm">Your Orders</h3>
    </div>
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
        <th class="px-5 py-2.5 font-medium">Order</th><th class="px-5 py-2.5 font-medium">Total</th><th class="px-5 py-2.5 font-medium">Placed</th><th class="px-5 py-2.5 font-medium">Status</th><th class="px-5 py-2.5 font-medium"></th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr>
          <td class="px-5 py-3 font-mono text-xs">ORD-20260701-001</td>
          <td class="px-5 py-3 font-mono">$4,250.00</td>
          <td class="px-5 py-3 text-xs text-ink/40 font-mono">01 Jul 2026</td>
          <td class="px-5 py-3"><span class="tag tag-blue"><span class="tag-dot"></span>Processing</span></td>
          <td class="px-5 py-3 text-right"><a href="shipment-tracking.jsp" class="text-primary text-xs font-medium hover:underline">Track shipment &rarr;</a></td>
        </tr>
      </tbody>
    </table>
  </div>

  <button class="px-5 py-2.5 rounded-lg bg-primary text-white text-sm font-semibold shadow-sm shadow-primary/30">+ Place New Order</button>
</main>
</body>
</html>
