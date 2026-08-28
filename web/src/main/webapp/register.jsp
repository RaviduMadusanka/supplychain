<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create Account :: NexTrade SCM</title>
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
  .role-tab{ transition:.15s; cursor:pointer; }
  .role-tab.active{ background:#fff; color:#12172B; box-shadow:0 1px 2px rgba(0,0,0,.06); }
  .role-tab:not(.active){ color:#8A93AC; }
  .card{ background:#fff; border:1px solid #E4E7EF; border-radius:12px; }
</style>
</head>
<body class="bg-bg text-ink min-h-screen flex items-center justify-center p-6">

  <div class="w-full max-w-lg">
    <div class="flex items-center gap-2 justify-center mb-8">
      <div class="w-8 h-8 rounded-md bg-primary flex items-center justify-center font-display font-bold text-white text-sm">N</div>
      <span class="font-display font-semibold">NexTrade SCM</span>
    </div>

    <div class="card p-8">
      <h1 class="font-display text-2xl font-semibold mb-1 text-center">Create your account</h1>
      <p class="text-sm text-ink/50 mb-6 text-center">Vendor and customer portal access is self-service. Staff and customs accounts are provisioned by an administrator.</p>

      <div class="grid grid-cols-2 gap-1 p-1 bg-line/50 rounded-lg mb-6 font-mono text-[10px] uppercase tracking-wide">
        <button type="button" class="role-tab active rounded-md py-2 font-semibold" onclick="selectRole('vendor', this)">Vendor</button>
        <button type="button" class="role-tab rounded-md py-2 font-semibold" onclick="selectRole('customer', this)">Customer</button>
      </div>

      <form class="space-y-4" onsubmit="return false;">
        <div class="grid grid-cols-2 gap-3">
          <div>
            <label class="block text-xs font-medium text-ink/60 mb-1.5">Username</label>
            <input type="text" placeholder="e.g. vendor02" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm font-mono focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
          </div>
          <div>
            <label class="block text-xs font-medium text-ink/60 mb-1.5">Email</label>
            <input type="email" placeholder="you@company.com" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
          </div>
        </div>
        <div class="grid grid-cols-2 gap-3">
          <div>
            <label class="block text-xs font-medium text-ink/60 mb-1.5">Password</label>
            <input type="password" placeholder="••••••••••" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
          </div>
          <div>
            <label class="block text-xs font-medium text-ink/60 mb-1.5">Confirm Password</label>
            <input type="password" placeholder="••••••••••" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
          </div>
        </div>

        <div class="pt-2 border-t border-line"></div>

        <div id="vendorFields" class="space-y-4">
          <div>
            <label class="block text-xs font-medium text-ink/60 mb-1.5">Company Name</label>
            <input type="text" placeholder="e.g. Apex Tech Components" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
          </div>
          <div>
            <label class="block text-xs font-medium text-ink/60 mb-1.5">Contact Person</label>
            <input type="text" placeholder="Full name" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
          </div>
          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-xs font-medium text-ink/60 mb-1.5">Phone</label>
              <input type="text" placeholder="+94 7X XXX XXXX" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
            </div>
            <div>
              <label class="block text-xs font-medium text-ink/60 mb-1.5">Country</label>
              <input type="text" placeholder="Country" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
            </div>
          </div>
        </div>

        <div id="customerFields" class="space-y-4 hidden">
          <div>
            <label class="block text-xs font-medium text-ink/60 mb-1.5">Full Name / Business Name</label>
            <input type="text" placeholder="e.g. Colombo Retail Hub" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
          </div>
          <div>
            <label class="block text-xs font-medium text-ink/60 mb-1.5">Delivery Address</label>
            <textarea rows="2" placeholder="Street, city" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary"></textarea>
          </div>
          <div class="grid grid-cols-2 gap-3">
            <div>
              <label class="block text-xs font-medium text-ink/60 mb-1.5">Phone</label>
              <input type="text" placeholder="+94 1X XXX XXXX" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
            </div>
            <div>
              <label class="block text-xs font-medium text-ink/60 mb-1.5">Country</label>
              <input type="text" placeholder="Country" class="w-full px-3.5 py-2.5 rounded-lg border border-line bg-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
            </div>
          </div>
        </div>

        <label class="flex items-start gap-2 text-xs text-ink/60 pt-2">
          <input type="checkbox" class="rounded border-line mt-0.5">
          I agree to the terms of service and confirm the information above is accurate.
        </label>

        <button type="button" onclick="window.location.href='login.jsp'" class="w-full py-2.5 rounded-lg bg-primary hover:bg-primarydk transition text-white text-sm font-semibold shadow-sm shadow-primary/30">
          Create <span id="createRoleLabel">Vendor</span> Account
        </button>
      </form>
    </div>

    <p class="text-xs text-ink/50 mt-6 text-center">
      Already have an account? <a href="login.jsp" class="text-primary font-medium hover:underline">Sign in</a>
    </p>
  </div>

<script>
  var roleLabels = { vendor: 'Vendor', customer: 'Customer' };

  function selectRole(role, btnEl) {
    document.querySelectorAll('.role-tab').forEach(function(t){ t.classList.remove('active'); });
    btnEl.classList.add('active');

    document.getElementById('vendorFields').classList.toggle('hidden', role !== 'vendor');
    document.getElementById('customerFields').classList.toggle('hidden', role !== 'customer');
    document.getElementById('createRoleLabel').textContent = roleLabels[role];
  }
</script>
</body>
</html>
