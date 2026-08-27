<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sign in :: NexTrade SCM</title>
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
    .route-line{ background-image:linear-gradient(to right,rgba(255,255,255,.25) 60%, transparent 0%); background-size:10px 2px; background-repeat:repeat-x; height:2px; }
    .role-tab{ transition:.15s; cursor:pointer; }
    .role-tab.active{ background:#fff; color:#12172B; box-shadow:0 1px 2px rgba(0,0,0,.06); }
    .role-tab:not(.active){ color:#8A93AC; }
  </style>
</head>
<body class="bg-bg text-ink">
<div class="min-h-screen flex">

  <div class="hidden lg:flex w-[46%] bg-sidebar relative flex-col justify-between p-12 overflow-hidden">
    <div class="absolute inset-0 opacity-[0.07]" style="background-image:radial-gradient(circle at 1px 1px, #fff 1px, transparent 0); background-size:24px 24px;"></div>

    <div class="relative flex items-center gap-2">
      <div class="w-9 h-9 rounded-md bg-primary flex items-center justify-center font-display font-bold text-white">N</div>
      <span class="font-display font-semibold text-white">NexTrade SCM</span>
    </div>

    <div class="relative">
      <div class="font-mono text-[11px] text-teal tracking-[0.2em] uppercase mb-4">Live Network Snapshot</div>
      <h2 class="font-display text-3xl text-white leading-tight mb-8">50+ countries.<br>One control tower.</h2>

      <div class="bg-white/5 border border-white/10 rounded-xl p-6">
        <div class="flex items-center justify-between font-mono text-[10px] text-white/40 uppercase mb-3">
          <span>SHP-20260702-001</span><span>Colombo &rarr; Dubai</span>
        </div>
        <div class="flex items-center gap-0">
          <div class="w-3.5 h-3.5 rounded-full bg-teal flex-shrink-0"></div>
          <div class="flex-1 route-line mx-1"></div>
          <div class="w-3.5 h-3.5 rounded-full bg-teal flex-shrink-0"></div>
          <div class="flex-1 route-line mx-1"></div>
          <div class="w-3.5 h-3.5 rounded-full border-2 border-primary bg-sidebar flex-shrink-0"></div>
          <div class="flex-1 route-line mx-1"></div>
          <div class="w-3.5 h-3.5 rounded-full border-2 border-white/20 bg-transparent flex-shrink-0"></div>
        </div>
        <div class="flex justify-between font-mono text-[10px] text-white/40 mt-3">
          <span>Origin</span><span>Customs</span><span class="text-primary">In transit</span><span>Delivery</span>
        </div>
      </div>

      <div class="grid grid-cols-3 gap-4 mt-8">
        <div><div class="font-display text-2xl text-white">1,248</div><div class="font-mono text-[10px] text-white/40 uppercase tracking-wide">Active shipments</div></div>
        <div><div class="font-display text-2xl text-white">99.9%</div><div class="font-mono text-[10px] text-white/40 uppercase tracking-wide">Uptime SLA</div></div>
        <div><div class="font-display text-2xl text-amber">6</div><div class="font-mono text-[10px] text-white/40 uppercase tracking-wide">Open exceptions</div></div>
      </div>
    </div>

    <div class="relative font-mono text-[10px] text-white/30">&copy; 2026 GlobalTrade Logistics Corporation</div>
  </div>

  <div class="flex-1 flex items-center justify-center p-8">
    <div class="w-full max-w-sm">
      <div class="lg:hidden flex items-center gap-2 mb-8">
        <div class="w-8 h-8 rounded-md bg-primary flex items-center justify-center font-display font-bold text-white text-sm">N</div>
        <span class="font-display font-semibold">NexTrade SCM</span>
      </div>

      <h1 class="font-display text-2xl font-semibold mb-1">Sign in to your account</h1>
      <p class="text-sm text-ink/50 mb-6">Select your portal and enter your credentials.</p>

      <div class="grid grid-cols-4 gap-1 p-1 bg-line/50 rounded-lg mb-6 font-mono text-[10px] uppercase tracking-wide">
        <button type="button" class="role-tab active rounded-md py-2 font-semibold" onclick="selectRole('admin', this)">Admin</button>
        <button type="button" class="role-tab rounded-md py-2 font-semibold" onclick="selectRole('whmanager', this)">WH Mgr</button>
        <button type="button" class="role-tab rounded-md py-2 font-semibold" onclick="selectRole('vendor', this)">Vendor</button>
        <button type="button" class="role-tab rounded-md py-2 font-semibold" onclick="selectRole('customer', this)">Customer</button>
      </div>

      <% if (request.getAttribute("error") != null) { %>
        <div class="mb-6 p-3 rounded-lg bg-amber/10 border border-amber/20 flex items-start gap-3 text-amber">
          <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
          <div class="text-sm font-medium"><%= request.getAttribute("error") %></div>
        </div>
      <% } %>

      <form action="<%= request.getContextPath() %>/login" method="POST" class="space-y-4">
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1.5">Username</label>
          <input id="usernameInput" name="username" required type="text" placeholder="admin01" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm font-mono focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
        </div>
        <div>
          <label class="block text-xs font-medium text-ink/60 mb-1.5">Password</label>
          <input type="password" name="password" required placeholder="••••••••••" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
        </div>
        <div class="flex items-center justify-between text-xs">
          <label class="flex items-center gap-2 text-ink/60"><input type="checkbox" class="rounded border-line"> Keep me signed in</label>
          <a href="#" class="text-primary font-medium hover:underline">Forgot password?</a>
        </div>
        <button type="submit" class="w-full py-2.5 rounded-lg bg-primary hover:bg-primarydk transition text-white text-sm font-semibold shadow-sm shadow-primary/30">
          Sign in as <span id="signInRoleLabel">Admin</span>
        </button>
      </form>

      <p class="text-xs text-ink/50 mt-6 text-center">
        New vendor or customer? <a href="register.jsp" class="text-primary font-medium hover:underline">Create an account</a>
      </p>
      <p class="text-xs text-ink/40 mt-2 text-center">Trouble signing in? Contact your logistics coordinator or system admin.</p>
    </div>
  </div>
</div>

<script>
  var dashboards = {
    admin:     'dashboard-admin.jsp',
    whmanager: 'dashboard-wh.jsp',
    vendor:    'dashboard-vendor.jsp',
    customer:  'browse-products.jsp'
  };
  var placeholders = {
    admin:     'admin01',
    whmanager: 'whmgr01',
    vendor:    'vendor01',
    customer:  'cust01'
  };
  var roleLabels = {
    admin: 'Admin', whmanager: 'WH Manager', vendor: 'Vendor', customer: 'Customer'
  };
  var selectedRole = 'admin';

  function selectRole(role, btnEl) {
    selectedRole = role;
    document.querySelectorAll('.role-tab').forEach(function(t){ t.classList.remove('active'); });
    btnEl.classList.add('active');
    document.getElementById('usernameInput').placeholder = placeholders[role];
    document.getElementById('signInRoleLabel').textContent = roleLabels[role];
  }

  function doSignIn() {
    window.location.href = dashboards[selectedRole] || 'dashboard-admin.jsp';
  }
</script>
</body>
</html>
