<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Track Shipment :: NexTrade SCM</title>
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
  .route-line{ background-image:linear-gradient(to right,#C7CCDD 60%, transparent 0%); background-size:10px 2px; background-repeat:repeat-x; height:2px; }
  .route-node{ width:16px; height:16px; border-radius:50%; border:3px solid #2547D0; background:#fff; }
  .route-node.done{ border-color:#0EA5A4; background:#0EA5A4; }
</style>
</head>
<body class="bg-bg text-ink">
<header class="h-16 bg-white border-b border-line flex items-center px-8">
  <div class="w-8 h-8 rounded-md bg-primary flex items-center justify-center font-display font-bold text-white text-sm mr-2">N</div>
  <span class="font-display font-semibold">NexTrade SCM</span><span class="ml-2 text-xs text-ink/40 font-mono">CUSTOMER PORTAL</span>
</header>

<main class="max-w-3xl mx-auto p-8">
  <div class="flex gap-2 mb-8">
    <input type="text" value="SHP-20260702-001" class="flex-1 px-4 py-3 rounded-lg border border-line font-mono text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
    <button class="px-5 py-3 rounded-lg bg-primary text-white text-sm font-semibold">Track</button>
  </div>

  <div class="card p-8">
    <div class="flex items-center justify-between mb-1">
      <span class="font-mono text-xs text-ink/40">SHP-20260702-001</span>
      <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-[#EAEEFC] text-primary text-xs font-mono font-semibold uppercase"><span class="w-1.5 h-1.5 rounded-full bg-primary"></span>In Transit</span>
    </div>
    <h1 class="font-display text-2xl font-semibold mb-6">Colombo &rarr; Colombo City</h1>

    <div class="flex items-center gap-0 mb-3 mt-10">
      <div class="route-node done"></div><div class="flex-1 route-line" style="background-image:none;background:#0EA5A4"></div>
      <div class="route-node done"></div><div class="flex-1 route-line" style="background-image:none;background:#0EA5A4"></div>
      <div class="route-node"></div><div class="flex-1 route-line"></div>
      <div class="route-node border-slate-300"></div>
    </div>
    <div class="grid grid-cols-4 text-center gap-2 mb-10">
      <div><div class="text-xs font-semibold">Picked Up</div><div class="text-[11px] text-ink/40 font-mono mt-0.5">02 Jul, 10:00 AM</div></div>
      <div><div class="text-xs font-semibold">Customs Cleared</div><div class="text-[11px] text-ink/40 font-mono mt-0.5">03 Jul, 9:00 AM</div></div>
      <div><div class="text-xs font-semibold text-primary">In Transit</div><div class="text-[11px] text-ink/40 font-mono mt-0.5">Currently here</div></div>
      <div><div class="text-xs font-semibold text-ink/30">Delivery</div><div class="text-[11px] text-ink/30 font-mono mt-0.5">Est. 08 Jul, 5:00 PM</div></div>
    </div>

    <div class="grid grid-cols-2 gap-4 pt-6 border-t border-line text-sm">
      <div><div class="text-xs text-ink/40 mb-1">Carrier</div><div class="font-medium">DHL Express</div></div>
      <div><div class="text-xs text-ink/40 mb-1">Estimated Delivery</div><div class="font-medium">08 Jul 2026, 5:00 PM</div></div>
      <div><div class="text-xs text-ink/40 mb-1">Origin Warehouse</div><div class="font-medium">Colombo Central Warehouse</div></div>
      <div><div class="text-xs text-ink/40 mb-1">Items</div><div class="font-medium">50 &times; Industrial Circuit Board</div></div>
    </div>
  </div>

  <p class="text-center text-xs text-ink/40 mt-6">Need help with this shipment? Contact your logistics coordinator.</p>
</main>
</body>
</html>
